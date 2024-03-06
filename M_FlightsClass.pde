import java.util.Arrays;
import java.util.List;
import java.io.FileInputStream;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.ByteOrder;
import java.nio.file.Paths;
import java.nio.file.Path;
import java.io.*;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

class FlightType { // 19 bytes total
  public byte Day;
  public byte CarrierCodeIndex;
  public short FlightNumber;
  public short AirportOriginIndex;
  public short AirportDestIndex;
  public short ScheduledDepartureTime =0, DepartureTime =0, ScheduledArrivalTime =0, ArrivalTime =0;
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
      m_working = false;
      s_DebugProfiler.printTimeTakenMillis("Raw file pre-processing");
      onTaskComplete.accept(m_flightsList);
    }).start();
    
    m_working = true;
    return true;
  }  

  public void convertFileToFlightTypeAsync(String filepath, int threadCount) {
    String path = sketchPath() + "/" + filepath;
    MappedByteBuffer buffer;
    ExecutorService executor = Executors.newFixedThreadPool(threadCount);

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
        long sliceLength = endPosition - startPosition;

        executor.execute(() -> {
          int startSlice = (int) startPosition * LINE_BYTE_SIZE;
          int endSlice = (int) sliceLength * LINE_BYTE_SIZE;
          MappedByteBuffer slicedBuffer = buffer.slice(startSlice, endSlice);
          processChunk(slicedBuffer, sliceLength, startPosition);
        }
        );
      }
      executor.shutdown();
      try {
        executor.awaitTermination(Long.MAX_VALUE, TimeUnit.NANOSECONDS);
      }
      catch (InterruptedException e) {
        println("Error: " + e);
        return;
      }
    }
    catch (IOException e) {
      println("Error: " + e);
      return;
    }
  }

  private void processChunk(MappedByteBuffer buffer, long length, int startPosition) {
    FlightType temp = new FlightType();
    if (DEBUG_MODE)
      println("thread ready boss o7");
    for (int i = 0; i < length; i++) {
      int offset = LINE_BYTE_SIZE * i;
      // more efficeint with offsets
      temp.Day = buffer.get(offset);
      temp.CarrierCodeIndex = buffer.get(offset+1);
      temp.FlightNumber = buffer.getShort(offset+2);
      temp.AirportOriginIndex = buffer.getShort(offset+4);
      temp.AirportDestIndex = buffer.getShort(offset+6);
      temp.ScheduledDepartureTime = buffer.getShort(offset+8);
      temp.DepartureTime = buffer.getShort(offset+10);
      temp.ScheduledArrivalTime = buffer.getShort(offset+12);
      temp.ArrivalTime = buffer.getShort(offset+14);
      temp.CancelledOrDiverted = buffer.get(offset+16);
      temp.MilesDistance = buffer.getShort(offset+17);
      m_flightsList[startPosition + i] = temp;
    }
  }

  // Should work if given airport code or name
  public void queryFlightsWithAirport(String airport) {
  }

  public void queryFlightsWithinDates(int startDay, int endDay) {
  }

  public void sortFlightsByLateness() {
  }
}

// Descending code authorship changes:
// F. Wright, Made DateType, FlightType, FlightsManagerClass and made function headers. Left comments to explain how everything could be implemented, 11pm 04/03/24
// F. Wright, Started work on storing the FlightType data as raw binary data for efficient data transfer, 1pm 05/03/24
// T. Creagh, Did the first attempt at reading the binary file and now it very efficiently gets the data into FlightType, 9:39pm 05/03/24
// F. Wright, Minor code cleanup, 1pm 06/03/24
// T. Creagh, made threads for the reading and made sure that it works all fine and propper., 2pm 06/03/24
// T. Creagh, improved performace by adding arrays instead
