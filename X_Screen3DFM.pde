/**
 * F. Wright
 *
 * Screen for the 3D flight map
 *
 * @extends Screen
 */
class Screen3DFM extends Screen {
  FlightMap3D m_flightMap3D;
  QueryManagerClass m_queryManager;
  EmptyWidgetUI m_flightMapUIParent = new EmptyWidgetUI(0, 0), m_worldUSUIParent = new EmptyWidgetUI(0, -300);
  UserQueryUI m_userQueryUI;
  FlightMultiDataType m_flights;

  private boolean m_isQueryDisplayed = false;
  private float m_switchUIStartTimeMillis = 0;

  private Consumer<FlightType[]> m_loadIntoChartsConsumer;

  /**
   * F. Wright
   *
   * Constructs a new Screen3DFM object.
   *
   * @param screenId The ID of the screen.
   * @param query The QueryManagerClass instance.
   */
  public Screen3DFM(String screenId, QueryManagerClass query, Consumer<FlightType[]> loadIntoCharts) {
    super(screenId, color(0, 0, 0, 255));

    m_queryManager = query;
    m_loadIntoChartsConsumer = loadIntoCharts;

    int dragWindowX = width - 400;
    int dragWindowY = height;
    m_flightMap3D = new FlightMap3D(200, 0, dragWindowX, dragWindowY);
    addWidget(m_flightMap3D, -9999);
  }

