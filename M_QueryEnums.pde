public enum FlightQueryType {
  DAY,
  CARRIER_CODE_INDEX,
  FLIGHT_NUMBER,
  AIRPORT_ORIGIN_INDEX,
  AIRPORT_DEST_INDEX,
  SCHEDULED_DEPARTURE_TIME,
  DEPARTURE_TIME,
  DEPARTURE_DELAY,
  SCHEDULED_ARRIVAL_TIME,
  ARRIVAL_TIME,
  ARRIVAL_DELAY,
  CANCELLED_OR_DIVERTED,
  KILOMETRES_DISTANCE,
}

public enum FlightQueryOperator {
  EQUAL,
  NOT_EQUAL,
  LESS_THAN,
  LESS_THAN_EQUAL,
  GREATER_THAN,
  GREATER_THAN_EQUAL,
}

public enum FlightQuerySortDirection {
  ASCENDING,
  DESCENDING,
}

// Descending code authorship changes:
// T. Creagh, added enums into this file, 11pm 06/03/24
// CKM, converted to kilometres, 17:00 12/03
