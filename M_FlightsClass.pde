import java.util.Arrays;
import java.util.stream.Collectors;
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
  SCHEDULED_ARRIVAL_TIME,
  ARRIVAL_TIME,
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

class FlightType { // 19 bytes total
  public byte Day;                      // supports all querys
  public byte CarrierCodeIndex;         // only supports EQUAL or NOT_EQUAL
  public short FlightNumber;            // only supports EQUAL or NOT_EQUAL
  public short AirportOriginIndex;      // only supports EQUAL or NOT_EQUAL
  public short AirportDestIndex;        // only supports EQUAL or NOT_EQUAL
  public short ScheduledDepartureTime;  // supports all querys
  public short DepartureTime;           // supports all querys
  public short ScheduledArrivalTime;    // supports all querys
  public short ArrivalTime;             // supports all querys
  public byte CancelledOrDiverted;      // only supports EQUAL or NOT_EQUAL
  public short MilesDistance;           // supports all querys
  public FlightType(
    byte Day, byte CarrierCodeIndex, short FlightNumber,
    short AirportOriginIndex, short AirportDestIndex, short ScheduledDepartureTime,
    short DepartureTime, short ScheduledArrivalTime, short ArrivalTime,
    byte CancelledOrDiverted, short MilesDistance) {
      this.Day = Day;
      this.CarrierCodeIndex = CarrierCodeIndex;
      this.FlightNumber = FlightNumber;
      this.AirportOriginIndex = AirportOriginIndex;
      this.AirportDestIndex = AirportDestIndex;
      this.ScheduledDepartureTime = ScheduledDepartureTime;
      this.DepartureTime = DepartureTime;
      this.ScheduledArrivalTime = ScheduledArrivalTime;
      this.ArrivalTime = ArrivalTime;
      this.CancelledOrDiverted = CancelledOrDiverted;
      this.MilesDistance = MilesDistance;
  }
}

class FlightsManagerClass {
  private FlightType[] m_flightsList = new FlightType[563737];
  // private HashMap<short, String> m_airportCodesToName = new HashMap<short, String>();
  private boolean m_working;

  public void init(String dataDirectory, int threadCount, Consumer<FlightType[]> onTaskComplete) {
    String trueDataDirectory = sketchPath() + "/" + dataDirectory + "/";
    boolean a = convertFileToFlightType(trueDataDirectory, threadCount, onTaskComplete);

    // convertFileToAirportCodesToName(dir);

  }

  public FlightType[] getFlightsList() {
    return m_flightsList;
  }

  private boolean convertFileToFlightType(String filepath, int threadCount, Consumer<FlightType[]> onTaskComplete) {
    if (m_working)
      return false;

    new Thread(() -> {
      s_DebugProfiler.startProfileTimer();
      convertFileToFlightTypeAsync(filepath, threadCount);      
      s_DebugProfiler.printTimeTakenMillis("Raw file pre-processing");
      
      m_working = false;
      onTaskComplete.accept(m_flightsList);
    }
    ).start();

    m_working = true;
    return true;
  }