  /**
   * F. Wright
   *
   * Initializes the screen.
   * Overrides the init method of the parent class (Screen).
   */
  @Override
    public void init() {
    super.init();

    m_userQueryUI = new UserQueryUI(-2000, UQUI_3D_POS_Y, 1, 1, m_queryManager, this);
    addWidget(m_userQueryUI, 100);
    m_userQueryUI.setWorldUSParent(m_worldUSUIParent);
    m_userQueryUI.setOnLoadHandler(flights -> {
      m_flightMap3D.loadFlights(flights, m_queryManager);
    }
    );
    m_userQueryUI.insertBaseData(m_flights);
    m_userQueryUI.setLoadOtherScreenText("Load into Charts");
    m_userQueryUI.setOnLoadOtherScreenHandler(m_loadIntoChartsConsumer);

    int currentUIPosY = 60;
    int textSize = 20;

    ButtonUI returnBttn = createButton(20, currentUIPosY, 160, 50);
    returnBttn.getOnClickEvent().addHandler(e -> switchScreen(e, SCREEN_1_ID));
    returnBttn.setGrowScale(1.05);
    returnBttn.setText("Return");
    returnBttn.setTextSize(textSize);
    returnBttn.getLabel().setCentreAligned(true);

    currentUIPosY += 60;

    ButtonUI switchToCharts = createButton(20, currentUIPosY, 160, 50);
    switchToCharts.getOnClickEvent().addHandler(e -> switchScreen(e, SCREEN_CHARTS_ID));
    returnBttn.setGrowScale(1.05);
    switchToCharts.setText("Charts");
    switchToCharts.setTextSize(textSize);
    switchToCharts.getLabel().setCentreAligned(true);

    currentUIPosY += 60;

    ButtonUI switchUIBttn = createButton(20, currentUIPosY, 160, 50);
    switchUIBttn.getOnClickEvent().addHandler(e -> switchUI());
    switchUIBttn.setGrowScale(1.05);
    switchUIBttn.setText("Switch");
    switchUIBttn.setTextSize(textSize);
    switchUIBttn.getLabel().setCentreAligned(true);

    currentUIPosY += 60;

    ButtonUI resetArcGrow = createButton(20, currentUIPosY, 160, 50);
    resetArcGrow.getOnClickEvent().addHandler(e -> m_flightMap3D.setArcGrowMillis(10_000, 0));
    resetArcGrow.setGrowScale(1.05);
    resetArcGrow.setText("Reset Arcs");
    resetArcGrow.setTextSize(textSize);
    resetArcGrow.getLabel().setCentreAligned(true);
    resetArcGrow.setParent(m_flightMapUIParent);

    currentUIPosY += 60;

    CheckboxUI dayNightCB = createCheckbox(20, currentUIPosY, 50, 50, "Perma-Day");
    dayNightCB.setGrowScale(1.05);
    dayNightCB.getOnClickEvent().addHandler(e -> m_flightMap3D.setPermaDay(dayNightCB.getChecked()));
    dayNightCB.getLabel().setTextXOffset(0);
    dayNightCB.setTextSize(textSize);
    dayNightCB.getLabel().setCentreAligned(true);
    dayNightCB.getLabel().setScale(130, 50);
    dayNightCB.getLabel().setParent(m_flightMapUIParent);
    dayNightCB.setParent(m_flightMapUIParent);

    currentUIPosY += 60;

    CheckboxUI connectionsEnabledCB = createCheckbox(20, currentUIPosY, 50, 50, "Connections");
    connectionsEnabledCB.getOnClickEvent().addHandler(e -> m_flightMap3D.setConnectionsEnabled(connectionsEnabledCB.getChecked()));
    connectionsEnabledCB.setGrowScale(1.05);
    connectionsEnabledCB.setChecked(true);
    connectionsEnabledCB.getLabel().setTextXOffset(0);
    connectionsEnabledCB.setTextSize(textSize);
    connectionsEnabledCB.getLabel().setCentreAligned(true);
    connectionsEnabledCB.getLabel().setScale(130, 50);
    connectionsEnabledCB.getLabel().setParent(m_flightMapUIParent);
    connectionsEnabledCB.setParent(m_flightMapUIParent);

    currentUIPosY += 60;

    CheckboxUI markersEnabledCB = createCheckbox(20, currentUIPosY, 50, 50, "Markers");
    markersEnabledCB.getOnClickEvent().addHandler(e -> m_flightMap3D.setMarkersEnabled(markersEnabledCB.getChecked()));
    markersEnabledCB.setGrowScale(1.05);
    markersEnabledCB.setChecked(true);
    markersEnabledCB.getLabel().setTextXOffset(0);
    markersEnabledCB.setTextSize(textSize);
    markersEnabledCB.getLabel().setCentreAligned(true);
    markersEnabledCB.getLabel().setScale(130, 50);
    markersEnabledCB.getLabel().setParent(m_flightMapUIParent);
    markersEnabledCB.setParent(m_flightMapUIParent);

    currentUIPosY += 60;

    CheckboxUI airportTextCB = createCheckbox(20, currentUIPosY, 50, 50, "Text");
    airportTextCB.getOnClickEvent().addHandler(e -> m_flightMap3D.setTextEnabled(airportTextCB.getChecked()));
    airportTextCB.setGrowScale(1.05);
    airportTextCB.setChecked(true);
    airportTextCB.getLabel().setTextXOffset(0);
    airportTextCB.setTextSize(textSize);
    airportTextCB.getLabel().setCentreAligned(true);
    airportTextCB.getLabel().setScale(130, 50);
    airportTextCB.getLabel().setParent(m_flightMapUIParent);
    airportTextCB.setParent(m_flightMapUIParent);

    currentUIPosY += 60;

    CheckboxUI lockTimeCB = createCheckbox(20, currentUIPosY, 50, 50, "Lock Time");
    lockTimeCB.getOnClickEvent().addHandler(e -> m_flightMap3D.setLockTime(lockTimeCB.getChecked()));
    lockTimeCB.setGrowScale(1.05);
    lockTimeCB.setChecked(false);
    lockTimeCB.getLabel().setTextXOffset(0);
    lockTimeCB.setTextSize(textSize);
    lockTimeCB.getLabel().setCentreAligned(true);
    lockTimeCB.getLabel().setScale(130, 50);
    lockTimeCB.getLabel().setParent(m_flightMapUIParent);
    lockTimeCB.setParent(m_flightMapUIParent);

    currentUIPosY += 60;

    CheckboxUI ditheringCB = createCheckbox(20, currentUIPosY, 50, 50, "Dithering");
    ditheringCB.getOnClickEvent().addHandler(e -> m_flightMap3D.setDitheringEnabled(ditheringCB.getChecked()));
    ditheringCB.setGrowScale(1.05);
    ditheringCB.setChecked(false);
    ditheringCB.getLabel().setTextXOffset(0);
    ditheringCB.setTextSize(textSize);
    ditheringCB.getLabel().setCentreAligned(true);
    ditheringCB.getLabel().setScale(130, 50);
    ditheringCB.getLabel().setParent(m_flightMapUIParent);
    ditheringCB.setParent(m_flightMapUIParent);

    currentUIPosY += 60;

    CheckboxUI crtCB = createCheckbox(20, currentUIPosY, 50, 50, "CRT");
    crtCB.getOnClickEvent().addHandler(e -> m_flightMap3D.setCRTEnabled(crtCB.getChecked()));
    crtCB.setGrowScale(1.05);
    crtCB.setChecked(false);
    crtCB.getLabel().setTextXOffset(0);
    crtCB.setTextSize(textSize);
    crtCB.getLabel().setCentreAligned(true);
    crtCB.getLabel().setScale(130, 50);
    crtCB.getLabel().setParent(m_flightMapUIParent);
    crtCB.setParent(m_flightMapUIParent);

    currentUIPosY += 60;

    SliderUI dayCycleSlider = createSlider(20, currentUIPosY, 160, 50, 0.00005f, 0.005f, 0.00001f);
    dayCycleSlider.getOnDraggedEvent().addHandler(e -> m_flightMap3D.setDayCycleSpeed((float)dayCycleSlider.getValue()));
    dayCycleSlider.setParent(m_flightMapUIParent);

    LabelUI sliderLabel = createLabel(20, currentUIPosY, 160, 50, "Time Speed");
    sliderLabel.setTextSize(15);
    sliderLabel.setCentreAligned(true);
    sliderLabel.setParent(m_flightMapUIParent);

    currentUIPosY += 60;

    LabelUI label = createLabel(20, 10, 150, 40, "3D Flight Map");
    label.setForegroundColour(color(255, 255, 255, 255));
    label.setTextSize(30);
  }

