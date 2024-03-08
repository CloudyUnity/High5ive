import java.nio.file.Paths;
import java.nio.file.Path;
import java.nio.file.Files;

class DataPreprocessor {
  HashMap<String, Short> m_airportNameIndexMap = new HashMap<>();
  HashMap<String, Byte> m_carrierCodeIndex = new HashMap<>();

  public void init() {
    convertFileToAirportCodesToName("airport_lookup_table.csv");
    getCarrierCodeIndex();
  }

  public void convertCsvToBinaryFile(String csvFilename, String binaryFilename) {
    // FlightType[] csvFlights = new FlightType[NUMBER_OF_FLIGHT_FULL_LINES];
    String filePath = sketchPath() + DATA_DIRECTOR_PATH + binaryFilename;
    Path path = Paths.get(filePath);
    try {
      if (!Files.exists(path))
        Files.createFile(path);
    } catch (IOException e) {
      e.printStackTrace();
    }
    try (BufferedReader readBuffer = new BufferedReader(
      new FileReader(sketchPath() + DATA_DIRECTOR_PATH + csvFilename))) {
      try (DataOutputStream writeStream = new DataOutputStream(
        new FileOutputStream(sketchPath() + DATA_DIRECTOR_PATH + binaryFilename))) {
        String line;
        String _header = readBuffer.readLine();

        for (int i = 0; i < NUMBER_OF_FLIGHT_FULL_LINES; i++) {
          line = readBuffer.readLine();
          String[] values = line.split(",");
          writeStream.writeByte(Byte.parseByte(values[0].split("/")[0]));
          writeStream.writeByte(m_carrierCodeIndex.get(values[1]));
          writeStream.writeShort(Short.parseShort(values[2]));
          writeStream.writeShort(m_airportNameIndexMap.get(values[3]));
          writeStream.writeShort(m_airportNameIndexMap.get(values[8]));
          writeStream.writeShort(values[13].isEmpty() ? 0 : Short.parseShort(values[13]));
          writeStream.writeShort(values[14].isEmpty() ? 0 : Short.parseShort(values[14]));
          writeStream.writeShort(values[15].isEmpty() ? 0 : Short.parseShort(values[15]));
          writeStream.writeShort(values[16].isEmpty() ? 0 : Short.parseShort(values[16]));
          byte cancelledOrDiverted = 0;
          if (values[17].charAt(0) == 1)
            cancelledOrDiverted = 1;
          if (values[18].charAt(0) == 1)
            cancelledOrDiverted = 2;
          writeStream.writeByte(cancelledOrDiverted);
          writeStream.writeShort(Short.parseShort(values[19].substring(0, values[19].length() - 3)));
        }
        writeStream.close();
        readBuffer.close();
        println("Done: convertCsvToBinaryFile");
      }
      catch (IOException e) {
        println("Error: " + e);
        return;
      }
    }
    catch (IOException e) {
      println("Error: " + e);
      return;
    }
  }

  private void convertFileToAirportCodesToName(String filename) {
    String path = sketchPath() + DATA_DIRECTOR_PATH + filename;

    try (BufferedReader buffer = new BufferedReader(new FileReader(path))) {
      String line = buffer.readLine();
      String[] values = line.split(",");

      m_airportNameIndexMap.put(values[0].substring(values[0].length() - 3, values[0].length()), Short.parseShort(values[1]));
      while ((line = buffer.readLine()) != null) {
        values = line.split(",");
        m_airportNameIndexMap.put(values[0], Short.parseShort(values[1]));
      }
    }
    catch (IOException e) {
      println("Error: " + e);
      return;
    }
  }

  private void getCarrierCodeIndex() {
    m_carrierCodeIndex.put("AA", (byte)0);
    m_carrierCodeIndex.put("AS", (byte)1);
    m_carrierCodeIndex.put("B6", (byte)2);
    m_carrierCodeIndex.put("DL", (byte)3);
    m_carrierCodeIndex.put("F9", (byte)4);
    m_carrierCodeIndex.put("G4", (byte)5);
    m_carrierCodeIndex.put("HA", (byte)6);
    m_carrierCodeIndex.put("NK", (byte)7);
    m_carrierCodeIndex.put("UA", (byte)8);
    m_carrierCodeIndex.put("WN", (byte)9);
  }
}

// Descending code authorship changes:
// T. Creagh, implemented getCarrierCodeIndex, 11pm, 07/03/24
// T. Creagh, implemented convertFileToAirportCodesToName, 12am 07/03/24
// T. Creagh, implemented convertCsvToBinaryFile, 1am 07/03/24
