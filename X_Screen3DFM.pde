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
  EmptyWidgetUI m_flightMapUIParent;
  UserQueryUI m_userQueryUI;
  FlightMultiDataType m_flights;
  
  private PVector m_offScreenUIPos = new PVector(-2000, 0);
  private boolean m_isQueryDisplayed = false;
  private float m_switchUIStartTimeMillis = 0;

  /**
   * F. Wright
   *
   * Constructs a new Screen3DFM object.
   *
   * @param screenId The ID of the screen.
   * @param query The QueryManagerClass instance.
   */
  public Screen3DFM(String screenId, QueryManagerClass query) {
    super(screenId, color(0, 0, 0, 255));

    m_queryManager = query;

    int dragWindowX = width - 400;
    int dragWindowY = height;
    m_flightMap3D = new FlightMap3D(200, 0, dragWindowX, dragWindowY);
    addWidget(m_flightMap3D);
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

    // ATTENTION MATTHEW, SEE HERE!
    m_userQueryUI = new UserQueryUI(0, 0, 1, 1, m_queryManager, this);
    m_userQueryUI.setPos(m_offScreenUIPos);
    addWidget(m_userQueryUI);

    m_userQueryUI.setOnLoadHandler(flights -> {
      m_flightMap3D.loadFlights(flights, m_queryManager);
    }
    );
    m_userQueryUI.insertBaseData(m_flights);

    m_flightMapUIParent = new EmptyWidgetUI(0, 0);
    int currentUIPosY = 60;
    int textSize = 20;

    ButtonUI returnBttn = createButton(20, currentUIPosY, 160, 50);
    returnBttn.getOnClickEvent().addHandler(e -> switchScreen(e, SCREEN_1_ID));
    returnBttn.setGrowScale(1.05);
    returnBttn.setText("Return");
    returnBttn.setTextSize(textSize);
    returnBttn.getLabel().setCentreAligned(true);

    currentUIPosY += 60;

    ButtonUI switchUIBttn = createButton(20, currentUIPosY, 160, 50);
    switchUIBttn.getOnClickEvent().addHandler(e -> switchUI());
    switchUIBttn.setGrowScale(1.05);
    switchUIBttn.setText("Switch");
    switchUIBttn.setTextSize(textSize);
    switchUIBttn.getLabel().setCentreAligned(true);

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

    ButtonUI resetArcGrow = createButton(20, currentUIPosY, 160, 50);
    resetArcGrow.getOnClickEvent().addHandler(e -> m_flightMap3D.setArcGrowMillis(10_000, 0));
    resetArcGrow.setGrowScale(1.05);
    resetArcGrow.setText("Reset Arcs");
    resetArcGrow.setTextSize(textSize);
    resetArcGrow.getLabel().setCentreAligned(true);
    resetArcGrow.setParent(m_flightMapUIParent);

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
  
  @Override
  public void draw(){
    super.draw();
    
    float frac = (millis() - m_switchUIStartTimeMillis) / SWITCH_SCREEN_DUR_3D;
    frac = clamp(frac, 0, 1);
    frac *= frac;
        
    PVector flightMapTargetPos = m_isQueryDisplayed ? m_offScreenUIPos : new PVector(0, 0);
    PVector newFlightMapPos = PVector.lerp(m_flightMapUIParent.getPos(), flightMapTargetPos, frac);
    m_flightMapUIParent.setPos(newFlightMapPos);
    
    PVector userQueryTargetPos = m_isQueryDisplayed ? new PVector(0, 0) : m_offScreenUIPos;
    PVector newUserQueryPos = PVector.lerp(m_userQueryUI.getPos(), userQueryTargetPos, frac);
    m_userQueryUI.setPos(newUserQueryPos);
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
