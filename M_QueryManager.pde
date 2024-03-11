//CKM: code to return details about airports

class QueryManagerClass {

  Table m_airportTable = loadTable("data/airports.csv");
  TableRow m_lookupResult;

  float getLatitude(String code) {
    m_lookupResult = m_airportTable.findRow(code, 3);
    return m_lookupResult.getFloat(4);
  }
  float getLongitude(String code) {
    m_lookupResult = m_airportTable.findRow(code, 3);
    return m_lookupResult.getFloat(5);
  }
  String getAirportName(String code) {
    m_lookupResult = m_airportTable.findRow(code, 3);
    return m_lookupResult.getString(0);
  }
  String getCity(String code) {
    m_lookupResult = m_airportTable.findRow(code, 3);
    return m_lookupResult.getString(1);
  }
  String getCountry(String code) {
    m_lookupResult = m_airportTable.findRow(code, 3);
    return m_lookupResult.getString(2);
  }
}
