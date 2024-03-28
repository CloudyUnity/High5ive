class FlightsManagerClass {
  private boolean m_working;

  // Loads the flight data from the given file paths
  public void loadUSAndWorldFromFiles(String usFileName, String worldFileName, int threadCount, Consumer<FlightMultiDataType> onTaskComplete) {
    boolean result = convertBinaryFileToFlightType(usFileName, worldFileName, US_LINE_BYTE_SIZE, WORLD_LINE_BYTE_SIZE, threadCount, onTaskComplete);
    if (!result)
      println("ERROR: Flight binary failed to load successfully");
  }

  // ...
  private boolean convertBinaryFileToFlightType(String usFileName, String worldFileName, int usLineByteSize, int worldLineByteSize, int threadCount, Consumer<FlightMultiDataType> onTaskComplete) {
    if (m_working) {
      println("Warning: m_working is true, convertBinaryFileToFlightType did not process correctly");
      return false;
    }

    new Thread(() -> {
      s_DebugProfiler.startProfileTimer();

      FlightType[] us = convertBinaryFileToFlightTypeAsync(usFileName, threadCount, QueryLocationType.US, usLineByteSize);
      FlightType[] world = convertBinaryFileToFlightTypeAsync(worldFileName, threadCount, QueryLocationType.WORLD, worldLineByteSize);

      FlightMultiDataType flightsLists = new FlightMultiDataType(us, world);

      s_DebugProfiler.printTimeTakenMillis("Loading flight data from files");

      onTaskComplete.accept(flightsLists);
      m_working = false;
    }
    ).start();

    m_working = true;
    return true;
  }

  // ...
  private FlightType[] convertBinaryFileToFlightTypeAsync(String filename, int threadCount, QueryLocationType queryLocation, int lineByteSize) {
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
          if (queryLocation == QueryLocationType.US) {
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
  
  // ...
  private void processUSConvertBinaryFileToFlightTypeChunk(FlightType[] flightsList, MappedByteBuffer buffer, long processingSize, int startPosition, int lineByteSize) {
    long maxI = startPosition + processingSize;
    for (int i = startPosition; i < maxI; i++) {
      int offset = lineByteSize* i;
      flightsList[i] = new FlightType(
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
        buffer.getShort(offset+20),
        buffer.getShort(offset+22),
        buffer.get(offset+23),
        buffer.get(offset+24),
        buffer.getShort(offset+26),
        buffer.getShort(offset+28),
        buffer.getShort(offset+30)
        );
    }
  }

  // ...
  private void processWorldConvertBinaryFileToFlightTypeChunk(FlightType[] flightsList, MappedByteBuffer buffer, long processingSize, int startPosition, int lineByteSize) {
    long maxI = startPosition + processingSize;
    for (int i = startPosition; i < maxI; i++) {
      int offset = lineByteSize * i;
      flightsList[i] = new FlightType(
        buffer.getShort(offset),
        buffer.getShort(offset+2),
        buffer.getShort(offset+4)
        );
    }
  }

  // ...
  public void printFlights(FlightType[] flights, QueryType queryType) {
    for (FlightType flight : flights) {
      printFlight(flight, queryType);
    }
  }

  // ...
  public void printFlight(FlightType flight, QueryType queryType) {
    switch(queryType) {
    case DAY:
      println("Day: " + flight.Day);
      break;
    case CARRIER_CODE_INDEX:
      println("CarrierCodeIndex: " + flight.CarrierCodeIndex);
      break;
    case FLIGHT_NUMBER:
      println("FlightNumber: " + flight.FlightNumber);
      break;
    case AIRPORT_ORIGIN_INDEX:
      println("AirportOriginIndex: " + flight.AirportOriginIndex);
      break;
    case AIRPORT_DEST_INDEX:
      println("AirportDestIndex: " + flight.AirportDestIndex);
      break;
    case SCHEDULED_DEPARTURE_TIME:
      println("ScheduledDepartureTime: " + flight.ScheduledDepartureTime);
      break;
    case DEPARTURE_TIME:
      println("DepartureTime: " + flight.DepartureTime);
      break;
    case SCHEDULED_ARRIVAL_TIME:
      println("ScheduledArrivalTime: " + flight.ScheduledArrivalTime);
      break;
    case ARRIVAL_TIME:
      println("ArrivalTime: " + flight.ArrivalTime);
      break;
    case CANCELLED_OR_DIVERTED:
      println("CancelledOrDiverted: " + flight.Cancelled);
      break;
    case KILOMETRES_DISTANCE:
      println("KilometresDistance: " + flight.KmDistance);
      break;
    default:
      println("Error: FlightSortQuery.Type invalid");
    }
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
// F. Wright, Code cleanup 9am 19/03/24
