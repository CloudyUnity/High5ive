/*

 The Plan:
 
 Need to be able to:
 
 Field against Field scatter plots (All fields)
 Ability to reverse order of axis
 Fields (Any-axis):
 SDD
 SAA
 Miles
 Day
 
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
 
 */

class ScreenCharts extends Screen {
  HistogramChartUI m_histogram;
  PieChartUI m_pieChart;
  ScatterChartUI m_scatterPlot;
  
  DropdownUI m_freqDD, m_scatterDDX, m_scatterDDY;

  QueryManagerClass m_queryRef;
  FlightType[] m_cachedFlights = null;

  QueryType m_histQuery = QueryType.DAY;
  QueryType m_scatterQueryX = QueryType.KILOMETRES_DISTANCE;
  QueryType m_scatterQueryY = QueryType.ARRIVAL_DELAY;

  Widget m_selectedGraph;

  public ScreenCharts(String screenId, QueryManagerClass query) {
    super(screenId, DEFAULT_SCREEN_COLOUR);

    m_queryRef = query;
  }

  @Override
    public void init() {
    super.init();
    UserQueryUI uqui = new UserQueryUI(0, 0, 1, 1, m_queryRef, this);
    addWidget(uqui);
    uqui.setOnLoadHandler(flights -> {
      loadData(flights);
    }
    );

    m_histogram = new HistogramChartUI<FlightType, Integer>(500, 100, 800, 800);
    addWidget(m_histogram);
    m_histogram.setTitle("X-Day, Y-Frequency");
    m_selectedGraph = m_histogram;

    m_pieChart = new PieChartUI<FlightType, Integer>(width/2, height/2, 250);
    addWidget(m_pieChart);
    m_pieChart.setRendering(false);

    m_scatterPlot = new ScatterChartUI<FlightType>(500, 50, 1000, 1000);
    addWidget(m_scatterPlot);
    m_scatterPlot.setRendering(false);

    m_freqDD = new DropdownUI<QueryType>(20, 200, 300, 200, 50, v -> v.toString());
    addWidget(m_freqDD);
    m_freqDD.getOnSelectionChanged().addHandler(e -> {

      ListboxSelectedEntryChangedEventInfoType elistbox = (ListboxSelectedEntryChangedEventInfoType)e;
      m_histQuery = (QueryType)elistbox.data;

      if (m_histQuery == null)
      return;

      reloadFreq();
    }
    );

    m_freqDD.add(QueryType.DAY);
    // m_freqDD.add(QueryType.FLIGHT_NUMBER);
    m_freqDD.add(QueryType.CARRIER_CODE_INDEX);
    m_freqDD.add(QueryType.AIRPORT_ORIGIN_INDEX);
    m_freqDD.add(QueryType.AIRPORT_DEST_INDEX);
    m_freqDD.add(QueryType.CANCELLED_OR_DIVERTED);

    m_scatterDDX = new DropdownUI<QueryType>(20, 200, 300, 200, 50, v -> v.toString());
    addWidget(m_scatterDDX);
    m_scatterDDX.setRendering(false);
    m_scatterDDX.getOnSelectionChanged().addHandler(e -> {

      ListboxSelectedEntryChangedEventInfoType elistbox = (ListboxSelectedEntryChangedEventInfoType)e;
      m_scatterQueryX = (QueryType)elistbox.data;

      if (m_scatterQueryX == null)
      return;

      reloadScatter();
    }
    );

    m_scatterDDY = new DropdownUI<QueryType>(320, 200, 300, 200, 50, v -> v.toString());
    addWidget(m_scatterDDY);
    m_scatterDDY.setRendering(false);
    m_scatterDDY.getOnSelectionChanged().addHandler(e -> {

      ListboxSelectedEntryChangedEventInfoType elistbox = (ListboxSelectedEntryChangedEventInfoType)e;
      m_scatterQueryY = (QueryType)elistbox.data;

      if (m_scatterQueryY == null)
      return;

      reloadScatter();
    }
    );

    m_scatterDDX.add(QueryType.DAY);
    m_scatterDDX.add(QueryType.KILOMETRES_DISTANCE);
    m_scatterDDX.add(QueryType.DEPARTURE_TIME);
    m_scatterDDX.add(QueryType.SCHEDULED_DEPARTURE_TIME);
    m_scatterDDX.add(QueryType.DEPARTURE_DELAY);
    m_scatterDDX.add(QueryType.ARRIVAL_TIME);
    m_scatterDDX.add(QueryType.SCHEDULED_ARRIVAL_TIME);
    m_scatterDDX.add(QueryType.ARRIVAL_DELAY);

    m_scatterDDY.add(QueryType.DAY);
    m_scatterDDY.add(QueryType.KILOMETRES_DISTANCE);
    m_scatterDDY.add(QueryType.DEPARTURE_TIME);
    m_scatterDDY.add(QueryType.SCHEDULED_DEPARTURE_TIME);
    m_scatterDDY.add(QueryType.DEPARTURE_DELAY);
    m_scatterDDY.add(QueryType.ARRIVAL_TIME);
    m_scatterDDY.add(QueryType.SCHEDULED_ARRIVAL_TIME);
    m_scatterDDY.add(QueryType.ARRIVAL_DELAY);

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
  }

  public void reloadData() {
    if (m_cachedFlights == null)
      return;

    reloadFreq();
    reloadScatter();
  }

  public void reloadFreq() {
    m_histogram.removeData();
    m_histogram.addData(m_cachedFlights, f -> {
      return m_queryRef.getFlightTypeFieldFromQueryType((FlightType)f, m_histQuery);
    }
    );
    m_histogram.setXAxisLabel(m_histQuery.toString());
    m_histogram.setTranslationField(m_histQuery);

    m_pieChart.removeData();
    m_pieChart.addData(m_cachedFlights, f -> {
      return m_queryRef.getFlightTypeFieldFromQueryType((FlightType)f, m_histQuery);
    }
    );
    m_pieChart.setTranslationField(m_histQuery);
  }

  public void reloadScatter() {
    m_scatterPlot.removeData();
    m_scatterPlot.addData(m_cachedFlights,
      fX -> {
      return m_queryRef.getFlightTypeFieldFromQueryType((FlightType)fX, m_scatterQueryX);
    }
    ,
      fY -> {
      return m_queryRef.getFlightTypeFieldFromQueryType((FlightType)fY, m_scatterQueryY);
    }
    );
  }

  public void selectHistogram() {
    m_selectedGraph.setRendering(false);
    m_selectedGraph = m_histogram;
    m_selectedGraph.setRendering(true);
    
    m_freqDD.setRendering(true);
    m_scatterDDX.setRendering(false);
    m_scatterDDY.setRendering(false);
  }

  public void selectPieChart() {
    m_selectedGraph.setRendering(false);
    m_selectedGraph = m_pieChart;
    m_selectedGraph.setRendering(true);
    
    m_freqDD.setRendering(true);
    m_scatterDDX.setRendering(false);
    m_scatterDDY.setRendering(false);
  }

  public void selectScatterPlot() {
    m_selectedGraph.setRendering(false);
    m_selectedGraph = m_scatterPlot;
    m_selectedGraph.setRendering(true);
    
    m_freqDD.setRendering(false);
    m_scatterDDX.setRendering(true);
    m_scatterDDY.setRendering(true);
  } 
}
