/**
 * F. Wright
 *
 * Represents a screen for displaying charts.
 */
class ScreenCharts extends Screen {
  HistogramChartUI m_histogram;
  PieChartUI m_pieChart;
  ScatterChartUI m_scatterPlot;

  DropdownUI m_freqDD, m_scatterDDX, m_scatterDDY;
  LabelUI m_scatterLabelX, m_scatterLabelY;

  QueryManagerClass m_queryRef;
  UserQueryUI m_userQuery;
  FlightType[] m_cachedFlights = null;

  QueryType m_freqQueryType = null;
  QueryType m_scatterQueryTypeX = null;
  QueryType m_scatterQueryTypeY = null;

  Widget m_selectedGraph;

  private boolean m_initialised = false;

  /**
   * F. Wright
   *
   * Constructs a ScreenCharts object with the given screen ID and query manager.
   *
   * @param screenId The ID of the screen.
   * @param query    The query manager.
   */
  public ScreenCharts(String screenId, QueryManagerClass query, Consumer<FlightType[]> loadInto3D) {
    super(screenId, DEFAULT_SCREEN_COLOUR);

    m_queryRef = query;

    m_userQuery = new UserQueryUI(0, 0, 1, 1, m_queryRef, this);
    addWidget(m_userQuery);
    m_userQuery.setRenderWorldUSButtons(false);
    m_userQuery.setOnLoadHandler(flights -> {
      loadData(flights);
      if (m_initialised)
        reloadData();
    }
    );
    m_userQuery.setOnLoadOtherScreenHandler(loadInto3D);
    m_userQuery.setLoadOtherScreenText("Load into 3D");
  }

