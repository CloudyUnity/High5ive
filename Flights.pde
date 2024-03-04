class DateType {
  public int Year, Month, Day;
}

class FlightType {
  public DateType FlightDate;
  public String CarrierCode;
  public int FlightNumber;
  public String AirportOriginCode, AirportOriginName, AirportOriginState, AirportOriginWAC;
  public String AirportDestCode, AirportDestName, AirportDestState, AirportDestWAC;
  public int CRSDepartureTime, DepartureTime, CRSArrivalTime, ArrivalTime;
  public boolean Cancelled, Diverted;
  public int MilesDistance;
}

// These methods should run asynchrously using thread()
// If this class is currently writing to any data then m_dataLocked should be on which prevents access
// Other classes can check every frame after invoking these methods to see if the result has returned
class FlightsManagerClass {
  private boolean m_dataLocked;
  private ArrayList<FlightType> m_flightsList = new ArrayList<FlightType>();

  public ArrayList<FlightType> getFlightsList() {
    if (m_dataLocked)
      return null;

    return m_flightsList;
  } 

  // Should work with both relative and absolute filepaths if possible
  // Relative: "./Data/flights2k.csv"
  // Absolute: "C:\Users\finnw\OneDrive\Documents\Trinity\CS\Project\FATMKM\data\flights2k.csv"
  public void readFile(String filepath) {
  }
  
  // The following functions should modify member variables and not return values as they run asynchrously 

  // Converts the string[] line by line into a ArrayList<FlightType> member variable
  public void parseFile(String[] data) {
  }  

  // Should work if given airport code or name
  public void queryFlightsWithAirport(String airport) {
  }

  public void queryFlightsWithinDates(DateType startDate, DateType endDate) {
  }

  public void sortFlightsByLateness() {
  }
}
