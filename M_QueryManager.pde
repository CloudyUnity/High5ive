class QueryManagerClass {
  private Table m_airlineTable;
  private Table m_airportTable;
  private Table m_aircraftTable;
  private TableRow m_lookupResult;

  /**
   * CKM
   *
   * Iniialises the query manager lookup tables
   */
  public void init() {
    m_airlineTable = loadTable(sketchPath() + DATA_DIRECTOR_PATH + "airlines.csv", "header");
    m_airportTable = loadTable(sketchPath() + DATA_DIRECTOR_PATH + "airports.csv", "header");
    m_aircraftTable = loadTable(sketchPath() + DATA_DIRECTOR_PATH + "aircraft.csv", "header");

    if (m_airportTable == null || m_airlineTable == null || m_aircraftTable == null) {
      println("ERROR ON INIT QUERY MANAGER");
    }
  }

  /**
   * CKM
   *
   * Gets the latitude of an airport from its IATA code.
   *
   * @param code The IATA code of the airport.
   * @return The latitude of the airport.
   */
  public float getLatitude(String code) {
    m_lookupResult = m_airportTable.findRow(code, "IATA");
    return m_lookupResult.getFloat("Latitude");
  }

  /**
   * CKM
   *
   * Gets the longitude of an airport from its IATA code.
   *
   * @param code The IATA code of the airport.
   * @return The longitude of the airport.
   */
  public float getLongitude(String code) {
    m_lookupResult = m_airportTable.findRow(code, "IATA");
    return m_lookupResult.getFloat("Longitude");
  }

  /**
   * CKM
   *
   * Gets the name of an airport from its IATA code.
   *
   * @param code The IATA code of the airport.
   * @return The name of the airport.
   */
  public String getAirportName(String code) {
    m_lookupResult = m_airportTable.findRow(code, "IATA");
    return m_lookupResult.getString("Name");
  }

  /**
   * CKM
   *
   * Gets the city name of an airport from its IATA code.
   *
   * @param code The IATA code of the airport.
   * @return The city name of the airport.
   */
  public String getCity(String code) {
    m_lookupResult = m_airportTable.findRow(code, "IATA");
    return m_lookupResult.getString("City");
  }

  /**
   * CKM
   *
   * Gets the country name of an airport from its IATA code.
   *
   * @param code The IATA code of the airport.
   * @return The country name of the airport.
   */
  public String getCountry(String code) {
    m_lookupResult = m_airportTable.findRow(code, "IATA");
    return m_lookupResult.getString("Country");
  }

  /**
   * CKM
   *
   * Gets the ISO 3166 country code of an airport from its IATA code.
   *
   * @param code The IATA code of the airport.
   * @return The ISO 3166 country code of the airport.
   */
  public String getISO3166(String code) {
    m_lookupResult = m_airportTable.findRow(code, "IATA");
    return m_lookupResult.getString("ISO-3166");
  }

  /**
   * CKM
   *
   * Gets the IATA code of an airport from its index.
   *
   * @param index The index of the airport.
   * @return The IATA code of the airport.
   */
  public String getCode(int index) {
    m_lookupResult = m_airportTable.findRow(String.valueOf(index), "Key");
    return m_lookupResult.getString("IATA");
  }

  /**
   * CKM
   *
   * Gets the airport index from an airport IATA code.
   *
   * @param code The IATA code of the airport.
   * @return The index of the airport.
   */
  public int getIndex(String code) {
    m_lookupResult = m_airportTable.findRow(code, "IATA");
    return m_lookupResult.getInt("Key");
  }
  
  public int getAirlineIndex(String code){
    m_lookupResult = m_airlineTable.findRow(code, "IATA");
    return m_lookupResult.getInt("Key");
  }

  /**
   * CKM
   *
   * Gets the latitude of an airport from its index.
   *
   * @param index The index of the airport.
   * @return The latitude of the airport.
   */
  public float getLatitudeFromIndex(int index) {
    m_lookupResult = m_airportTable.findRow(String.valueOf(index), "Key");
    return m_lookupResult.getFloat("Latitude");
  }

  /**
   * CKM
   *
   * Gets the longitude of an airport from its index.
   *
   * @param index The index of the airport.
   * @return The longitude of the airport.
   */
  public float getLongitudeFromIndex(int index) {
    m_lookupResult = m_airportTable.findRow(String.valueOf(index), "Key");
    return m_lookupResult.getFloat("Longitude");
  }

  /**
   * CKM
   *
   * Gets the name of an airport from its index.
   *
   * @param index The index of the airport.
   * @return The name of the airport.
   */
  public String getAirportNameFromIndex(int index) {
    m_lookupResult = m_airportTable.findRow(String.valueOf(index), "Key");
    return m_lookupResult.getString("Name");
  }

  /**
   * CKM
   *
   * Gets the city name of an airport from its index.
   *
   * @param index The index of the airport.
   * @return The city name of the airport.
   */
  public String getCityFromIndex(int index) {
    m_lookupResult = m_airportTable.findRow(String.valueOf(index), "Key");
    return m_lookupResult.getString("City");
  }

  /**
   * CKM
   *
   * Gets the country name of an airport from its index.
   *
   * @param index The index of the airport.
   * @return The country name of the airport.
   */
  public String getCountryFromIndex(int index) {
    m_lookupResult = m_airportTable.findRow(String.valueOf(index), "Key");
    return m_lookupResult.getString("Country");
  }

  /**
   * CKM
   *
   * Gets the ISO 3166 country code of an airport from its index.
   *
   * @param index The index of the airport.
   * @return The ISO 3166 country code of the airport.
   */
  public String getISO3166FromIndex(int index) {
    m_lookupResult = m_airportTable.findRow(String.valueOf(index), "Key");
    return m_lookupResult.getString("ISO-3166");
  }

  /**
   * CKM
   *
   * Gets the IATA code of an airline from its index.
   *
   * @param airlineIndex The index of the airline.
   * @return The IATA code of the airline.
   */
  public String getAirlineCode(int airlineIndex) {
    m_lookupResult = m_airlineTable.findRow(String.valueOf(airlineIndex), "Key");
    return m_lookupResult.getString("IATA");
  }

  /**
   * CKM
   *
   * Gets the name of an airline carrier from its index.
   *
   * @param airlineIndex The index of the airline.
   * @return The name of the airline carrier.
   */
  public String getAirlineName(int airlineIndex) {
    m_lookupResult = m_airlineTable.findRow(String.valueOf(airlineIndex), "Key");
    return m_lookupResult.getString("Airline");
  }
  
    /**
   * CKM
   *
   * Gets the index of an airline carrier from its IATA code.
   *
   * @param airlineCode The code of the airline.
   * @return The index of the airline carrier.
   */
  public int getAirlineIndex(String airlineCode) {
    m_lookupResult = m_airlineTable.findRow(airlineCode, "IATA");
    return m_lookupResult.getInt("Key");
  }
  
  /**
   * CKM
   *
   * Gets the tail number of an aircraft from the index.
   *
   * @param planeIndex The index of the plane.
   * @return The registration of the plane.
   */
  public String getTailNumberfromIndex (int planeIndex) {
    m_lookupResult = m_aircraftTable.findRow(String.valueOf(planeIndex), "Key");
    return m_lookupResult.getString("Registration");
  }
  
  /**
   * CKM
   *
   * Gets the index of an aircraft from its tail number.
   *
   * @param tailNumber The registration of the plane.
   * @return The index of the plane.
   */
  public int getIndexfromTailNumber (String tailNumber) {
    m_lookupResult = m_aircraftTable.findRow(tailNumber, "Registration");
    return m_lookupResult.getInt("Key");
  }

  /**
   * T. Creagh
   *
   * Queries flights based on the given criteria.
   *
   * @param flightsList An array of FlightType objects to be queried.
   * @param flightQuery The type of query to perform.
   * @param queryValue The value to query against.
   * @return An array of FlightType objects that match the query criteria.
   */
  public FlightType[] queryFlights(FlightType[] flightsList, FlightQueryType flightQuery, int queryValue) {
    if (!isLegalQuery(flightQuery)) {
      println("Error: FlightQuery.Type is illegal with FlightQuery.Operator" + flightQuery.Operator);
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

  /**
   * T. Creagh
   *
   * Queries flights within a specified range based on the given flight range query.
   *
   * @param flightsList An array of FlightType objects to be queried.
   * @param flightRangeQuery The type of range query to perform.
   * @param start The starting index of the range.
   * @param end The ending index of the range.
   * @return An array of FlightType objects that fall within the specified range.
   */
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

  /**
   * T. Creagh
   *
   * Retrieves the value of a field from a FlightType object based on the given query type.
   *
   * @param flight The FlightType object from which to retrieve the field value.
   * @param queryType The type of query to perform.
   * @return The value of the specified field from the FlightType object.
   */
  private int getFlightTypeFieldFromQueryType(FlightType flight, QueryType queryType) {
    return getFlightTypeFieldFromQueryType(flight, queryType, false);
  }

  /**
   * T. Creagh
   *
   * Retrieves the value of a field from a FlightType object based on the given query type, with an option to convert times to minutes.
   *
   * @param flight The FlightType object from which to retrieve the field value.
   * @param queryType The type of query to perform.
   * @param convertTimes A boolean indicating whether to convert times to minutes.
   * @return The value of the specified field from the FlightType object.
   */
  private int getFlightTypeFieldFromQueryType(FlightType flight, QueryType queryType, boolean convertTimes) {
    switch(queryType) {
    case MONTH:
      return (int)flight.Month;
      
    case DAY:
      return (int)flight.Day;

    case CARRIER_CODE_INDEX:
      return (int)flight.CarrierCodeIndex;

    case FLIGHT_NUMBER:
      return (int)flight.FlightNumber;
      
    case TAIL_NUMBER:
      return (int)flight.TailNumber;

    case AIRPORT_ORIGIN_INDEX:
      return (int)flight.AirportOriginIndex;

    case AIRPORT_DEST_INDEX:
      return (int)flight.AirportDestIndex;

    case DEPARTURE_DELAY:
      return (int)flight.DepartureDelay;

    case ARRIVAL_DELAY:
      return (int)flight.ArrivalDelay;

    case CANCELLED:
      return (int)flight.Cancelled;

    case DIVERTED:
      return (int)flight.Diverted;
      
    case SCHEDULED_DURATION:
      return (int)flight.ScheduledDuration;
      
    case ACTUAL_DURATION:
      return (int)flight.ActualDuration;

    case KILOMETRES_DISTANCE:
      return (int)flight.KmDistance;

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

  /**
   * T. Creagh
   *
   * Converts a time in clock format to minutes.
   *
   * @param time The time in clock format.
   * @return The time converted to minutes.
   */
  private int convertClockToMinutes(int time) {
    int hours = (int)(time / 100.0f);
    int mins = (int)(time % 100.0f);
    return mins + (hours * 60);
  }

  /**
   * T. Creagh
   *
   * Checks if a flight query is legal based on the flight query type and location.
   *
   * @param flightQuery The FlightQueryType object representing the query.
   * @return True if the query is legal, false otherwise.
   */
  private boolean isLegalQuery(FlightQueryType flightQuery) {
    if (flightQuery.Location == QueryLocationType.US) {
      switch(flightQuery.Type) {
      case CARRIER_CODE_INDEX:
      case FLIGHT_NUMBER:
      case TAIL_NUMBER:
      case AIRPORT_ORIGIN_INDEX:
      case AIRPORT_DEST_INDEX:
      case CANCELLED:
      case DIVERTED:
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

  /**
   * T. Creagh
   *
   * Checks if a flight range query is legal based on the flight range query type and location.
   *
   * @param flightRangeQuery The FlightRangeQueryType object representing the query.
   * @return True if the query is legal, false otherwise.
   */
  private boolean isLegalQuery(FlightRangeQueryType flightRangeQuery) {
    if (flightRangeQuery.Location == QueryLocationType.WORLD)
      return false;

    switch(flightRangeQuery.Type) {
    case CARRIER_CODE_INDEX:
    case FLIGHT_NUMBER:
    case TAIL_NUMBER:
    case AIRPORT_ORIGIN_INDEX:
    case AIRPORT_DEST_INDEX:
    case CANCELLED:
      return false;
    default:
      return true;
    }
  }

  /**
   * T. Creagh
   *
   * Sorts an array of FlightType objects based on the given sort query.
   *
   * @param flightsList An array of FlightType objects to be sorted.
   * @param flightSortQuery The type of sort to perform.
   * @return The sorted array of FlightType objects.
   */
  public FlightType[] sort(FlightType[] flightsList, FlightSortQueryType flightSortQuery) {
    Comparator<FlightType> flightComparator;
    switch(flightSortQuery.Type) {
    case MONTH:
      flightComparator = Comparator.comparingInt(flight -> flight.Month);
      break;
      
    case DAY:
      flightComparator = Comparator.comparingInt(flight -> flight.Day);
      break;

    case CARRIER_CODE_INDEX:
      flightComparator = Comparator.comparingInt(flight -> flight.CarrierCodeIndex);
      break;

    case FLIGHT_NUMBER:
      flightComparator = Comparator.comparingInt(flight -> flight.FlightNumber);
      break;
      
    case TAIL_NUMBER:
      flightComparator = Comparator.comparingInt(flight -> flight.TailNumber);
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

    case CANCELLED:
      flightComparator = Comparator.comparingInt(flight -> flight.Cancelled);
      break;
      
    case SCHEDULED_DURATION:
      flightComparator = Comparator.comparingInt(flight -> flight.ScheduledDuration);
      break;
    
    case ACTUAL_DURATION:
      flightComparator = Comparator.comparingInt(flight -> flight.ActualDuration);
      break;

    case KILOMETRES_DISTANCE:
      flightComparator = Comparator.comparingInt(flight -> flight.KmDistance);
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

  /**
   * T. Creagh
   *
   * Queries the frequency of flights matching the given criteria.
   *
   * @param flightsList An array of FlightType objects to be queried.
   * @param flightQuery The type of query to perform.
   * @param queryValue The value to query against.
   * @param threadCount The number of threads to use for the query (not implemented yet).
   * @return The frequency of flights matching the query criteria.
   */
  public int queryFrequency(FlightType[] flightsList, FlightQueryType flightQuery, int queryValue, int threadCount) {
    return queryFlights(flightsList, flightQuery, queryValue).length;
  }

  /**
   * T. Creagh
   *
   * Queries the frequency of flights within a specified range.
   *
   * @param flightsList An array of FlightType objects to be queried.
   * @param flightRangeQuery The type of range query to perform.
   * @param start The starting index of the range.
   * @param end The ending index of the range.
   * @param threadCount The number of threads to use for the query (not implemented yet).
   * @return The frequency of flights within the specified range.
   */
  public int queryRangeFrequency(FlightType[] flightsList, FlightRangeQueryType flightRangeQuery, int start, int end, int threadCount) {
    return queryFlightsWithinRange(flightsList, flightRangeQuery, start, end).length;
  }

  /**
   * T. Creagh
   *
   * Returns the specified number of items from the beginning of an array of FlightType objects.
   *
   * @param flightList The array of FlightType objects.
   * @param numberOfItems The number of items to retrieve.
   * @return An array containing the specified number of items from the beginning of the input array.
   */
  public FlightType[] getHead(FlightType[] flightList, int numberOfItems) {
    return Arrays.copyOfRange(flightList, 0, numberOfItems);
  }

  /**
   * T. Creagh
   *
   * Returns the specified number of items from the end of an array of FlightType objects.
   *
   * @param flightList The array of FlightType objects.
   * @param numberOfItems The number of items to retrieve.
   * @return An array containing the specified number of items from the end of the input array.
   */
  public FlightType[] getFoot(FlightType[] flightList, int numberOfItems) {
    return Arrays.copyOfRange(flightList, numberOfItems, flightList.length);
  }

  /**
   * T. Creagh
   *
   * Returns a subarray of FlightType objects within the specified range.
   *
   * @param flightList The array of FlightType objects.
   * @param start The starting index of the range.
   * @param end The ending index of the range.
   * @return An array containing FlightType objects within the specified range.
   */
  public FlightType[] getWithinRange(FlightType[] flightList, int start, int end) {
    return Arrays.copyOfRange(flightList, start, end);
  }

  /**
   * T. Creagh
   *
   * Parses a given query value from user input into a valid integer based on the query type.
   *
   * @param queryType The type of query.
   * @param inputString The input string to parse.
   * @return The parsed query value as an integer.
   */
  private int formatQueryValue(QueryType queryType, String inputString) {
    switch (queryType) {
    case MONTH:
    case DAY:
    case FLIGHT_NUMBER:
    case KILOMETRES_DISTANCE:
    case DEPARTURE_DELAY:
    case ARRIVAL_DELAY:
    case SCHEDULED_DURATION:
    case ACTUAL_DURATION:
      return tryParseInteger(inputString);

    case SCHEDULED_DEPARTURE_TIME:
    case DEPARTURE_TIME:
    case SCHEDULED_ARRIVAL_TIME:
    case ARRIVAL_TIME:
      return tryParseInteger(inputString.replace(":", ""));

    case CARRIER_CODE_INDEX:
      try {
        return getAirlineIndex(inputString);
      }
      catch (Exception e) {
        return -1;
      }
    
    case AIRPORT_ORIGIN_INDEX:
    case AIRPORT_DEST_INDEX:
      try {
        return getIndex(inputString);
      }
      catch (Exception e) {
        return -1;
      }
    
    case TAIL_NUMBER:
      try {
        return getIndexfromTailNumber(inputString);
      }
      catch (Exception e) {
        return -1;
      }

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
// CKM, added airline lookup functions 13:00 14/03// T. Creagh, Fixing Querys 22:00 23/03
// T. Creagh, Making print 22:30 23/03
// T. Creagh, fixed querySort on delay tiems 00:00 24/03
// T. Creagh, clean up 00:30 24/03
// CKM, added new index based lookups, 20:00 26/03
// CKM, added new queries 17:00 04/04
// CKM, improved query verification 17:00 04/04
