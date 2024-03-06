import java.util.Arrays;
import java.util.List;
import java.nio.channels.FileChannel;
import java.nio.*;
import java.io.*;
import java.util.concurrent.*;

class FlightType { // 19 bytes total
  public byte Day;
  public byte CarrierCodeIndex;
  public short FlightNumber;
  public short AirportOriginIndex;
  public short AirportDestIndex;
  public short ScheduledDepartureTime;
  public short DepartureTime;
  public short ScheduledArrivalTime;
  public short ArrivalTime;
  public byte CancelledOrDiverted;
  public short MilesDistance;

  public FlightType(byte day, byte carrierCodeIndex, short flightNumber,
    short airportOriginIndex, short airportDestIndex, short scheduledDepartureTime,
    short departureTime, short scheduledArrivalTime, short arrivalTime,
    byte cancelledOrDiverted, short milesDistance) {
    Day = day;
    CarrierCodeIndex = carrierCodeIndex;
    FlightNumber = flightNumber;
    AirportOriginIndex = airportOriginIndex;
    AirportDestIndex = airportDestIndex;
    ScheduledDepartureTime = scheduledDepartureTime;
    DepartureTime = departureTime;
    ScheduledArrivalTime = scheduledArrivalTime;
    ArrivalTime = arrivalTime;
    CancelledOrDiverted = cancelledOrDiverted;
    MilesDistance = milesDistance;
  }
}

class FlightsManagerClass {
  private FlightType[] m_flightsList;
  private boolean m_working;

  public FlightType[] getflightsList() {
    return m_flightsList;
  }

  public boolean convertFileToFlightType(String filepath, int threadCount, Consumer<FlightType[]> onTaskComplete) {
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

  private void convertFileToFlightTypeAsync(String filepath, int threadCount) {
    String path = sketchPath() + "/" + filepath;
    MappedByteBuffer buffer;
    ExecutorService executor = Executors.newFixedThreadPool(threadCount);
    CountDownLatch latch = new CountDownLatch(threadCount);

    try (FileInputStream fis = new FileInputStream(path)) {
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

  // Should work if given airport code or name
  public void queryFlights(FlightType values) {
  }

  public void queryFlightsWithinRanges(FlightType startValues, FlightType endValues) {
  }

  public void sortFlights(FlightType values) {
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
