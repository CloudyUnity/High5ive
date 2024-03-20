class FlightType { // 23 bytes total
  public byte Day;                      // supports all querys
  public short CarrierCodeIndex;        // only supports EQUAL or NOT_EQUAL
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

class FlightMultiDataType {
  public FlightType[] US;
  public FlightType[] WORLD;

  FlightMultiDataType(FlightType[] us, FlightType[] world) {
    this.US = us;
    this.WORLD = world;
  }
}

class FlightQueryType {
  QueryManagerClass queryManager;
  
  public int QueryValue;
  public QueryType Type;
  public QueryOperatorType Operator;
  public QueryLocationType Location;


  FlightQueryType(QueryType type, QueryOperatorType operator, QueryLocationType location, QueryManagerClass queryManager) {
    this.Type = type;
    this.Operator = operator;
    this.Location = location;
    this.queryManager = queryManager;
  }

  public void setOperator(QueryOperatorType inputOperator) {
    //Needed since Ill be declaring all FlightQueries at the start then adjusting them to user input
    Operator = inputOperator;
  }
  /* TO IMPLEMENT 

   CANCELLED_OR_DIVERTED,

   }*/
  private int formatQueryValue(String inputString) {

    int result;

    if (Type == QueryType.DAY || Type == QueryType.FLIGHT_NUMBER || Type == QueryType.KILOMETRES_DISTANCE || Type == QueryType.DEPARTURE_DELAY || Type == QueryType.ARRIVAL_DELAY ) {
      try {
        return Integer.parseInt(inputString);
      }
      catch(Exception e) {
        return 0;
      }
    } else if (Type == QueryType.SCHEDULED_DEPARTURE_TIME || Type == QueryType.DEPARTURE_TIME || Type == QueryType.SCHEDULED_ARRIVAL_TIME || Type == QueryType.ARRIVAL_TIME) {

      /*NOTE FOR ANYONE READING THIS!!!!!! We need to decide on an expected User inputted format for these, since that will decide how this is formatted.
       for now I will assume that flightTimes will be entered as formatted in the data set (i,e 1922 == 19:22) however I am seperating these if statements despite them being the
       same. In the event that we decide this format works then we can change this*/

      try {
        return Integer.parseInt(inputString);
      }
      catch(Exception e) {
        return 0;
      }
    } else if (Type == QueryType.CARRIER_CODE_INDEX || Type == QueryType. AIRPORT_ORIGIN_INDEX || Type == QueryType.AIRPORT_DEST_INDEX) {
     
      return queryManager.getIndex(inputString);
      
    }
    else {
    
    return 0; 
    
    }

    
  }

  public void setQueryValue(String inputString) {

    QueryValue = formatQueryValue(inputString);
  }
}

class FlightRangeQueryType {
  public QueryType Type;
  public QueryLocationType Location;

  FlightRangeQueryType(QueryType type, QueryLocationType location) {
    this.Type = type;
    this.Location = location;
  }
}

class FlightSortQueryType {
  public QueryType Type;
  public QuerySortDirectionType SortDirection;

  FlightSortQueryType(QueryType type, QuerySortDirectionType sortDirection) {
    this.Type = type;
    this.SortDirection = sortDirection;
  }
}
class UserQuery {

  public ArrayList<FlightQueryType> FlightQueries;

  UserQuery() {

    FlightQueries = new ArrayList<FlightQueryType>();
  }

  public void addQuery(FlightQueryType inputQuery) {
    FlightQueries.add(inputQuery);
  }

  public void removeQuery(int indexRemoved) {
    FlightQueries.remove(indexRemoved);
  }
  public void clearQueries() {

    FlightQueries.clear();
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

public enum QueryOperatorType {
  EQUAL,
    NOT_EQUAL,
    LESS_THAN,
    LESS_THAN_EQUAL,
    GREATER_THAN,
    GREATER_THAN_EQUAL,
}

public enum QuerySortDirectionType {
  ASCENDING,
    DESCENDING,
}

public enum QueryLocationType {
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
