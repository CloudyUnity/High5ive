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
    String path = CURRENT_DIR + "\\" + filepath;
    try {
      final FileChannel channel = new FileInputStream(path).getChannel();
      buffer = channel.map(FileChannel.MapMode.READ_ONLY, 0, channel.size());
      channel.close();

      for (int i = 0; i < NUMBER_OF_LINES; i++) {
        int offset = LINE_BYTE_SIZE * i;
        RawFlightType temp = new RawFlightType();
        temp.Day = buffer.get(offset);
        temp.CarrierCodeIndex = buffer.get(offset+1);
        temp.FlightNumber = buffer.getShort(offset+2);
        temp.AirportOriginIndex = buffer.getShort(offset+4);
        temp.AirportDestIndex = buffer.getShort(offset+6);
        temp.ScheduledDepartureTime = buffer.getShort(offset+8);
        temp.DepartureTime = buffer.getShort(offset+10);
        temp.ScheduledArrivalTime = buffer.getShort(offset+12);
        temp.ArrivalTime = buffer.getShort(offset+14);
        temp.CancelledOrDiverted = buffer.get(offset+16);
        temp.MilesDistance = buffer.getShort(offset+17);
        m_rawFlightsList.add(temp);
      }
    } catch (Exception e) {
      println("Error: " + e);
      return;
    }

  }

  // The following functions should modify member variables and not return values as they run asynchrously
  // Converts the string[] line by line into a ArrayList<FlightType> member variable
      // byte flightFlags = 
  public void convertRawFlightTypeToFlightType() {
  }

  // Should work if given airport code or name
  public void queryFlightsWithAirport(String airport) {
  }

  public void queryFlightsWithinDates(DateType startDate, DateType endDate) {
  }

  public void sortFlightsByLateness() {
  }

  // DEBUG FUNCTIONS DO NOT USE

  public void tinyFlights() {
    String[] data = loadStrings("Data/tinyFlights3.csv");
    RawFlightType[] arr = new RawFlightType[3];

    for (int i = 1; i < data.length; i++) {
      String[] flightData = data[i].split(",");

      arr[i-1] = new RawFlightType();

      arr[i-1].Day = Byte.parseByte(flightData[0].substring(0, 2));
      arr[i-1].CarrierCodeIndex = (byte)m_carrierCodes.indexOf(flightData[1]);
      arr[i-1].FlightNumber = Short.parseShort(flightData[2]);
      arr[i-1].AirportOriginIndex = (byte)m_airportCodes.indexOf(flightData[3]);
      arr[i-1].AirportDestIndex = (byte)m_airportCodes.indexOf(flightData[8]);

      if (!flightData[12].isEmpty())
        arr[i-1].ScheduledDepartureTime = Short.parseShort(flightData[12]);
      if (!flightData[13].isEmpty())
        arr[i-1].DepartureTime = Short.parseShort(flightData[13]);
      if (!flightData[14].isEmpty())
        arr[i-1].ScheduledArrivalTime = Short.parseShort(flightData[14]);
      if (!flightData[15].isEmpty())
        arr[i-1].ArrivalTime = Short.parseShort(flightData[15]);

      arr[i-1].Cancelled = flightData[16] == "1";
      arr[i-1].Diverted = flightData[17] == "1";
      arr[i-1].MilesDistance = Short.parseShort(flightData[18]);
    }

    try {
      DataOutputStream dos = new DataOutputStream(new FileOutputStream("C:\\Users\\finnw\\OneDrive\\Documents\\Trinity\\CS\\Project\\FATMKM\\data\\tinyFlights3Raw.txt"));

      for (int i = 0; i < arr.length; i++) {
        dos.writeByte(arr[i].Day);
        dos.writeByte(arr[i].CarrierCodeIndex);
        dos.writeShort(arr[i].FlightNumber);
        dos.writeByte(arr[i].AirportOriginIndex);
        dos.writeByte(arr[i].AirportDestIndex);

        dos.writeShort(arr[i].ScheduledDepartureTime);
        dos.writeShort(arr[i].DepartureTime);
        dos.writeShort(arr[i].ScheduledArrivalTime);
        dos.writeShort(arr[i].ArrivalTime);

        dos.writeBoolean(arr[i].Cancelled);
        dos.writeBoolean(arr[i].Diverted);
        dos.writeShort(arr[i].MilesDistance);
      }
      
      dos.close();
    }
    catch (Exception e) {
      println("Error: " + e);
      return;
    }
  }
}

// Descending code authorship changes:
// F. Wright, Made DateType, FlightType, FlightsManagerClass and made function headers. Left comments to explain how everything could be implemented, 11pm 04/03/24
// F. Wright, Started work on storing the FlightType data as raw binary data for efficient data transfer, 1pm 05/03/24
// T. Creagh, Did the first attempt at reading the binary file and now it very efficiently gets the data into RawFlightType, 9:39pm 05/03/24