  /**
   * F. Wright
   *
   * Inserts flight data into the screen.
   *
   * @param flights The flight data to be inserted.
   */
  public void insertFlightData(FlightMultiDataType flights) {
    m_flights  = flights;
  }

  public void loadFlights(FlightType[] flights) {
    m_flightMap3D.loadFlights(flights, m_queryManager);
  }

  @Override
    public void draw() {
    super.draw();

    float frac = (millis() - m_switchUIStartTimeMillis) / SWITCH_SCREEN_DUR_3D;
    frac = clamp(frac, 0, 1);
    frac *= frac;

    PVector flightMapTargetPos = m_isQueryDisplayed ? new PVector(-2000, 0) : new PVector(0, 0);
    PVector newFlightMapPos = PVector.lerp(m_flightMapUIParent.getPos(), flightMapTargetPos, frac);
    m_flightMapUIParent.setPos(newFlightMapPos);

    PVector userQueryTargetPos = m_isQueryDisplayed ? new PVector(0, UQUI_3D_POS_Y) : new PVector(-2000, UQUI_3D_POS_Y);
    PVector newUserQueryPos = PVector.lerp(m_userQueryUI.getPos(), userQueryTargetPos, frac);
    m_userQueryUI.setPos(newUserQueryPos);

    PVector worldUSTargetPos = m_isQueryDisplayed ? new PVector(0, 0) : new PVector(0, -300);
    PVector newWorldUSPos = PVector.lerp(m_worldUSUIParent.getPos(), worldUSTargetPos, frac);
    m_worldUSUIParent.setPos(newWorldUSPos);
  }

  /**
   * M. Poole, F. Wright
   *
   * Switches between the flight map and the user query UI.
   * If the query UI is not displayed, it will be shown, and vice versa.
   */
  private void switchUI() {
    m_isQueryDisplayed = !m_isQueryDisplayed;
    m_switchUIStartTimeMillis = millis();
  }
}

// Descending code authorship changes:
// F. Wright, Moved this screen here from X_ScreenPresets, 9am 19/03/24
