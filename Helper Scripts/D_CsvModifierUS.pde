//CKM : code to pre process data

Table lookupTable;
Table dataTable;
TableRow lookupResult;
int i = 0;

lookupTable = loadTable("airport_lookup_table.csv");
dataTable = loadTable("723 full flights.csv");

for (TableRow row : dataTable.rows()) {
  lookupResult = lookupTable.findRow(row.getString(3), 0);
  row.setString(3, lookupResult.getString(2));
  lookupResult = lookupTable.findRow(row.getString(4), 0);
  row.setString(4, lookupResult.getString(2));
  println(i); 
  i +=1;
}

saveTable(dataTable, "hex_flight_data.csv");
println("ended");
exit();
