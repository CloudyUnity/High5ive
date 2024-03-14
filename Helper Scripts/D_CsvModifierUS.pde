//CKM : code to pre process data

Table lookupTable;
Table dataTable;
TableRow lookupResult;
int i = 0;

lookupTable = loadTable("airports.csv", "header");
dataTable = loadTable("hex data with iata codes.csv");

for (TableRow row : dataTable.rows()) {
  println(row.getString(3), row.getString(4));
  lookupResult = lookupTable.findRow(row.getString(3), "IATA");
  row.setString(3, lookupResult.getString("Hex"));
  lookupResult = lookupTable.findRow(row.getString(4), "IATA");
  row.setString(4, lookupResult.getString("Hex"));
  println(i); 
  i +=1;
}

saveTable(dataTable, "hex_flight_data.csv");
println("ended");
exit();
