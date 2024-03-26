class QueryManagerClass {
  private Table m_airlineTable;
  private Table m_airportTable;
  private TableRow m_lookupResult;

  // Initialises the query manager lookup tables
  public void init() {
    m_airlineTable = loadTable(sketchPath() + DATA_DIRECTOR_PATH + "airlines.csv", "header");
    m_airportTable = loadTable(sketchPath() + DATA_DIRECTOR_PATH + "airports.csv", "header");

    if (m_airportTable == null || m_airlineTable == null) {
      println("ERROR ON INIT QUERY MANAGER");
    }
  }

  // Gets latitude from an airport IATA code
  public float getLatitude(String code) {
    m_lookupResult = m_airportTable.findRow(code, "IATA");
    return m_lookupResult.getFloat("Latitude");
  }

  // Get longitude from an airport IATA code
  public float getLongitude(String code) {
    m_lookupResult = m_airportTable.findRow(code, "IATA");
    return m_lookupResult.getFloat("Longitude");
  }

  // Get airport name from an airport IATA code
  public String getAirportName(String code) {
    m_lookupResult = m_airportTable.findRow(code, "IATA");
    return m_lookupResult.getString("Name");
  }

  // Get airport city name from an airport IATA code
  public String getCity(String code) {
    m_lookupResult = m_airportTable.findRow(code, "IATA");
    return m_lookupResult.getString("City");
  }

  // Get airport country name from an airport IATA code
  public String getCountry(String code) {
    m_lookupResult = m_airportTable.findRow(code, "IATA");
    return m_lookupResult.getString("Country");
  }

  // Get airport IATA code from an airport index
  public String getCode(int index) {
    m_lookupResult = m_airportTable.findRow(String.valueOf(index), "Key");
    return m_lookupResult.getString("IATA");
  }

  // Get aiport index from an airport IATA code
  public int getIndex(String code) {
    m_lookupResult = m_airportTable.findRow(code, "IATA");
    return m_lookupResult.getInt("Key");
  }

  // Get airline code from an airline index
  public String getAirlineCode(int airlineIndex) {
    m_lookupResult = m_airlineTable.findRow(String.valueOf(airlineIndex), "Key");
    return m_lookupResult.getString("IATA");
  }

  // Get airline carrier code name from an airline index 
  public String getAirlineName(int airlineIndex) {
    m_lookupResult = m_airlineTable.findRow(String.valueOf(airlineIndex), "Key");
    return m_lookupResult.getString("Airline");
  }

  // ...
  public FlightType[] queryFlights(FlightType[] flightsList, FlightQueryType flightQuery, int queryValue) {
    if (!isLegalQuery(flightQuery)) {
      println("Error: FlightQuery.Type is illegal with FlightQuery.Operator");
      return flightsList;
    }
    
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

  // ...
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

  // ...
  private int getFlightTypeFieldFromQueryType(FlightType flight, QueryType queryType) {
    return getFlightTypeFieldFromQueryType(flight, queryType, false);
  }

  // ...
  private int getFlightTypeFieldFromQueryType(FlightType flight, QueryType queryType, boolean convertTimes) {
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

    case DEPARTURE_DELAY:
      return (int)flight.DepartureDelay;

    case ARRIVAL_DELAY:
      return (int)flight.ArrivalDelay;

    case CANCELLED_OR_DIVERTED:
      return (int)flight.CancelledOrDiverted;

    case KILOMETRES_DISTANCE:
      return (int)flight.KilometresDistance;

    case SCHEDULED_DEPARTURE_TIME:
      if (convertTimes)
        return convertClockToMinutes(flight.ScheduledDepartureTime);
      return (int)flight.ScheduledDepartureTime;

    case DEPARTURE_TIME:
      if (convertTimes)
        return convertClockToMinutes(flight.DepartureTime);
      return (int)flight.DepartureTime;

    case SCHEDULED_ARRIVAL_TIME:
      if (convertTimes)
        return convertClockToMinutes(flight.ScheduledArrivalTime);
      return (int)flight.ScheduledArrivalTime;

    case ARRIVAL_TIME:
      if (convertTimes)
        return convertClockToMinutes(flight.ArrivalTime);
      return (int)flight.ArrivalTime;

    default:
      println("Error: Query.Type invalid");
      return -1;
    }
  }

  // ...
  private int convertClockToMinutes(int time) {
    int hours = (int)(time / 100.0f);
    int mins = (int)(time % 100.0f);
    return mins + (hours * 60);
  }

  // ...
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

  // ...
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

  // ...
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

    case DEPARTURE_DELAY:
      flightComparator = Comparator.comparingInt(flight -> flight.DepartureDelay);
      break;

    case ARRIVAL_DELAY:
      flightComparator = Comparator.comparingInt(flight -> flight.ArrivalDelay);
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
      flightComparator = Comparator.comparingInt(flight -> flight.KilometresDistance);
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

  // ...
  public int queryFrequency(FlightType[] flightsList, FlightQueryType flightQuery, int queryValue, int threadCount) {
    return queryFlights(flightsList, flightQuery, queryValue).length;
  }

  // ...
  public int queryRangeFrequency(FlightType[] flightsList, FlightRangeQueryType flightRangeQuery, int start, int end, int threadCount) {
    return queryFlightsWithinRange(flightsList, flightRangeQuery, start, end).length;
  }

  // ...
  public FlightType[] getHead(FlightType[] flightList, int numberOfItems) {
    return Arrays.copyOfRange(flightList, 0, numberOfItems);
  }

  // ...
  public FlightType[] getFoot(FlightType[] flightList, int numberOfItems) {
    return Arrays.copyOfRange(flightList, numberOfItems, flightList.length);
  }

  // ...
  public FlightType[] getWithinRange(FlightType[] flightList, int start, int end) {
    return Arrays.copyOfRange(flightList, start, end);
  }

  // Parses a given query value from user input into a valid integer
  private int formatQueryValue(QueryType queryType, String inputString) {
    println(queryType);
    switch (queryType) {
    case DAY:
    case FLIGHT_NUMBER:
    case KILOMETRES_DISTANCE:
    case DEPARTURE_DELAY:
    case ARRIVAL_DELAY:
      return tryParseInteger(inputString);

    case SCHEDULED_DEPARTURE_TIME:
    case DEPARTURE_TIME:
    case SCHEDULED_ARRIVAL_TIME:
    case ARRIVAL_TIME:
      return tryParseInteger(inputString.replace(":", ""));

    case CARRIER_CODE_INDEX:
    case AIRPORT_ORIGIN_INDEX:
    case AIRPORT_DEST_INDEX:
      return getIndex(inputString);

    default:
      return -1;
    }
  }
}

// MILE TO KILO, ADD DELAY TO QUERY
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
// T. Creagh, Fixing Querys 22:00 23/03
// T. Creagh, Making print 22:30 23/03
// T. Creagh, fixed querySort on delay tiems 00:00 24/03
// T. Creagh, clean up 00:30 24/03
