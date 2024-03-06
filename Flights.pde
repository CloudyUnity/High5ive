import java.util.Arrays;
import java.io.FileInputStream;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.file.Paths;
import java.nio.file.Path;
import java.io.*;

class DateType { // TO BE REMOVED?
  public int Year, Month, Day;
}

class FlightType { // TO BE REMOVED?
  public DateType FlightDate;
  public String CarrierCode;
  public int FlightNumber;
  public String AirportOriginCode, AirportOriginName, AirportOriginState, AirportOriginWAC;
  public String AirportDestCode, AirportDestName, AirportDestState, AirportDestWAC;
  public int CRSDepartureTime, DepartureTime, CRSArrivalTime, ArrivalTime;
  public boolean Cancelled, Diverted;
  public int MilesDistance;
}

class RawFlightType { // 24 bytes total
  public byte Day;
  public byte CarrierCodeIndex;
  public short FlightNumber;
  public short AirportOriginIndex;
  public short AirportDestIndex;
  public short ScheduledDepartureTime =0, DepartureTime =0, ScheduledArrivalTime =0, ArrivalTime =0;
  public byte CancelledOrDiverted;
  public short MilesDistance;
}

class FlightsManagerClass {
  private ArrayList<FlightType> m_flightsList = new ArrayList<FlightType>();
  private ArrayList<RawFlightType> m_rawFlightsList = new ArrayList<RawFlightType>();

  public ArrayList<RawFlightType> getRawFlightsList() {
    return m_rawFlightsList;
  }

  public ArrayList<FlightType> getFlightsList() {   
    return m_flightsList;
  }

  // This file should take in an Consumer that passes back the m_rawFlightsList asynchrously. Finn can explain
  public void converFileToRawFlightType(String filepath) {
    MappedByteBuffer buffer;
    String path = sketchPath() + "\\" + filepath;
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
    }
    catch (Exception e) {
      println("Error: " + e);
      return;
    }
  }
  
  public void convertRawFlightTypeToFlightType() {
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
// F. Wright, Minor code cleanup, 1pm 06/03/24
