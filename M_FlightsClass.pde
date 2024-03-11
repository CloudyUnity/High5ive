import java.util.Arrays;
import java.util.Comparator;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import java.util.concurrent.*;
import java.util.HashMap;
import java.nio.channels.FileChannel;
import java.nio.*;
import java.io.*;


public enum FlightQueryType {
  DAY,
  CARRIER_CODE_INDEX,
  FLIGHT_NUMBER,
  AIRPORT_ORIGIN_INDEX,
  AIRPORT_DEST_INDEX,
  SCHEDULED_DEPARTURE_TIME,
  DEPARTURE_TIME,
  DEPARTURE_DELAY,
  SCHEDULED_ARRIVAL_TIME,
  ARRIVAL_TIME,
  ARRIVAL_DELAY,
  CANCELLED_OR_DIVERTED,
  MILES_DISTANCE,
}

public enum FlightQueryOperator {
  EQUAL,
  NOT_EQUAL,
  LESS_THAN,
  LESS_THAN_EQUAL,
  GREATER_THAN,
  GREATER_THAN_EQUAL,
}

public enum FlightQuerySortDirection {
  ASCENDING,
  DESCENDING,
}

class FlightType { // 23 bytes total
  public byte Day;                      // supports all querys
  public byte CarrierCodeIndex;         // only supports EQUAL or NOT_EQUAL
  public short FlightNumber;            // only supports EQUAL or NOT_EQUAL
  public short AirportOriginIndex;      // only supports EQUAL or NOT_EQUAL
  public short AirportDestIndex;        // only supports EQUAL or NOT_EQUAL
  public short ScheduledDepartureTime;  // supports all querys
  public short DepartureTime;           // supports all querys
  public short DepartureDelay;          // supports all querys
  public short ScheduledArrivalTime;    // supports all querys
  public short ArrivalTime;             // supports all querys
  public short ArrivalDelay;            // supports all querys
  public byte CancelledOrDiverted;      // only supports EQUAL or NOT_EQUAL
  public short MilesDistance;           // supports all querys

  public FlightType(
    byte day, byte carrierCodeIndex, short flightNumber,
    short airportOriginIndex, short airportDestIndex, short scheduledDepartureTime,
    short departureTime, short departureDelay, short scheduledArrivalTime, 
    short arrivalTime, short arrivalDelay, byte cancelledOrDiverted, 
    short milesDistance) {

    this.Day = day;
    this.CarrierCodeIndex = carrierCodeIndex;
    this.FlightNumber = flightNumber;
    this.AirportOriginIndex = airportOriginIndex;
    this.AirportDestIndex = airportDestIndex;
    this.ScheduledDepartureTime = scheduledDepartureTime;
    this.DepartureTime = departureTime;
    this.DepartureDelay = departureDelay;
    this.ScheduledArrivalTime = scheduledArrivalTime;
    this.ArrivalTime = arrivalTime;
    this.ArrivalDelay = arrivalDelay;
    this.CancelledOrDiverted = cancelledOrDiverted;
    this.MilesDistance = milesDistance;
  }

  public FlightType() {
  }
}

class FlightsManagerClass {
  private FlightType[] m_flightsList = new FlightType[NUMBER_OF_FLIGHT_FULL_LINES];
  private String[] m_airportCodesToName = new String[NUMBER_OF_AIRPORTS];
  private boolean m_working;

  public void init(int threadCount, Consumer<FlightType[]> onTaskComplete) {
    boolean result = convertBinaryFileToFlightType("flights_full.bin", threadCount, onTaskComplete);
    if (!result)
      return;
    // convertFileToAirportCodesToName();
  }

  public FlightType[] getFlightsList() {
    return m_flightsList;
  }

  private boolean convertBinaryFileToFlightType(String filename, int threadCount, Consumer<FlightType[]> onTaskComplete) {
    if (m_working) {
      println("Warning: m_working is true, convertBinaryFileToFlightType did not process correctly");
      return false;
    }

    new Thread(() -> {
      s_DebugProfiler.startProfileTimer();
      convertBinaryFileToFlightTypeAsync(filename, threadCount);
      s_DebugProfiler.printTimeTakenMillis("Raw file pre-processing");

      m_working = false;
      onTaskComplete.accept(m_flightsList);
    }
    ).start();

    m_working = true;
    return true;
  }

