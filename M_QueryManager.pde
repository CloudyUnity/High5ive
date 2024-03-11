//CKM: code to return details about airports

class QueryManagerClass {

  Table m_airportTable;
  Table m_usaAirportIndexes;
  TableRow m_lookupResult;
  private boolean m_working;

  void init() {
    m_airportTable = loadTable("data/Preprocessed Data/airports.csv", "header");
    m_usaAirportIndexes = loadTable("data/Preprocessed Data/airport_lookup_table.csv");
  }
  float getLatitude(String code) {
    m_lookupResult = m_airportTable.findRow(code, "IATA");
    return m_lookupResult.getFloat("Latitude");
  }
  float getLongitude(String code) {
    m_lookupResult = m_airportTable.findRow(code, "IATA");
    return m_lookupResult.getFloat(5);
  }
  String getAirportName(String code) {
    m_lookupResult = m_airportTable.findRow(code, "IATA");
    return m_lookupResult.getString("Name");
  }
  String getCity(String code) {
    m_lookupResult = m_airportTable.findRow(code, "IATA");
    return m_lookupResult.getString("City");
  }
  String getCountry(String code) {
    m_lookupResult = m_airportTable.findRow(code, "IATA");
    return m_lookupResult.getString("Country");
  }
  String getCode(int index) {
    m_lookupResult = m_usaAirportIndexes.findRow(String.valueOf(index), 1);
    return m_lookupResult.getString(0);
  }
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
  public int queryFrequency(FlightType[] flightsList, FlightQueryType queryType, FlightQueryOperator queryOperator, int queryValue, int threadCount) {
    queryFlights(flightsList, queryType, queryOperator, queryValue, theardCount, returnedList -> {
      return (int)returnedList.lenght;
    });
  }
  public int queryRangeFrequency(FlightType[] flightsList, FlightQueryType queryType, int start, int end, int threadCount) {
    queryFlightsWithinRange(flightList, queryType, start, end, threadCount, returnedList -> {
      return (int)returnedList.lenght;
    });
  }
  public FlightType[] getHead(FlightType[] flightList, int numberOfItems) {
    return Arrays.copyOfRange(flightList, 0, numberOfItems);
  }
  public FlightType[] getFoot(FlightType[] flightList, int numberOfItems) {
    return Arrays.copyOfRange(flightList, numberOfItems, flightsList.lenght);
  }
  public FlightType[] getWithinRange(FlightType[] flightList, int start, int end) {
    return Arrays.copyOfRange(flightList, start, end);
  }
}
