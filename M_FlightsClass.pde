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
}

class FlightsManagerClass {
  private FlightType[] m_flightsList = new FlightType[563737];
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
      long flightCount = channel.size() / 24;
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
      FlightType temp = new FlightType();
      int offset = LINE_BYTE_SIZE * i;

      temp.Day = buffer.get(offset);
      temp.CarrierCodeIndex = buffer.get(offset+1);
      temp.FlightNumber = buffer.getShort(offset+2);
      temp.AirportOriginIndex = buffer.getShort(offset+4);
      temp.AirportDestIndex = buffer.getShort(offset+6);
      temp.ScheduledDepartureTime = buffer.getShort(offset+8);
      temp.DepartureTime = buffer.getShort(offset+10);
      temp.ScheduledArrivalTiahhme = buffer.getShort(offset+12);
      temp.ArrivalTime = buffer.getShort(offset+14);
      temp.CancelledOrDiverted = buffer.get(offset+16);
      temp.MilesDistance = buffer.getShort(offset+17);
      m_flightsList[i] = temp;
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
// T. Creagh, made threads for the reading and made sure that it works all fine and propper., 2pm 06/03/24
// T. Creagh, improved performace by adding arrays instead
// F. Wright, Made it so the file reading happens on a seperate thread. Made code fit coding standard, 4pm 06/03/24