  private void convertBinaryFileToFlightTypeAsync(String filename, int threadCount) {
    MappedByteBuffer buffer;
    ExecutorService executor = Executors.newFixedThreadPool(threadCount);
    CountDownLatch latch = new CountDownLatch(threadCount);

    try (FileInputStream fis = new FileInputStream(sketchPath() + DATA_DIRECTOR_PATH + filename)) {
      FileChannel channel = fis.getChannel();
      buffer = channel.map(FileChannel.MapMode.READ_ONLY, 0, channel.size());
      long flightCount = channel.size() / LINE_BYTE_SIZE;
      m_flightsList = new FlightType[(int)flightCount];
      fis.close();
      channel.close();

      int chunkSize = (int)flightCount / threadCount;

      for (int i = 0; i < threadCount; i++) {
        int startPosition = i * chunkSize;
        long endPosition = (i == threadCount - 1) ? flightCount : (i + 1) * chunkSize;
        long processingSize = endPosition - startPosition;

        executor.submit(() -> {
          processConvertBinaryFileToFlightTypeChunk(buffer, processingSize, startPosition);
          latch.countDown();
        }
        );
      }
      try {
        latch.await();
      }
      catch (InterruptedException e) {
        e.printStackTrace();
      }
      finally {
        executor.shutdown();
      }
    }
    catch (IOException e) {
      println("Error: " + e);
      return;
    }
  }

  private void processConvertBinaryFileToFlightTypeChunk(MappedByteBuffer buffer, long processingSize, int startPosition) {
    s_DebugProfiler.startProfileTimer();

    long maxI = startPosition + processingSize;
    for (int i = startPosition; i < maxI; i++) {
      int offset = LINE_BYTE_SIZE * i;
      m_flightsList[i] = new FlightType(
        buffer.get(offset),
        buffer.get(offset+1),
        buffer.getShort(offset+2),
        buffer.getShort(offset+4),
        buffer.getShort(offset+6),
        buffer.getShort(offset+8),
        buffer.getShort(offset+10),
        buffer.getShort(offset+12),
        buffer.getShort(offset+14),
        buffer.get(offset+16),
        buffer.getShort(offset+17));
    }
    s_DebugProfiler.printTimeTakenMillis("Chunk " + startPosition);
  }

  private String[] convertFileToAirportCodesNames() {
    return new String[]{""};
  } // TODO Kyara

  public void queryFlights(FlightType[] flightsList, FlightQueryType queryType, FlightQueryOperator queryOperator, int queryValue, int threadCount, Consumer<FlightType[]> onTaskComplete) {
    if (m_working) {
      println("Warning: m_working is true, queryFlights did not process correctly");
      return;
    }

    new Thread(() -> {
      s_DebugProfiler.startProfileTimer();
      FlightType[] newFlightsList = queryFlightsAysnc(flightsList, queryType, queryOperator, queryValue, threadCount);
      s_DebugProfiler.printTimeTakenMillis("queryFlights");

      m_working = false;
      onTaskComplete.accept(newFlightsList);
    }
    ).start();

    m_working = true;
    return;
  }

  private FlightType[] queryFlightsAysnc(FlightType[] flightsList, FlightQueryType queryType, FlightQueryOperator queryOperator, int queryValue, int threadCount) {
    ExecutorService executor = Executors.newFixedThreadPool(threadCount);
    CountDownLatch latch = new CountDownLatch(threadCount);

    if (!checkForIllegalQuery(queryType, queryOperator)) {
      println("Error: QueryType is illegal with QueryOperator");
      return flightsList;
    }
    int chunkSize = NUMBER_OF_FLIGHT_FULL_LINES / threadCount;
    ArrayList<FlightType[]> listOfFlightsLists = new ArrayList<>();
    // Stream.Builder<FlightType> m_queryFlightsList = Stream.builder();

    for (int i = 0; i < threadCount; i++) {
      int startPosition = i * chunkSize;
      long endPosition = (i == threadCount - 1) ? NUMBER_OF_FLIGHT_FULL_LINES : (i + 1) * chunkSize;
      long processingSize = endPosition - startPosition;

      executor.submit(() -> {
        listOfFlightsLists.add(processQueryFlightsChunk(Arrays.copyOfRange(flightsList, startPosition, (int)endPosition), queryType, queryOperator, queryValue));
        latch.countDown();
      }
      );
    }
    try {
      latch.await();
    }
    catch (InterruptedException e) {
      e.printStackTrace();
    }
    finally {
      executor.shutdown();
      FlightType[] joinedFlightArray = listOfFlightsLists.stream()
        .flatMap(Arrays::stream)
        .toArray(FlightType[]::new);
      return joinedFlightArray;
    }
  }

