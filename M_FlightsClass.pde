import java.util.Arrays;
import java.util.Comparator;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import java.util.concurrent.*;
import java.util.HashMap;
import java.nio.channels.FileChannel;
import java.nio.*;
import java.io.*;

class FlightsManagerClass {
  private FlightType[] m_flightsList = new FlightType[NUMBER_OF_FLIGHT_FULL_LINES];
  private boolean m_working;

  public void init(int threadCount, Consumer<FlightType[]> onTaskComplete) {
    boolean result = convertBinaryFileToFlightType("hex_flight_data.bin", threadCount, onTaskComplete);
    if (!result)
      return;
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
        buffer.getShort(offset+16),
        buffer.getShort(offset+18),
        buffer.get(offset+20),
        buffer.getShort(offset+21));
    }
    s_DebugProfiler.printTimeTakenMillis("Chunk " + startPosition);
  }
  public void print(FlightType flight) {
    printFlightHeading();
    printFlight(flight);
  }

  // public void print(FlightType[] flights) {
  //   printFlightHeading();
  //   for (FlightType flight : flights)
  //     printFlight(flight);
  // }
  // public void print(FlightType[] flights, int amount) {
  //   printFlightHeading();
  //   for (int i = 0; i < amount; i++) {
  //     printFlight(flights[i]);
  //   }
  // }
  // @Override
  // private void toString(FlightType flight) { // Can be changed to a toString() override
  //   println(
  //     flight.Day + "\t" +
  //     flight.CarrierCodeIndex + "\t\t" +
  //     flight.FlightNumber + "\t\t" +
  //     flight.AirportOriginIndex + "\t\t" +
  //     flight.AirportDestIndex + "\t\t" +
  //     flight.ScheduledDepartureTime + "\t\t\t" +
  //     flight.DepartureTime + "\t\t" +
  //     flight.DepartureDelay + "\t\t" +
  //     flight.ScheduledArrivalTime + "\t\t\t" +
  //     flight.ArrivalTime + "\t\t" +
  //     flight.ArrivalDelay + "\t\t" +
  //     flight.CancelledOrDiverted + "\t\t" +
  //     flight.KmDistance
  //     );
  // }
  // private void printFlightHeading() {
  //   println(
  //     "Day\t" +
  //     "CarrierCodeIndex\t" +
  //     "FlightNumber\t" +
  //     "AirportOriginIndex\t" +
  //     "AirportDestIndex\t" +
  //     "ScheduledDepartureTime\t" +
  //     "DepartureTime\t" +
  //     "DepartureDelay\t" +
  //     "ScheduledArrivalTime\t\t" +
  //     "ArrivalTime\t" +
  //     "ArrivalDelay\t" +
  //     "CancelledOrDiverted\t" +
  //     "KmDistance"
  //     );
  // }
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
// T. Creagh, implemented queryFrequency, 2:30pm 11/03/24
// T. Creagh, implemented queryRangeFrequency, 3pm 11/03/24
// T. Creagh, implemented getHead, 3:30pm 11/03/24
// T. Creagh, implemented getFoot, 4pm 11/03/24
// T. Creagh, implemented getWithinRange, 4:30pm 11/03/24
// T. Creagh, updated data to 23bytes, 11pm 11/03/24
// T. Creagh, refacotored methodes, 11:30pm 11/03/24
// T. Creagh, cleaned up code a bit, 12pm 0/03/24
// CKM, implemented delay stats, 23:00 11/03
// CKM, converted to kilometres, 17:00 12/03