  private void convertFileToFlightTypeAsync(String directory, int threadCount) {
    MappedByteBuffer buffer;
    ExecutorService executor = Executors.newFixedThreadPool(threadCount);
    CountDownLatch latch = new CountDownLatch(threadCount);

    try (FileInputStream fis = new FileInputStream(directory + "flight_data.bin")) {            
      FileChannel channel = fis.getChannel();
      buffer = channel.map(FileChannel.MapMode.READ_ONLY, 0, channel.size());
      long flightCount = channel.size() / LINE_BYTE_SIZE;
      fis.close();
      channel.close();

      int chunkSize = (int) flightCount / threadCount;

      for (int i = 0; i < threadCount; i++) {
        int startPosition = i * chunkSize;
        long endPosition = (i == threadCount - 1) ? flightCount : (i + 1) * chunkSize;
        long processingSize = endPosition - startPosition;

        executor.submit(() -> {
          processChunk(buffer, processingSize, startPosition);
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

  private void processChunk(MappedByteBuffer buffer, long processingSize, int startPosition) {
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

  // private HashMap<String, String> convertFileToAirportCodesToName(String dir) {
  // }

  public FlightType[] queryFlights(FlightType[] flightsList, FlightQueryType type, FlightQueryOperator operator, int value) {
    if (!checkForIllegalQuery(type, operator)) {
      println("Error: QueryType is illegal with QueryOperator");
      return flightsList;
    }
    switch(operator) {
    case EQUAL:
      return Arrays.stream(flightsList)
            .filter(flight -> getFlightTypeFieldFromQueryType(flight, type) == value)
            .toArray(FlightType[]::new);
    case NOT_EQUAL:
      return Arrays.stream(flightsList)
            .filter(flight -> getFlightTypeFieldFromQueryType(flight, type) != value)
            .toArray(FlightType[]::new);
    case LESS_THAN:
      return Arrays.stream(flightsList)
            .filter(flight -> getFlightTypeFieldFromQueryType(flight, type) < value)
            .toArray(FlightType[]::new);
    case LESS_THAN_EQUAL:
      return Arrays.stream(flightsList)
            .filter(flight -> getFlightTypeFieldFromQueryType(flight, type) <= value)
            .toArray(FlightType[]::new);
    case GREATER_THAN:
      return Arrays.stream(flightsList)
            .filter(flight -> getFlightTypeFieldFromQueryType(flight, type) > value)
            .toArray(FlightType[]::new);
    case GREATER_THAN_EQUAL:
      return Arrays.stream(flightsList)
            .filter(flight -> getFlightTypeFieldFromQueryType(flight, type) >= value)
            .toArray(FlightType[]::new);
    default:
      println("Error: QueryOperator invalid");
      return flightsList;
    }
  }

  public FlightType[] queryFlightsWithinRange(FlightType[] flightsList, FlightQueryType type, int start, int end) {
    if (!checkForIllegalQuery(type, FlightQueryOperator.GREATER_THAN_EQUAL)) {
      println("Error: QueryType is illegal with QueryOperator");
      return flightsList;
    }
    return Arrays.stream(flightsList)
      .filter(flight -> getFlightTypeFieldFromQueryType(flight, type) >= start &&
                        getFlightTypeFieldFromQueryType(flight, type) < end)
      .toArray(FlightType[]::new);
  }

  private int getFlightTypeFieldFromQueryType(FlightType flight, FlightQueryType type) {
    switch(type) {
    case DAY:
      return (int) flight.Day;
    case CARRIER_CODE_INDEX:
      return (int) flight.CarrierCodeIndex;
    case FLIGHT_NUMBER:
      return (int) flight.FlightNumber;
    case AIRPORT_ORIGIN_INDEX:
      return (int) flight.AirportOriginIndex;
    case AIRPORT_DEST_INDEX:
      return (int) flight.AirportDestIndex;
    case SCHEDULED_DEPARTURE_TIME:
      return (int) flight.ScheduledDepartureTime;
    case DEPARTURE_TIME:
      return (int) flight.DepartureTime;
    case SCHEDULED_ARRIVAL_TIME:
      return (int) flight.ScheduledArrivalTime;
    case ARRIVAL_TIME:
      return (int) flight.ArrivalTime;
    case CANCELLED_OR_DIVERTED:
      return (int) flight.CancelledOrDiverted;
    case MILES_DISTANCE:
      return (int) flight.MilesDistance;
    default:
      println("Error: QueryType invalid");
      return 0;
    }
  }

  private boolean checkForIllegalQuery(FlightQueryType type, FlightQueryOperator operator) {
    switch(type) {
    case CARRIER_CODE_INDEX:
    case FLIGHT_NUMBER:
    case AIRPORT_ORIGIN_INDEX:
    case AIRPORT_DEST_INDEX:
    case CANCELLED_OR_DIVERTED:
      if (operator != FlightQueryOperator.EQUAL || operator != FlightQueryOperator.NOT_EQUAL) {
        return false;
      } else {
        break;
      }
    }
    return true;
  }

  public FlightType[] sortFlights(FlightType[] flightsList, FlightQueryType type, FlightQuerySortDirection sortDirection) {
    return flightsList;
  }

  public String getAirportNameFromCode(short code) {
    return "";
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

  private void printFlight(FlightType flight) {
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
// T. Creagh, implemented checkForIllegalQuery and getFlightTypeFieldFromQueryType,  12pm 06/03/24
// T. Creagh, implemented queryFlights,  1pm 06/03/24
// T. Creagh, implemented FlightManager.print(),  2pm 06/03/24
// T. Creagh, implemented queryFlightsWithinRange,  2pm 06/03/24

