/**
 * CKM
 *
 * Replaces more complex text values in dataset with hexadecimal indexes
 *
 * @param airports: lookup table with values for each code
 @ @param aircraft: lookup table with values for each registration
 @ @param airlines: lookup table with values for each code
 @ @param dataTable: original source data to edit
 @ return fixList: list of aircraft with missing data in the lookup table
 @ return hex_flight_data.csv: output file with hex values replacing text values
 */

Table airports;
Table aircraft;
Table airlines;
Table dataTable;
TableRow lookupResult;
StringList fixList;
int i = 0;
final long START_TIME = System.currentTimeMillis(); 

airports = loadTable("airports.csv", "header");
aircraft = loadTable("aircraft.csv", "header");
airlines = loadTable("airlines.csv", "header");
dataTable = loadTable("pre hex keying.csv");

fixList = new StringList();

for (TableRow row : dataTable.rows()) {
  //println(row.getString(2));
  lookupResult = airlines.findRow(row.getString(2), "IATA");
  row.setString(2, lookupResult.getString("Hex"));
  //println(row.getString(4));
  try {
    try {
      lookupResult = aircraft.findRow(row.getString(4), "Registration");
      row.setString(4, lookupResult.getString("Hex"));
    } 
    catch (NullPointerException e) {
      lookupResult = aircraft.findRow(row.getString(4), "Compatability");
      row.setString(4, lookupResult.getString("Hex"));
    }
  }
  catch (NullPointerException f) {
    if (!fixList.hasValue(row.getString(4))) {
    fixList.append(row.getString(4));
    }
  }
  //println(row.getString(5));
  lookupResult = airports.findRow(row.getString(5), "IATA");
  row.setString(5, lookupResult.getString("Hex"));
  //println(row.getString(6));
  lookupResult = airports.findRow(row.getString(6), "IATA");
  row.setString(6, lookupResult.getString("Hex"));
  println(i); 
  i +=1;
}

saveTable(dataTable, "hex_flight_data.csv");
println("ended");
println(fixList);
println((System.currentTimeMillis()-START_TIME)/1000 + "s");
exit();
