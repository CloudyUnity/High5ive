//CKM : code to pre process data

Table lookupTableAirlines;
Table lookupTableAirports;
Table dataTable;
TableRow lookupResult;
int i = 0;

lookupTableAirlines = loadTable("airlines.csv");
lookupTableAirports = loadTable("airports.csv");
dataTable = loadTable("world_routes.csv");

for (TableRow row : dataTable.rows()) {
  lookupResult = lookupTableAirports.findRow(row.getString(1), 3);
  row.setString(1, lookupResult.getString(7));
  lookupResult = lookupTableAirports.findRow(row.getString(2), 3);
  row.setString(2, lookupResult.getString(7));
  lookupResult = lookupTableAirlines.findRow(row.getString(0), 1);
  row.setString(0, lookupResult.getString(3));
  println(i); 
  i +=1;
}

saveTable(dataTable, "hex_flight_data.csv");
println("ended");
exit();
