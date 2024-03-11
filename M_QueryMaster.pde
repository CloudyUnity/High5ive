//CKM: code to return details about airports

class coordLookup {

  Table airportTable = loadTable("data/airports.csv");
  TableRow lookupResult;

  
  float getLatitude(String code) {
    lookupResult = airportTable.findRow(code, 3);
    return lookupResult.getFloat(4);
  }
  float getLongitude(String code) {
    lookupResult = airportTable.findRow(code, 3);
    return lookupResult.getFloat(5);
  }
  String getAirportName(String code) {
    lookupResult = airportTable.findRow(code, 3);
    return lookupResult.getString(0);
  }
  String getCity(String code) {
    lookupResult = airportTable.findRow(code, 3);
    return lookupResult.getString(1);
  }
  String getCountry(String code) {
    lookupResult = airportTable.findRow(code, 3);
    return lookupResult.getString(2);
  }
}
