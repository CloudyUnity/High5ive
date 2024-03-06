import java.util.Arrays;
import java.util.List;
import java.io.FileInputStream;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.file.Paths;
import java.nio.file.Path;
import java.io.*;


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

// byte = 1 byte
// short = 2 bytes
// boolean = 1 byte
// int = 4 bytes
// 5(1) + 2(1) + 5(2) = 17 bytes
class RawFlightType {
  public byte Day;
  public byte CarrierCodeIndex;
  public short FlightNumber;
  public short AirportOriginIndex;
  public short AirportDestIndex;
  public short ScheduledDepartureTime =0, DepartureTime =0, ScheduledArrivalTime =0, ArrivalTime =0;
  public byte CancelledOrDiverted;
  public short MilesDistance;
}

// These methods should run asynchrously using thread()
// If this class is currently writing to any data then m_dataLocked should be on which prevents access
// Other classes can check every frame after invoking these methods to see if the result has returned
// Pre-processing the data into files is allowed and may be useful to improve performance!!
class FlightsManagerClass {
  private boolean m_dataLocked;
  private ArrayList<FlightType> m_flightsList = new ArrayList<FlightType>();
  private ArrayList<RawFlightType> m_rawFlightsList = new ArrayList<RawFlightType>();
  private List<String> m_carrierCodes = Arrays.asList("AA", "AS", "B6");
  private List<String> m_airportCodes = Arrays.asList("JFK", "DCA");

  public ArrayList<RawFlightType> getRawFlightsList() {
    if (m_dataLocked)
      return null;

    return m_rawFlightsList;
  }

  public ArrayList<FlightType> getFlightsList() {
    if (m_dataLocked)
      return null;

    return m_flightsList;
  }

  // Should work with both relative and absolute filepaths if possible 
  // Relative: "./Data/flights2k.csv"
  // Absolute: "C:\Users\finnw\OneDrive\Documents\Trinity\CS\Project\FATMKM\data\flights2k.csv"
  public void converFileToRawFlightType(String filepath) {
    MappedByteBuffer buffer;
    String path = sketchPath() + "\\" + filepath;
    try {

      final FileChannel channel = new FileInputStream(path).getChannel();
      buffer = channel.map(FileChannel.MapMode.READ_ONLY, 0, channel.size());
      channel.close();
      // byte[] byteArray = new byte[buffer.slice(0, 24).remaining()];
      // buffer.slice(0, 24).get(byteArray);
      // RawFlightType newRawFlightType = (RawFlightType)SerializationUtils.deserialize(byteArray);

      // println(newRawFlightType);

      for (int i = 0; i < NUMBER_OF_LINES; i++) {
        RawFlightType temp = new RawFlightType();
        temp.Day = buffer.get();
        temp.CarrierCodeIndex = buffer.get();
        temp.FlightNumber = buffer.getShort();
        temp.AirportOriginIndex = buffer.getShort();
        temp.AirportDestIndex = buffer.getShort();
        temp.ScheduledDepartureTime = buffer.getShort();
        temp.DepartureTime = buffer.getShort();
        temp.ScheduledArrivalTime = buffer.getShort();
        temp.ArrivalTime = buffer.getShort();
        temp.CancelledOrDiverted = buffer.get();
        temp.MilesDistance = buffer.getShort();
        m_rawFlightsList.add(temp);
      }
    } catch (Exception e) {
      println("Error: " + e);
      return;
    }

  }

  // The following functions should modify member variables and not return values as they run asynchrously
  // Converts the string[] line by line into a ArrayList<FlightType> member variable
  public void convertRawFlightTypeToFlightType() {
    // for (int i = 0; i < m_rawFlightsList.size(); i++) {
    //   RawFlightType rawTemp = m_rawFlightsList.get(i);
    //   FlightType temp = new FlightType();
    //   FlightType.FlightDate = rawTemp
    // }
  }

  // Should work if given airport code or name
  public void queryFlightsWithAirport(String airport) {
  }

  public void queryFlightsWithinDates(DateType startDate, DateType endDate) {
  }

  public void sortFlightsByLateness() {
  }
}

// Descending code authorship changes:
// F. Wright, Made DateType, FlightType, FlightsManagerClass and made function headers. Left comments to explain how everything could be implemented, 11pm 04/03/24
// F. Wright, Started work on storing the FlightType data as raw binary data for efficient data transfer, 1pm 05/03/24
// T. Creagh, Did the first attempt at reading the binary file and now it very efficiently gets the data into RawFlightType, 9:39pm 05/03/24