  private FlightType[] processQueryFlightsChunk(FlightType[] flightsList, FlightQueryType queryType, FlightQueryOperator queryOperator, int queryValue) {
    switch(queryOperator) {
    case EQUAL:
      return Arrays.stream(flightsList)
        .filter(flight -> getFlightTypeFieldFromQueryType(flight, queryType) == queryValue)
        .toArray(FlightType[]::new);
    case NOT_EQUAL:
      return Arrays.stream(flightsList)
        .filter(flight -> getFlightTypeFieldFromQueryType(flight, queryType) != queryValue)
        .toArray(FlightType[]::new);
    case LESS_THAN:
      return Arrays.stream(flightsList)
        .filter(flight -> getFlightTypeFieldFromQueryType(flight, queryType) < queryValue)
        .toArray(FlightType[]::new);
    case LESS_THAN_EQUAL:
      return Arrays.stream(flightsList)
        .filter(flight -> getFlightTypeFieldFromQueryType(flight, queryType) <= queryValue)
        .toArray(FlightType[]::new);
    case GREATER_THAN:
      return Arrays.stream(flightsList)
        .filter(flight -> getFlightTypeFieldFromQueryType(flight, queryType) > queryValue)
        .toArray(FlightType[]::new);
    case GREATER_THAN_EQUAL:
      return Arrays.stream(flightsList)
        .filter(flight -> getFlightTypeFieldFromQueryType(flight, queryType) >= queryValue)
        .toArray(FlightType[]::new);
    default:
      println("Error: FlightQueryOperator invalid");
      return flightsList;
    }
  }

  public void queryFlightsWithinRange(FlightType[] flightsList, FlightQueryType queryType, int start, int end, int threadCount, Consumer<FlightType[]> onTaskComplete) {
    if (m_working) {
      println("Warning: m_working is true, queryFlightsWithinRange did not process correctly");
      return;
    }

    new Thread(() -> {
      s_DebugProfiler.startProfileTimer();
      FlightType[] newFlightsList = queryFlightsWithinRangeAysnc(flightsList, queryType, start, end, threadCount);
      s_DebugProfiler.printTimeTakenMillis("queryFlightsWithinRange");

      m_working = false;
      onTaskComplete.accept(newFlightsList);
    }
    ).start();

    m_working = true;
    return;
  }

  private FlightType[] queryFlightsWithinRangeAysnc(FlightType[] flightsList, FlightQueryType queryType, int start, int end, int threadCount) {
    ExecutorService executor = Executors.newFixedThreadPool(threadCount);
    CountDownLatch latch = new CountDownLatch(threadCount);

    if (!checkForIllegalQuery(queryType, FlightQueryOperator.GREATER_THAN_EQUAL)) {
      println("Error: FlightQueryType is illegal to query range");
      return flightsList;
    }

    int chunkSize = NUMBER_OF_FLIGHT_FULL_LINES / threadCount;
    ArrayList<FlightType[]> listOfFlightsLists = new ArrayList<>();

    for (int i = 0; i < threadCount; i++) {
      int startPosition = i * chunkSize;
      long endPosition = (i == threadCount - 1) ? NUMBER_OF_FLIGHT_FULL_LINES : (i + 1) * chunkSize;
      long processingSize = endPosition - startPosition;

      executor.submit(() -> {
        listOfFlightsLists.add(processQueryFlightsWithinRangeChunk(Arrays.copyOfRange(flightsList, startPosition, (int)endPosition), queryType, start, end));
        latch.countDown();
      }
      );
    }
    try {
      latch.await();
    }
    catch (InterruptedException e) {
      e.printStackTrace();
    }
    finally {
      executor.shutdown();
      FlightType[] joinedFlightArray = listOfFlightsLists.stream()
        .flatMap(Arrays::stream)
        .toArray(FlightType[]::new);
      return joinedFlightArray;
    }
  }

