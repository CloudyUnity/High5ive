class QueryManagerClass {
  private Table m_airlineTable;
  private Table m_airportTable;
  private TableRow m_lookupResult;
  private boolean m_working;
  private int m_debug;

  public void init() {
    m_debug = 0;
    m_airlineTable = loadTable(sketchPath() + DATA_DIRECTOR_PATH + "airlines.csv", "header");
    m_airportTable = loadTable(sketchPath() + DATA_DIRECTOR_PATH + "airports.csv", "header");

    if (m_airportTable == null || m_airlineTable == null) {
      println("ERROR ON INIT QUERY MANAGER");
    }
  }

  //a series of function for lookup tables - the lookup tables are loaded directly into processing as spreadsheets
  //the findRow functions allow the spreadsheet to be searched, and a pointer to that row is passed as a variable
  public float getLatitude(String code) {
    m_lookupResult = m_airportTable.findRow(code, "IATA");
    return m_lookupResult.getFloat("Latitude");
  }

  public float getLongitude(String code) {
    m_lookupResult = m_airportTable.findRow(code, "IATA");
    return m_lookupResult.getFloat("Longitude");
  }

  public String getAirportName(String code) {
    m_lookupResult = m_airportTable.findRow(code, "IATA");
    return m_lookupResult.getString("Name");
  }

  public String getCity(String code) {
    m_lookupResult = m_airportTable.findRow(code, "IATA");
    return m_lookupResult.getString("City");
  }

  public String getCountry(String code) {
    m_lookupResult = m_airportTable.findRow(code, "IATA");
    return m_lookupResult.getString("Country");
  }

  public String getCode(int index) {
    m_lookupResult = m_airportTable.findRow(String.valueOf(index), "Key");
    return m_lookupResult.getString("IATA");
  }

  public int getIndex(String code) {
    m_lookupResult = m_airportTable.findRow(code, "IATA");
    return m_lookupResult.getInt("Key");
  }

  public String getAirlineCode(int airlineIndex) {
    m_lookupResult = m_airlineTable.findRow(String.valueOf(airlineIndex), "Key");
    return m_lookupResult.getString("IATA");
  }

  public String getAirlineName(int airlineIndex) {
    m_lookupResult = m_airlineTable.findRow(String.valueOf(airlineIndex), "Key");
    return m_lookupResult.getString("Airline");
  }

  private FlightType[] queryFlights(FlightType[] flightsList, FlightQueryType flightQuery, int queryValue) {
    if (!isLegalQuery(flightQuery)) {
      println("Error: FlightQuery.Type is illegal with FlightQuery.Operator");
      return flightsList;
    }
    println("flightsList: " + flightsList.length);
    println("queryValue: " + queryValue);
    switch(flightQuery.Operator) {
    case EQUAL:
      return Arrays.stream(flightsList)
        .filter(flight -> getFlightTypeFieldFromQueryType(flight, flightQuery.Type) == queryValue)
        .toArray(FlightType[]::new);
    case NOT_EQUAL:
      return Arrays.stream(flightsList)
        .filter(flight -> getFlightTypeFieldFromQueryType(flight, flightQuery.Type) != queryValue)
        .toArray(FlightType[]::new);

    case LESS_THAN:
      return Arrays.stream(flightsList)
        .filter(flight -> getFlightTypeFieldFromQueryType(flight, flightQuery.Type) < queryValue)
        .toArray(FlightType[]::new);

    case LESS_THAN_EQUAL:
      return Arrays.stream(flightsList)
        .filter(flight -> getFlightTypeFieldFromQueryType(flight, flightQuery.Type) <= queryValue)
        .toArray(FlightType[]::new);

    case GREATER_THAN:
      return Arrays.stream(flightsList)
        .filter(flight -> getFlightTypeFieldFromQueryType(flight, flightQuery.Type) > queryValue)
        .toArray(FlightType[]::new);

    case GREATER_THAN_EQUAL:
      return Arrays.stream(flightsList)
        .filter(flight -> getFlightTypeFieldFromQueryType(flight, flightQuery.Type) >= queryValue)
        .toArray(FlightType[]::new);

    default:
      println("Error: FlightQuery.Operator invalid");
      return flightsList;
    }
  }

  private FlightType[] queryFlightsWithinRange(FlightType[] flightsList, FlightRangeQueryType flightRangeQuery, int start, int end) {
    if (!isLegalQuery(flightRangeQuery)) {
      println("Error: FlightRangeQuery.Type is illegal to query range");
      return flightsList;
    }
    return Arrays.stream(flightsList)
      .filter(flight -> getFlightTypeFieldFromQueryType(flight, flightRangeQuery.Type) >= start &&
      getFlightTypeFieldFromQueryType(flight, flightRangeQuery.Type) < end)
      .toArray(FlightType[]::new);
  }

  private int getFlightTypeFieldFromQueryType(FlightType flight, QueryType queryType) {
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
    case DEPARTURE_DELAY:
      return (int)flight.DepartureDelay;
    case SCHEDULED_ARRIVAL_TIME:
      return (int)flight.ScheduledArrivalTime;
    case ARRIVAL_TIME:
      return (int)flight.ArrivalTime;
    case ARRIVAL_DELAY:
      return (int)flight.ArrivalDelay;
    case CANCELLED_OR_DIVERTED:
      return (int)flight.CancelledOrDiverted;
    case KILOMETRES_DISTANCE:
      return (int)flight.MilesDistance;
    default:
      println("Error: Query.Type invalid");
      return -1;
    }
  }

  private boolean isLegalQuery(FlightQueryType flightQuery) {
    if (flightQuery.Location == QueryLocationType.US) {
      switch(flightQuery.Type) {
      case CARRIER_CODE_INDEX:
      case FLIGHT_NUMBER:
      case AIRPORT_ORIGIN_INDEX:
      case AIRPORT_DEST_INDEX:
      case CANCELLED_OR_DIVERTED:
        boolean opIsEqual = flightQuery.Operator == QueryOperatorType.EQUAL;
        boolean opIsNotEqual = flightQuery.Operator == QueryOperatorType.NOT_EQUAL;
        return opIsEqual || opIsNotEqual;
      default:
        return true;
      }
    }

    switch(flightQuery.Type) {
    case CARRIER_CODE_INDEX:
    case AIRPORT_ORIGIN_INDEX:
    case AIRPORT_DEST_INDEX:
      boolean opIsEqual = flightQuery.Operator == QueryOperatorType.EQUAL;
      boolean opIsNotEqual = flightQuery.Operator == QueryOperatorType.NOT_EQUAL;
      return opIsEqual || opIsNotEqual;
    default:
      return false;
    }
  }

  private boolean isLegalQuery(FlightRangeQueryType flightRangeQuery) {
    if (flightRangeQuery.Location != QueryLocationType.WORLD)
      return false;

    switch(flightRangeQuery.Type) {
    case CARRIER_CODE_INDEX:
    case FLIGHT_NUMBER:
    case AIRPORT_ORIGIN_INDEX:
    case AIRPORT_DEST_INDEX:
    case CANCELLED_OR_DIVERTED:
      return false;
    default:
      return true;
    }
  }

  public FlightType[] sort(FlightType[] flightsList, FlightSortQueryType flightSortQuery) {
    Comparator<FlightType> flightComparator;
    switch(flightSortQuery.Type) {
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
    case KILOMETRES_DISTANCE:
      flightComparator = Comparator.comparingInt(flight -> flight.MilesDistance);
      break;
    default:
      println("Error: FlightSortQuery.Type invalid");
      return flightsList;
    }

    if (flightSortQuery.SortDirection == QuerySortDirectionType.DESCENDING)
      flightComparator = flightComparator.reversed();

    Arrays.sort(flightsList, flightComparator);
    return flightsList;
  }

  public int queryFrequency(FlightType[] flightsList, FlightQueryType flightQuery, int queryValue, int threadCount) {
    return queryFlights(flightsList, flightQuery, queryValue).length;
  }

  public int queryRangeFrequency(FlightType[] flightsList, FlightRangeQueryType flightRangeQuery, int start, int end, int threadCount) {
    return queryFlightsWithinRange(flightsList, flightRangeQuery, start,end).length;
  }

  public FlightType[] getHead(FlightType[] flightList, int numberOfItems) {
    return Arrays.copyOfRange(flightList, 0, numberOfItems);
  }

  public FlightType[] getFoot(FlightType[] flightList, int numberOfItems) {
    return Arrays.copyOfRange(flightList, numberOfItems, flightList.length);
  }

  public FlightType[] getWithinRange(FlightType[] flightList, int start, int end) {
    return Arrays.copyOfRange(flightList, start, end);
  }
}

// Descending code authorship changes:
// CKM: wrote class to return details about airports 17:00 11/03
// T. Creagh, moved query methods in, 11pm 06/03/24
// T. Creagh, fixed queryFrequency and queryRangeFrequency, 12pm 06/03/24
// T. Creagh, removed redundant code, 12:30pm 06/03/24
// CKM, wrote comments about my code, 16:00 12/03
// CKM, converted to kilometres 17:00 12/03
// T. Creagh, Added Working queryFlights with world, 10pm, 12/03/24
// T. Creagh, Added Working queryRangeFlights with world, 11pm, 12/03/24
// T. Creagh, Added Working querySortFlights with world, 11:30pm, 12/03/24
// T. Creagh, Added Working queryFrequency with world, 11:45pm, 12/03/24
// T. Creagh, Added Working queryRangeFrequency with world, 12pm, 12/03/24
// CKM, added world lookup functions 13:00 14/03
// CKM, added airline lookup functions 13:00 14/03
