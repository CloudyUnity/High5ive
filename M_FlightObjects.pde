class FlightType { // 23 bytes total
  public byte Day;                      // supports all querys
  public byte CarrierCodeIndex;         // only supports EQUAL or NOT_EQUAL
  public short FlightNumber;            // only supports EQUAL or NOT_EQUAL
  public short AirportOriginIndex;      // only supports EQUAL or NOT_EQUAL
  public short AirportDestIndex;        // only supports EQUAL or NOT_EQUAL
  public short ScheduledDepartureTime;  // supports all querys
  public short DepartureTime;           // supports all querys
  public short DepartureDelay;          // supports all querys
  public short ScheduledArrivalTime;    // supports all querys
  public short ArrivalTime;             // supports all querys
  public short ArrivalDelay;            // supports all querys
  public byte CancelledOrDiverted;      // only supports EQUAL or NOT_EQUAL
  public short MilesDistance;           // supports all querys

  FlightType(
    byte day, byte carrierCodeIndex, short flightNumber,
    short airportOriginIndex, short airportDestIndex, short scheduledDepartureTime,
    short departureTime, short departureDelay, short scheduledArrivalTime, 
    short arrivalTime, short arrivalDelay, byte cancelledOrDiverted, 
    short milesDistance) {

    this.Day = day;
    this.CarrierCodeIndex = carrierCodeIndex;
    this.FlightNumber = flightNumber;
    this.AirportOriginIndex = airportOriginIndex;
    this.AirportDestIndex = airportDestIndex;
    this.ScheduledDepartureTime = scheduledDepartureTime;
    this.DepartureTime = departureTime;
    this.DepartureDelay = departureDelay;
    this.ScheduledArrivalTime = scheduledArrivalTime;
    this.ArrivalTime = arrivalTime;
    this.ArrivalDelay = arrivalDelay;
    this.CancelledOrDiverted = cancelledOrDiverted;
    this.MilesDistance = milesDistance;
  }

  public FlightType() {
  }
}

class FlightQuery {
  public QueryType Type;
  public QueryOperator Operator;
  public QueryLocation Location;


  FlightQuery(QueryType type, QueryOperator operator, QueryLocation location) {
    this.Type = type;
    this.Operator = operator;
    this.Location = location;
  }
}

class FlightRangeQuery {
  public QueryType Type;
  public QueryLocation Location;

  FlightRangeQuery(QueryType type, QueryLocation location) {
    this.Type = type;
    this.Location = location;
  }
}

class FlightSortQuery {
  public QueryType Type;
  public QuerySortDirection SortDirection;

  FlightSortQuery(QueryType type, QuerySortDirection sortDirection) {
    this.Type = type;
    this.SortDirection = sortDirection;
  }
}


public enum QueryType {
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

public enum QueryOperator {
  EQUAL,
  NOT_EQUAL,
  LESS_THAN,
  LESS_THAN_EQUAL,
  GREATER_THAN,
  GREATER_THAN_EQUAL,
}

public enum QuerySortDirection {
  ASCENDING,
  DESCENDING,
}

public enum QueryLocation {
  US,
  WORLD,
}

// Descending code authorship changes:
// T. Creagh, added enums into this file, 11pm 06/03/24
// T. Creagh, added in FlightQuery, 8pm 12/03/24