  private FlightType[] processQueryFlightsWithinRangeChunk(FlightType[] flightsList, FlightQueryType queryType, int start, int end) {
    return Arrays.stream(flightsList)
      .filter(flight -> getFlightTypeFieldFromQueryType(flight, queryType) >= start &&
      getFlightTypeFieldFromQueryType(flight, queryType) < end)
      .toArray(FlightType[]::new);
  }

  private int getFlightTypeFieldFromQueryType(FlightType flight, FlightQueryType queryType) {
    switch(queryType) {
    case DAY:
      return (int)flight.Day;
    case CARRIER_CODE_INDEX:
      return (int)flight.CarrierCodeIndex;
    case FLIGHT_NUMBER:
      return (int)flight.FlightNumber;
    case AIRPORT_ORIGIN_INDEX:
      return (int)flight.AirportOriginIndex;
    case AIRPORT_DEST_INDEX:
      return (int)flight.AirportDestIndex;
    case SCHEDULED_DEPARTURE_TIME:
      return (int)flight.ScheduledDepartureTime;
    case DEPARTURE_TIME:
      return (int)flight.DepartureTime;
    case SCHEDULED_ARRIVAL_TIME:
      return (int)flight.ScheduledArrivalTime;
    case ARRIVAL_TIME:
      return (int)flight.ArrivalTime;
    case CANCELLED_OR_DIVERTED:
      return (int)flight.CancelledOrDiverted;
    case MILES_DISTANCE:
      return (int)flight.MilesDistance;
    default:
      println("Error: FlightQueryType invalid");
      return -1;
    }
  }

  private boolean checkForIllegalQuery(FlightQueryType queryType, FlightQueryOperator queryOperator) {
    switch(queryType) {
    case CARRIER_CODE_INDEX:
    case FLIGHT_NUMBER:
    case AIRPORT_ORIGIN_INDEX:
    case AIRPORT_DEST_INDEX:
    case CANCELLED_OR_DIVERTED:
      if (queryOperator != FlightQueryOperator.EQUAL || queryOperator != FlightQueryOperator.NOT_EQUAL) {
        return false;
      } else {
        break;
      }
    default:
      return true;
    }
    return true;
  }

  public FlightType[] sort(FlightType[] flightsList, FlightQueryType queryType, FlightQuerySortDirection sortDirection) {
    Comparator<FlightType> flightComparator;
    switch(queryType) {
    case DAY:
      flightComparator = Comparator.comparingInt(flight -> flight.Day);
      break;
    case CARRIER_CODE_INDEX:
      flightComparator = Comparator.comparingInt(flight -> flight.CarrierCodeIndex);
      break;
    case FLIGHT_NUMBER:
      flightComparator = Comparator.comparingInt(flight -> flight.FlightNumber);
      break;
    case AIRPORT_ORIGIN_INDEX:
      flightComparator = Comparator.comparingInt(flight -> flight.AirportOriginIndex);
      break;
    case AIRPORT_DEST_INDEX:
      flightComparator = Comparator.comparingInt(flight -> flight.AirportDestIndex);
      break;
    case SCHEDULED_DEPARTURE_TIME:
      flightComparator = Comparator.comparingInt(flight -> flight.ScheduledDepartureTime);
      break;
    case DEPARTURE_TIME:
      flightComparator = Comparator.comparingInt(flight -> flight.DepartureTime);
      break;
    case SCHEDULED_ARRIVAL_TIME:
      flightComparator = Comparator.comparingInt(flight -> flight.ScheduledArrivalTime);
      break;
    case ARRIVAL_TIME:
      flightComparator = Comparator.comparingInt(flight -> flight.ArrivalTime);
      break;
    case CANCELLED_OR_DIVERTED:
      flightComparator = Comparator.comparingInt(flight -> flight.CancelledOrDiverted);
      break;
    case MILES_DISTANCE:
      flightComparator = Comparator.comparingInt(flight -> flight.MilesDistance);
      break;
    default:
      println("Error: FlightQueryType invalid");
      return flightsList;
    }

    switch(sortDirection) {
    case ASCENDING:
      break;
    case DESCENDING:
      flightComparator = flightComparator.reversed();
      break;
    default:
      println("Error: FlightQuerySortDirection invalid");
      return flightsList;
    }

    Arrays.sort(flightsList, flightComparator);
    return flightsList;
  }

