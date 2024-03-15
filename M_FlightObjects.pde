class FlightType { // 23 bytes total
  public byte Day;                      // supports all querys
  public short CarrierCodeIndex;         // only supports EQUAL or NOT_EQUAL
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
    byte day, short carrierCodeIndex, short flightNumber,
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

  FlightType(short carrierCodeIndex, short airportOriginIndex, short airportDestIndex) {
    this.CarrierCodeIndex = carrierCodeIndex;
    this.AirportOriginIndex = airportOriginIndex;
    this.AirportDestIndex = airportDestIndex;
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

class CoordType {
  public float Latitude;
  public float Longitude;

  public CoordType(float lat, float longi) {
    Latitude = lat;
    Longitude = longi;
  }
}

class AirportPoint3DType {
  public PVector Pos;
  public String Name;
  public color Color = color(0, 255, 0, 255);
  public ArrayList<String> Connections = new ArrayList<String>();
  public ArrayList<ArrayList<PVector>> ConnectionArcPoints = new ArrayList<ArrayList<PVector>>();

  public AirportPoint3DType(PVector pos, String name) {
    Pos = pos;
    Name = name;
  }

  public AirportPoint3DType(PVector pos, String name, color col) {
    Pos = pos;
    Name = name;
    Color = col;
  }
}

// Descending code authorship changes:
// T. Creagh, added enums into this file, 11pm 06/03/24
// F. Wright, Moved 3D objects into this tab from W_FlightMap3D
// T. Creagh, added in FlightQuery, 8pm 12/03/24
// T. Creagh, added in FlightRangeQuery, 9pm 12/03/24
// T. Creagh, added in FlightSortQuery, 10pm 12/03/24
