class TwoDMapScreen extends Screen {
  FlightMap2DUI m_flightMap;
  QueryManagerClass m_twodQueryManager;

  public TwoDMapScreen (String screenId, QueryManagerClass query) {
    super(screenId, DEFAULT_SCREEN_COLOUR);
    m_twodQueryManager = query;
  }

  @Override
    public void init() {
    super.init();
    int currentUIPosY = 20;
    int textSize = 20;

    m_flightMap = new FlightMap2DUI(100, 0, 100, 100);
    addWidget(m_flightMap);
 
    ButtonUI uiBackground = createButton(0, -1, 200, (displayHeight));
    uiBackground.setHighlightOutlineOnEnter(false);
    uiBackground.setBackgroundColour(color(DEFAULT_SCREEN_COLOUR));

    ButtonUI uiBackgroundTwo = createButton(0, (displayHeight-100), (displayWidth), (100));
    uiBackgroundTwo.setHighlightOutlineOnEnter(false);
    uiBackgroundTwo.setBackgroundColour(color(DEFAULT_SCREEN_COLOUR));

    ButtonUI returnBttn = createButton(20, currentUIPosY, 160, 50);
    returnBttn.getOnClickEvent().addHandler(e -> switchScreen(e, SCREEN_1_ID));

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

    CheckboxUI airportTextCB = createCheckbox(20, currentUIPosY, 50, 50, "Airports");
    airportTextCB.getOnClickEvent();
    airportTextCB.setGrowScale(1.05);
    airportTextCB.setChecked(true);
    airportTextCB.getLabel().setTextXOffset(0);
    airportTextCB.setTextSize(textSize);
    airportTextCB.getLabel().setCentreAligned(true);
    airportTextCB.getLabel().setScale(130, 50);
    currentUIPosY += 60;
  }
}
