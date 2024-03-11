//CKM: code to return details about airports

class QueryManagerClass {

  Table m_airportTable;
  Table m_usaAirportIndexes;
  TableRow m_lookupResult;

  void init() {
    m_airportTable = loadTable("data/Preprocessed Data/airports.csv", "header");
    m_usaAirportIndexes = loadTable("data/Preprocessed Data/airport_lookup_table.csv", "header");
  }

  float getLatitude(String code) {
    lookupResult = airportTable.findRow(code, "IATA");
    return lookupResult.getFloat("Latitude");
  }
  float getLongitude(String code) {
    lookupResult = airportTable.findRow(code, "IATA");
    println(code);
    println(debugCount); // REMOVE DEBUG COUNT WHEN DELETING THIS LINE
    debugCount++;
    return m_lookupResult.getFloat(5);
  }
  String getAirportName(String code) {
    lookupResult = airportTable.findRow(code, "IATA");
    return lookupResult.getString("Name");
  }
  String getCity(String code) {
    lookupResult = airportTable.findRow(code, "IATA");
    return lookupResult.getString("City");
  }
  String getCountry(String code) {
    lookupResult = airportTable.findRow(code, "IATA");
    return lookupResult.getString("Country");
  }
  String getCode(int index) {
    m_lookupResult = m_usaAirportIndexes.findRow(String.valueOf(index), "Index");
    return m_lookupResult.getString("IATA");
  }
}
