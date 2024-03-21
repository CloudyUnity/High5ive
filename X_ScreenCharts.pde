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
  PieChartUI m_pieChart;
  ScatterChartUI m_scatterPlot;

  QueryManagerClass m_queryRef;
  FlightType[] m_cachedFlights = null;
    
  QueryType m_histQuery = QueryType.DAY;  
  QueryType m_scatterQueryX = QueryType.KILOMETRES_DISTANCE;
  QueryType m_scatterQueryY = QueryType.ARRIVAL_DELAY;

  Widget m_selectedGraph;

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
    addWidget(m_histogram);
    m_histogram.setTitle("X-Day, Y-Frequency");
    m_selectedGraph = m_histogram;

    m_pieChart = new PieChartUI<FlightType, Integer>(width/2, height/2, 250);
    addWidget(m_pieChart);
    m_pieChart.setRendering(false);
    
    m_scatterPlot = new ScatterChartUI<FlightType>(500, 50, 1000, 1000);
    addWidget(m_scatterPlot);
    m_scatterPlot.setRendering(false);                   

    DropdownUI fieldSelector = new DropdownUI<QueryType>(20, 200, 300, 200, 50, v -> v.toString());
    addWidget(fieldSelector);
    fieldSelector.getOnSelectionChanged().addHandler(e -> {

      ListboxSelectedEntryChangedEventInfoType elistbox = (ListboxSelectedEntryChangedEventInfoType)e;
      m_histQuery = (QueryType)elistbox.data;

      if (m_histQuery == null)
      return;

      reloadData();
    }
    );

    fieldSelector.add(QueryType.DAY);
    fieldSelector.add(QueryType.FLIGHT_NUMBER);
    fieldSelector.add(QueryType.CARRIER_CODE_INDEX);
    fieldSelector.add(QueryType.AIRPORT_ORIGIN_INDEX);
    fieldSelector.add(QueryType.AIRPORT_DEST_INDEX);
    fieldSelector.add(QueryType.CANCELLED_OR_DIVERTED);

    RadioButtonGroupTypeUI group = new RadioButtonGroupTypeUI();
    addWidgetGroup(group);

    RadioButtonUI histRadio = new RadioButtonUI(width/3, 20, 50, 50, "Histogram");
    histRadio.getOnCheckedEvent().addHandler(e -> selectHistogram());
    group.addMember(histRadio);

    RadioButtonUI pieRadio = new RadioButtonUI(width/2, 20, 50, 50, "Pie");
    pieRadio.getOnCheckedEvent().addHandler(e -> selectPieChart());
    group.addMember(pieRadio);

    RadioButtonUI scatterRadio = new RadioButtonUI(width/3 * 2, 20, 50, 50, "Scatter Plot");
    scatterRadio.getOnCheckedEvent().addHandler(e -> selectScatterPlot());
    group.addMember(scatterRadio);

    ButtonUI returnBttn = createButton(20, 20, 100, 100);
    returnBttn.getOnClickEvent().addHandler(e -> switchScreen(e, SCREEN_1_ID));
    returnBttn.setText("Return");
    returnBttn.setTextSize(25);

    returnBttn.setGrowScale(1.05);

  }

  public void loadData(FlightType[] flights) {
    m_cachedFlights = flights;
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

    m_pieChart.removeData();
    m_pieChart.addData(m_cachedFlights, f -> {
      return m_queryRef.getFlightTypeFieldFromQueryType((FlightType)f, m_histQuery);
    });
    
    m_scatterPlot.removeData();
    m_scatterPlot.addData(m_cachedFlights, 
    fX -> {
      return m_queryRef.getFlightTypeFieldFromQueryType((FlightType)fX, m_scatterQueryX);
    },
    fY -> {
      return m_queryRef.getFlightTypeFieldFromQueryType((FlightType)fY, m_scatterQueryY);
    }
    );
  } 

  public void selectHistogram() {
    m_selectedGraph.setRendering(false);
    m_selectedGraph = m_histogram;
    m_selectedGraph.setRendering(true);
  }

  public void selectPieChart() {
    m_selectedGraph.setRendering(false);
    m_selectedGraph = m_pieChart;
    m_selectedGraph.setRendering(true);
  }

  public void selectScatterPlot() {
    m_selectedGraph.setRendering(false);
    m_selectedGraph = m_scatterPlot;
    m_selectedGraph.setRendering(true);
  }
}
