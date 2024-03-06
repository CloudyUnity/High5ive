//CKM : code to pre process data

Table lookupTable;
Table dataTable;
TableRow lookupResult;
int i = 0;

lookupTable = loadTable("lookup table.csv");
dataTable = loadTable("binary_flights_full.csv");

for (TableRow row : dataTable.rows()) {
  lookupResult = lookupTable.findRow(row.getString(3), 0);
  row.setString(3, lookupResult.getString(1));
  lookupResult = lookupTable.findRow(row.getString(4), 0);
  row.setString(4, lookupResult.getString(1));
  println(i); 
  i +=1;
}

saveTable(dataTable, "binary_flight_data.csv");
println("ended");
exit();
