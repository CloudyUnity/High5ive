/**
 * CKM
 *
 * Replaces more complex text values in dataset with hexadecimal indexes
 *
 * @param airports: lookup table with values for each code
 @ @param airlines: lookup table with values for each code
 @ @param dataTable: original source data to edit
 @ return hex_world_flight_data.csv: output file with hex values replacing text values
 */

Table lookupTableAirlines;
Table lookupTableAirports;
Table dataTable;
TableRow lookupResult;
int i = 0;

lookupTableAirlines = loadTable("airlines.csv", "header");
lookupTableAirports = loadTable("airports.csv", "header");
dataTable = loadTable("full output.csv");

for (TableRow row : dataTable.rows()) {
  lookupResult = lookupTableAirports.findRow(row.getString(1), "IATA");
  println(row.getString(1));
  row.setString(1, lookupResult.getString("Hex"));
  lookupResult = lookupTableAirports.findRow(row.getString(2), "IATA");
  println(row.getString(2));
  row.setString(2, lookupResult.getString("Hex"));
  lookupResult = lookupTableAirlines.findRow(row.getString(0), "IATA");
  println(row.getString(0));
  row.setString(0, lookupResult.getString("Hex"));
  println(i); 
  i +=1;
}

saveTable(dataTable, "hex_world_flight_data.csv");
println("ended");
exit();
