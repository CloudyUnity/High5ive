class TwoDMapScreen extends Screen {
  FlightMap2DUI m_flightMap;
  QueryManagerClass m_twodQueryManager;
  UserQueryUI m_userQueryUI;

  FlightMultiDataType m_flights;


  public TwoDMapScreen (String screenId, QueryManagerClass query) {
    super(screenId, DEFAULT_SCREEN_COLOUR);
    m_twodQueryManager = query;
  }

  @Override
    public void init() {
    super.init();
    int currentUIPosY = 20;
    int textSize = 20;

    m_userQueryUI = new UserQueryUI(0, 20, 1, 1, m_twodQueryManager, this);
    addWidget(m_userQueryUI);

    //  m_userQueryUI.setOnLoadHandler(flights -> {
    //   m_flightMap.loadFlights(flights, m_twodQueryManager);
    //  }
    //  );
    //  m_userQueryUI.insertBaseData(m_flights);


    m_flightMap = new FlightMap2DUI(0, 0, 100, 100);
    addWidget(m_flightMap);

    LabelUI label = createLabel(20, currentUIPosY, 150, 40, "2D Flight Map");
    label.setForegroundColour(color(255, 255, 255, 255));
    label.setTextSize(30);
    currentUIPosY += 60;

    ButtonUI returnBttn = createButton(20, currentUIPosY, 160, 50);
    returnBttn.getOnClickEvent().addHandler(e -> switchScreen(e, SCREEN_ID_HOME));
    returnBttn.setBackgroundColour(color(COLOR_BACKGROUND));
    returnBttn.setText("Return");
    returnBttn.setTextSize(textSize);
    returnBttn.getLabel().setCentreAligned(true);
    currentUIPosY += 60;

    ButtonUI resetArcGrow = createButton(20, currentUIPosY, 160, 50);
    resetArcGrow.getOnClickEvent();
    resetArcGrow.setGrowScale(1.05);
    resetArcGrow.setText("Reset Arcs");
    resetArcGrow.setTextSize(textSize);
    resetArcGrow.getLabel().setCentreAligned(true);
    currentUIPosY += 60;

    CheckboxUI connectionsEnabledCB = createCheckbox(20, currentUIPosY, 50, 50, "Connections");
    connectionsEnabledCB.getOnClickEvent();
    connectionsEnabledCB.setGrowScale(1.05);
    connectionsEnabledCB.setChecked(true);
    connectionsEnabledCB.getLabel().setTextXOffset(0);
    connectionsEnabledCB.setTextSize(textSize);
    connectionsEnabledCB.getLabel().setCentreAligned(true);
    connectionsEnabledCB.getLabel().setScale(130, 50);
    currentUIPosY += 60;

    CheckboxUI markersEnabledCB = createCheckbox(20, currentUIPosY, 50, 50, "Markers");
    markersEnabledCB.getOnClickEvent();
    markersEnabledCB.setGrowScale(1.05);
    markersEnabledCB.setChecked(true);
    markersEnabledCB.getLabel().setTextXOffset(0);
    markersEnabledCB.setTextSize(textSize);
    markersEnabledCB.getLabel().setCentreAligned(true);
    markersEnabledCB.getLabel().setScale(130, 50);
    currentUIPosY += 60;
  }

  /**
   * M. Orlowski
   *
   * Inserts flight data into the screen from M_Application class.
   *
   * @param flights The flight data to be inserted.
   */
  public void insertFlightData(FlightMultiDataType flights) {
    m_flights  = flights;
  }
}