  /**
   * F. Wright
   *
   * Initializes the screen by adding UI elements and setting event handlers.
   */
  @Override
    public void init() {
    super.init();

    ButtonUI returnBttn = createButton(20, 50, 150, 40);
    returnBttn.getOnClickEvent().addHandler(e -> switchScreen(e, SCREEN_1_ID));
    returnBttn.setText("Return");
    returnBttn.setTextSize(20);
    returnBttn.setGrowScale(1.05f);

    ButtonUI switchTo3D = createButton(20, 100, 150, 40);
    switchTo3D.getOnClickEvent().addHandler(e -> switchScreen(e, SCREEN_FLIGHT_MAP_ID));
    switchTo3D.setText("3D");
    switchTo3D.setTextSize(20);
    switchTo3D.setGrowScale(1.05f);
    
    int chartScale = 850;
    int halfChartScale = (int)(chartScale * 0.5f);

    m_histogram = new HistogramChartUI<FlightType, Integer>(width/2 - halfChartScale, height/2 - halfChartScale, chartScale, chartScale);
    addWidget(m_histogram);
    m_selectedGraph = m_histogram;

    m_pieChart = new PieChartUI<FlightType, Integer>(width/2, height/2, 300);
    addWidget(m_pieChart);
    m_pieChart.setActive(false);

    m_scatterPlot = new ScatterChartUI<FlightType>(width/2 - halfChartScale, height/2 - halfChartScale, chartScale, chartScale);
    addWidget(m_scatterPlot);
    m_scatterPlot.setActive(false);

    m_freqDD = new DropdownUI<QueryType>(width-400, 200, 300, 200, 50, v -> v.toString());
    addWidget(m_freqDD);
    m_freqDD.getOnSelectionChanged().addHandler(e -> {

      ListboxSelectedEntryChangedEventInfoType elistbox = (ListboxSelectedEntryChangedEventInfoType)e;
      m_freqQueryType = (QueryType)elistbox.Data;

      if (m_freqQueryType == null || m_cachedFlights == null) {
        println("Flight data not ready for charts yet, or invalid query");
        return;
      }

      reloadFreq();
    }
    );

    m_freqDD.add(QueryType.DAY);
    m_freqDD.add(QueryType.CARRIER_CODE_INDEX);
    m_freqDD.add(QueryType.AIRPORT_ORIGIN_INDEX);
    m_freqDD.add(QueryType.AIRPORT_DEST_INDEX);
    m_freqDD.add(QueryType.CANCELLED);
    m_freqDD.add(QueryType.DIVERTED);

    m_scatterDDX = new DropdownUI<QueryType>(width-400, 200, 300, 200, 50, v -> v.toString());
    addWidget(m_scatterDDX);
    m_scatterDDX.setActive(false);
    m_scatterDDX.getOnSelectionChanged().addHandler(e -> {
      ListboxSelectedEntryChangedEventInfoType elistbox = (ListboxSelectedEntryChangedEventInfoType)e;
      m_scatterQueryTypeX = (QueryType)elistbox.Data;

      if (m_scatterQueryTypeX == null || m_scatterQueryTypeY == null)
      return;

      reloadScatter();
    }
    );

    m_scatterDDY = new DropdownUI<QueryType>(width-400, 600, 300, 200, 50, v -> v.toString());
    addWidget(m_scatterDDY);
    m_scatterDDY.setActive(false);
    m_scatterDDY.getOnSelectionChanged().addHandler(e -> {
      ListboxSelectedEntryChangedEventInfoType elistbox = (ListboxSelectedEntryChangedEventInfoType)e;
      m_scatterQueryTypeY = (QueryType)elistbox.Data;

      if (m_scatterQueryTypeX == null || m_scatterQueryTypeY == null || m_cachedFlights == null) {
        println("Flight data not ready for charts yet, or invalid query");
        return;
      }

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

    m_scatterLabelX = createLabel(width-400, 100, 300, 100, "X-axis");
    m_scatterLabelX.setTextSize(20);
    m_scatterLabelX.setActive(false);
    m_scatterLabelY = createLabel(width-400, 500, 300, 100, "Y-axis");
    m_scatterLabelY.setTextSize(20);
    m_scatterLabelY.setActive(false);

    RadioButtonGroupTypeUI group = new RadioButtonGroupTypeUI();
    addWidgetGroup(group);

    int iconScale = 70;
    int halfIconScale = (int)(iconScale * 0.5f);
    RadioButtonUI histRadio = new RadioImageButtonUI(width/3 - halfIconScale, 20, iconScale, iconScale, "Histogram", "data/Images/HistIcon.png", "data/Images/HistIconOff.png");
    histRadio.getOnCheckedEvent().addHandler(e -> selectHistogram());
    histRadio.setGrowScale(1.1f);
    group.addMember(histRadio);
    histRadio.setChecked(true);

    RadioButtonUI pieRadio = new RadioImageButtonUI(width/2 - halfIconScale, 20, iconScale, iconScale, "Pie", "data/Images/PieIcon.png", "data/Images/PieIconOff.png");
    pieRadio.getOnCheckedEvent().addHandler(e -> selectPieChart());
    pieRadio.setGrowScale(1.1f);
    group.addMember(pieRadio);

    RadioButtonUI scatterRadio = new RadioImageButtonUI(width/3 * 2 - halfIconScale, 20, iconScale, iconScale, "Scatter Plot", "data/Images/ScatterIconChunky.png", "data/Images/ScatterIconChunkyOff.png");
    scatterRadio.getOnCheckedEvent().addHandler(e -> selectScatterPlot());
    scatterRadio.setGrowScale(1.1f);
    group.addMember(scatterRadio);

    m_initialised = true;
  }

  /**
   * F. Wright
   *
   * Loads flight data into the screen for analysis.
   *
   * @param flights The array of flight data to load.
   */
  public void loadData(FlightType[] flights) {
    m_cachedFlights = flights;
  }

  /**
   * F. Wright
   *
   * Inserts base data for the user query
   *
   * @param flights Flight data for both the US and WORLD datasets
   */
  public void insertBaseData(FlightMultiDataType flights) {
    m_userQuery.insertBaseData(flights);
    loadData(flights.US);
  }

  /**
   * F. Wright
   *
   * Reloads the frequency data and scatter plot data using the cached flights.
   */
  public void reloadData() {
    if (m_cachedFlights == null)
      return;

    s_DebugProfiler.startProfileTimer();
    reloadFreq();
    reloadScatter();
    s_DebugProfiler.printTimeTakenMillis("Reloading data for charts");
  }

  /**
   * F. Wright
   *
   * Reloads the frequency data (histogram and pie chart) using the cached flights.
   */
  public void reloadFreq() {
    if (m_cachedFlights == null || m_freqQueryType == null)
      return;

    s_DebugProfiler.startProfileTimer();

    m_histogram.removeData();
    m_histogram.addData(m_cachedFlights, f -> {
      return m_queryRef.getFlightTypeFieldFromQueryType((FlightType)f, m_freqQueryType);
    }
    );
    m_histogram.setXAxisLabel(m_freqQueryType.toString());
    m_histogram.setTranslationField(m_freqQueryType, m_queryRef);

    m_pieChart.removeData();
    m_pieChart.addData(m_cachedFlights, f -> {
      return m_queryRef.getFlightTypeFieldFromQueryType((FlightType)f, m_freqQueryType);
    }
    );
    m_pieChart.setTranslationField(m_freqQueryType, m_queryRef);

    s_DebugProfiler.printTimeTakenMillis("Reloading data for frequency charts");
  }

  /**
   * F. Wright
   *
   * Reloads the scatter plot data using the cached flights.
   */
  public void reloadScatter() {
    if (m_cachedFlights == null || m_scatterQueryTypeX == null || m_scatterQueryTypeY == null)
      return;

    s_DebugProfiler.startProfileTimer();

    m_scatterPlot.removeData();
    m_scatterPlot.addData(m_cachedFlights,
      fX -> {
      return m_queryRef.getFlightTypeFieldFromQueryType((FlightType)fX, m_scatterQueryTypeX, true);
    }
    ,
      fY -> {
      return m_queryRef.getFlightTypeFieldFromQueryType((FlightType)fY, m_scatterQueryTypeY, true);
    }
    );
    m_scatterPlot.setAxisLabels(m_scatterQueryTypeX.toString(), m_scatterQueryTypeY.toString());

    s_DebugProfiler.printTimeTakenMillis("Reloading data for scatter chart");
  }

  /**
   * F. Wright
   *
   * Selects the histogram as the currently displayed graph.
   */
  public void selectHistogram() {
    m_selectedGraph.setActive(false);
    m_selectedGraph = m_histogram;
    m_selectedGraph.setActive(true);

    m_freqDD.setActive(true);
    m_scatterDDX.setActive(false);
    m_scatterDDY.setActive(false);
    m_scatterLabelX.setActive(false);
    m_scatterLabelY.setActive(false);
  }

  /**
   * F. Wright
   *
   * Selects the pie chart as the currently displayed graph.
   */
  public void selectPieChart() {
    m_selectedGraph.setActive(false);
    m_selectedGraph = m_pieChart;
    m_selectedGraph.setActive(true);

    m_freqDD.setActive(true);
    m_scatterDDX.setActive(false);
    m_scatterDDY.setActive(false);
    m_scatterLabelX.setActive(false);
    m_scatterLabelY.setActive(false);
  }

  /**
   * F. Wright
   *
   * Selects the scatter plot as the currently displayed graph.
   */
  public void selectScatterPlot() {
    m_selectedGraph.setActive(false);
    m_selectedGraph = m_scatterPlot;
    m_selectedGraph.setActive(true);

    m_freqDD.setActive(false);
    m_scatterDDX.setActive(true);
    m_scatterDDY.setActive(true);
    m_scatterLabelX.setActive(true);
    m_scatterLabelY.setActive(true);
  }
}

// Descending code authorship changes:
// F. Wright, Created screen charts and initialisation of Histogram, Pie and Scatter Charts, 5pm 19/03/24
