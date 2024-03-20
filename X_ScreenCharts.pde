/*

 The Plan:
 
 Need to be able to:
 
 Field against Field scatter plots (All fields)
   Ability to reverse order of axis
   Fields (X-axis):
     SDD
     SAA
     Miles
   Fields (Y-axis):
     ANY
 
 Frequency Histogram
   Order dataset by frequency of a field
   Ability to reverse order of dataset
   Fields:
     Day
     Airline
     Carrier
     Origin
     Dest
     Flags
 
 Frequency pie chart for fields:
   Day
   Origin
   Dest
   Airlines
   CarrierCode
   Flags   
 
 Limit dataset based on queries. Use UserQueryUI to do this
 
 */

class ScreenCharts extends Screen {
  BarChartUI m_histogram;
  QueryManagerClass m_queryRef;
  QueryType m_histQuery = QueryType.DAY;
  FlightType[] m_cachedFlights = null;

  public ScreenCharts(String screenId, QueryManagerClass query) {
    super(screenId, DEFAULT_SCREEN_COLOUR);
    
    m_queryRef = query;

    UserQueryUI uqui = new UserQueryUI(0, 0, 1, 1, query, this);
    addWidget(uqui);
    uqui.setOnLoadHandler(flights -> {
      loadData(flights);
    }
    );
    
    m_histogram = new BarChartUI<FlightType, Integer>(500, 50, 1000, 1000);    
    m_histogram.setTitle("X-Day, Y-Frequency");
    
    DropdownUI fieldSelector = new DropdownUI<QueryType>(20, 200, 300, 200, 50, v -> v.toString());
    addWidget(fieldSelector);
    fieldSelector.getOnSelectionChanged().addHandler(e -> {
      ListboxSelectedEntryChangedEventInfoType elistbox = (ListboxSelectedEntryChangedEventInfoType)e;      
      m_histQuery = (QueryType)elistbox.data;     
      if (m_histQuery == null)
        return;
        
      reloadData();
    });
    
    fieldSelector.add(QueryType.DAY);
    fieldSelector.add(QueryType.FLIGHT_NUMBER);
    fieldSelector.add(QueryType.CARRIER_CODE_INDEX);
    fieldSelector.add(QueryType.AIRPORT_ORIGIN_INDEX);
    fieldSelector.add(QueryType.AIRPORT_DEST_INDEX);
    fieldSelector.add(QueryType.CANCELLED_OR_DIVERTED);
    
    ButtonUI returnBttn = createButton(20, 20, 100, 100);
    returnBttn.getOnClickEvent().addHandler(e -> switchScreen(e, SCREEN_1_ID));
    returnBttn.setText("Return");
    returnBttn.setTextSize(25);
    returnBttn.setGrowMode(true);
  }
  
  public void loadData(FlightType[] flights){
    m_cachedFlights = flights;
    addWidget(m_histogram);
    
    reloadData();
  }

  public void reloadData() {
    if (m_cachedFlights == null)
      return;
     
    m_histogram.removeData();
    m_histogram.addData(m_cachedFlights, f -> {
      return m_queryRef.getFlightTypeFieldFromQueryType((FlightType)f, m_histQuery);
    }
    );    
  }  
}