  public String getAirportNameFromCode(short code) {
    return ""; // TODO Kyara
  }

  public void print(FlightType flight) {
    printFlightHeading();
    printFlight(flight);
  }

  public void print(FlightType[] flights) {
    printFlightHeading();
    for (FlightType flight : flights)
      printFlight(flight);
  }

  public void print(FlightType[] flights, int amount) {
    printFlightHeading();
    for (int i = 0; i < amount; i++) {
      printFlight(flights[i]);
    }
  }

  private void printFlight(FlightType flight) { // Can be changed to a toString() override
    println(
      flight.Day + "\t" +
      flight.CarrierCodeIndex + "\t\t" +
      flight.FlightNumber + "\t\t" +
      flight.AirportOriginIndex + "\t\t" +
      flight.AirportDestIndex + "\t\t" +
      flight.ScheduledDepartureTime + "\t\t\t" +
      flight.DepartureTime + "\t\t" +
      flight.ScheduledArrivalTime + "\t\t\t" +
      flight.ArrivalTime + "\t\t" +
      flight.CancelledOrDiverted + "\t\t" +
      flight.MilesDistance
      );
  }

  private void printFlightHeading() {
    println(
      "Day\t" +
      "CarrierCodeIndex\t" +
      "FlightNumber\t" +
      "AirportOriginIndex\t" +
      "AirportDestIndex\t" +
      "ScheduledDepartureTime\t" +
      "DepartureTime\t" +
      "ScheduledArrivalTime\t\t" +
      "ArrivalTime\t" +
      "CancelledOrDiverted\t" +
      "MilesDistance"
      );
  }
}


// Descending code authorship changes:
// F. Wright, Made DateType, FlightType, FlightsManagerClass and made function headers. Left comments to explain how everything could be implemented, 11pm 04/03/24
// F. Wright, Started work on storing the FlightType data as raw binary data for efficient data transfer, 1pm 05/03/24
// T. Creagh, Did the first attempt at reading the binary file and now it very efficiently gets the data into FlightType, 9:39pm 05/03/24
// F. Wright, Minor code cleanup, 1pm 06/03/24
// T. Creagh, made threads for the reading and made sure that it works all fine and propper, 2pm 06/03/24
// T. Creagh, improved performace by adding arrays instead, 3pm 06/03/24
// F. Wright, Made it so the file reading happens on a seperate thread. Made code fit coding standard, 4pm 06/03/24
// T. Creagh, improved performace by having constructor, 8pm 06/03/24
// T. Creagh, created enums for querying, 9pm 06/03/24
// T. Creagh, implemented checkForIllegalQuery and getFlightTypeFieldFromQueryType, 12am 06/03/24
// T. Creagh, implemented queryFlights, 1pm 07/03/24
// T. Creagh, implemented FlightManager.print(), 2pm 76/03/24
// T. Creagh, implemented queryFlightsWithinRange,  2:15pm 07/03/24
// T. Creagh, implemented FlightManager.sort(), 2:30pm 07/03/24
// F. Wright, cleaned up code a bit, 11am 07/03/24
// T. Creagh, implemented queryFlightsAysnc, 3am 08/03/24
// T. Creagh, implemented processQueryFlightsChunk.sort(), 3:30am 08/03/24
// T. Creagh, implemented query with threads, 4:00am 08/03/24
// T. Creagh, implemented queryFlightsWithinRangeAysnc, 4:30am 08/03/24
// T. Creagh, cleaned up code a bit, 7pm 0/03/24
// CKM, implemented delay stats, 23:00 11/03
