class FlightLists {
  public FlightType[] US;
  public FlightType[] WORLD;
  FlightLists(FlightType[] us, FlightType[] world) {
    this.US = us;
    this.WORLD = world;
  }
}

class FlightsManagerClass {
  private boolean m_working;

  public void init(String usFileName, String worldFileName, int usLineByteSize, int worldLineByteSize, int threadCount, Consumer<FlightLists> onTaskComplete) { //  Consumer<FlightType[]> onWorldTaskComplete
    boolean result = convertBinaryFileToFlightType(usFileName, worldFileName, usLineByteSize, worldLineByteSize, threadCount, onTaskComplete);
    if (!result)
      return;
  }
  private boolean convertBinaryFileToFlightType(String usFileName, String worldFileName, int usLineByteSize, int worldLineByteSize, int threadCount, Consumer<FlightLists> onTaskComplete) {
    if (m_working) {
      println("Warning: m_working is true, convertBinaryFileToFlightType did not process correctly");
      return false;
    }

    new Thread(() -> {
      s_DebugProfiler.startProfileTimer();
      FlightLists flightsLists = new FlightLists(convertBinaryFileToFlightTypeAsync(usFileName, threadCount, QueryLocation.US, usLineByteSize),
        convertBinaryFileToFlightTypeAsync(worldFileName, threadCount, QueryLocation.WORLD, worldLineByteSize));
      s_DebugProfiler.printTimeTakenMillis("Raw files pre-processing");
      onTaskComplete.accept(flightsLists);
      m_working = false;
    }
    ).start();


    m_working = true;
    return true;
  }
  private FlightType[] convertBinaryFileToFlightTypeAsync(String filename, int threadCount, QueryLocation queryLocation, int lineByteSize) {
    MappedByteBuffer buffer;
    ExecutorService executor = Executors.newFixedThreadPool(threadCount);
    CountDownLatch latch = new CountDownLatch(threadCount);

    try (FileInputStream fis = new FileInputStream(sketchPath() + DATA_DIRECTOR_PATH + filename)) {
      FileChannel channel = fis.getChannel();
      buffer = channel.map(FileChannel.MapMode.READ_ONLY, 0, channel.size());
      long flightCount = channel.size() / lineByteSize;
      fis.close();
      channel.close();

      FlightType[] flightsList = new FlightType[(int)flightCount];

      int chunkSize = (int)flightCount / threadCount;

      for (int i = 0; i < threadCount; i++) {
        int startPosition = i * chunkSize;
        long endPosition = (i == threadCount - 1) ? flightCount : (i + 1) * chunkSize;
        long processingSize = endPosition - startPosition;

        executor.submit(() -> {
          if (queryLocation == QueryLocation.US) {
            processUSConvertBinaryFileToFlightTypeChunk(flightsList, buffer, processingSize, startPosition, lineByteSize);
          } else {
            processWorldConvertBinaryFileToFlightTypeChunk(flightsList, buffer, processingSize, startPosition, lineByteSize);
          }
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
      executor.shutdown();
      return flightsList;
    }
    catch (IOException e) {
      println("Error: " + e);
      return null;
    }
  }
  private void processUSConvertBinaryFileToFlightTypeChunk(FlightType[] flightsList, MappedByteBuffer buffer, long processingSize, int startPosition, int lineByteSize) {
    s_DebugProfiler.startProfileTimer();

    long maxI = startPosition + processingSize;
    for (int i = startPosition; i < maxI; i++) {
      int offset = lineByteSize* i;
      flightsList[i] = new FlightType(
        buffer.get(offset),
        buffer.getShort(offset+1),
        buffer.getShort(offset+3),
        buffer.getShort(offset+5),
        buffer.getShort(offset+7),
        buffer.getShort(offset+9),
        buffer.getShort(offset+11),
        buffer.getShort(offset+13),
        buffer.getShort(offset+15),
        buffer.getShort(offset+17),
        buffer.getShort(offset+19),
        buffer.get(offset+21),
        buffer.getShort(offset+22)
        );
    }
    s_DebugProfiler.printTimeTakenMillis("Chunk " + startPosition);
  }
  // (carrier_code, origin, dest)short, short, short
  private void processWorldConvertBinaryFileToFlightTypeChunk(FlightType[] flightsList, MappedByteBuffer buffer, long processingSize, int startPosition, int lineByteSize) {
    s_DebugProfiler.startProfileTimer();

    long maxI = startPosition + processingSize;
    for (int i = startPosition; i < maxI; i++) {
      int offset = lineByteSize * i;
      flightsList[i] = new FlightType(
        buffer.getShort(offset),
        buffer.getShort(offset+2),
        buffer.getShort(offset+4)
        );
    }
    s_DebugProfiler.printTimeTakenMillis("Chunk " + startPosition);
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
// T. Creagh, Added World Consumer object TODO, 12am 12/03
// T. Creagh, Removed member varible from flightList, 12pm 13/03
// T. Creagh, Removed getFlightlist as its depreiated, 12:30pm 13/03
// T. Creagh, fixed convertBinaryFileToFlightTypeAsync to work without the member varible, 12:45pm 13/03
// T. Creagh, convertBinaryFileToFlightTypeAsync compatible with consumer, 12:45pm 13/03
// T. Creagh, added world for init and aysnc functions, 3pm 13/03
// T. Creagh, implemetned world fix, 9pm 13/03
