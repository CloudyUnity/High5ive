//CKM : code to pre process data

Table airports;
Table aircraft;
Table airlines;
Table dataTable;
TableRow lookupResult;
int i = 0;

airports = loadTable("airports.csv", "header");
aircraft = loadTable("aircraft.csv", "header");
airlines = loadTable("airlines.csv", "header");
dataTable = loadTable("pre hex keying.csv");

for (TableRow row : dataTable.rows()) {
  println(row.getString(3), row.getString(4));
  lookupResult = airlines.findRow(row.getString(2), "IATA");
  row.setString(2, lookupResult.getString("Hex"));
  lookupResult = aircraft.findRow(row.getString(4), "Registration");
  row.setString(4, lookupResult.getString("Hex"));
  lookupResult = airports.findRow(row.getString(5), "IATA");
  row.setString(5, lookupResult.getString("Hex"));
  lookupResult = airports.findRow(row.getString(6), "IATA");
  row.setString(6, lookupResult.getString("Hex"));
  println(i); 
  i +=1;
}

saveTable(dataTable, "hex_flight_data.csv");
println("ended");
exit();
