class Screen1 extends Screen {
  public Screen1(int scaleX, int scaleY, String screenId) {
    super(scaleX, scaleY, screenId, DEFAULT_SCREEN_COLOUR);

    /* ButtonUI redBtn = createButton(50, 50, 200, 100);
     redBtn.getOnClickEvent().addHandler(e -> redButtonOnClick(e));
     redBtn.setText("Red");
     redBtn.setTextSize(30);
     redBtn.setGrowMode(true);
     
     ButtonUI greenBtn = createButton(50, 200, 200, 100);
     greenBtn.getOnClickEvent().addHandler(e -> greenButtonOnClick(e));
     greenBtn.setText("Green");
     greenBtn.setTextSize(30);
     greenBtn.setGrowMode(true);
     
     ButtonUI blueBtn = createButton(50, 350, 200, 100);
     blueBtn.getOnClickEvent().addHandler(e -> blueButtonOnClick(e));
     blueBtn.setText("Blue");
     blueBtn.setTextSize(30);
     blueBtn.setGrowMode(true);*/

    ButtonUI switchToTextboxDemo = createButton(20, 170, 250, 100);
    switchToTextboxDemo.getOnClickEvent().addHandler(e -> switchToTextBoxDemoOnClick(e));
    switchToTextboxDemo.setText("Alex testing");
    switchToTextboxDemo.setTextSize(30);
    switchToTextboxDemo.setGrowMode(true);

    ButtonUI switchToScreen2Btn = createButton(20, 320, 250, 100);
    switchToScreen2Btn.getOnClickEvent().addHandler(e -> switchScreen(e, SCREEN_2_ID));
    switchToScreen2Btn.setText("Screen 2");
    switchToScreen2Btn.setTextSize(25);
    switchToScreen2Btn.setGrowMode(true);

    ButtonUI switchToDemo = createButton(20, 470, 250, 100);
    switchToDemo.getOnClickEvent().addHandler(e -> switchScreen(e, SWITCH_TO_DEMO_ID));
    switchToDemo.setText("Barchart demo");
    switchToDemo.setTextSize(25);
    switchToDemo.setGrowMode(true);

    ButtonUI switchTo2D = createButton(20, 20, 100, 100);
    switchTo2D.getOnClickEvent().addHandler(e -> switchScreen(e, SCREEN_TWOD_MAP_ID));
    switchTo2D.setText("2D (WIP)");
    switchTo2D.setTextSize(25);
    switchTo2D.setGrowMode(true);

    ButtonUI switchTo3D = createButton(170, 20, 100, 100);
    switchTo3D.getOnClickEvent().addHandler(e -> switchScreen(e, SCREEN_FLIGHT_MAP_ID));
    switchTo3D.setText("3D (WIP)");
    switchTo3D.setTextSize(25);
    switchTo3D.setGrowMode(true);

    /*  CheckboxUI cb = createCheckbox(400, 500, 200, 50, "My checkbox");
     cb.setCheckedColour(color(255, 255, 0, 255));
     cb.setGrowMode(true);*/
  }

  private void switchToTextBoxDemoOnClick(EventInfoType e) {
    switchScreen(e, ALEX_TESTING_ID);
  }

  /* private void redButtonOnClick(EventInfoType e) {
   ButtonUI btn = (ButtonUI)e.Widget;
   if (btn.getBackgroundColour() == color(#FF0000))
   btn.setBackgroundColour(DEFAULT_BACKGROUND_COLOUR);
   else
   btn.setBackgroundColour(#FF0000);
   }
   
   private void greenButtonOnClick(EventInfoType e) {
   ButtonUI btn = (ButtonUI)e.Widget;
   if (btn.getBackgroundColour() == color(#00FF00))
   btn.setBackgroundColour(DEFAULT_BACKGROUND_COLOUR);
   else
   btn.setBackgroundColour(#00FF00);
   }
   
   private void blueButtonOnClick(EventInfoType e) {
   ButtonUI btn = (ButtonUI)e.Widget;
   if (btn.getBackgroundColour() == color(#0000FF))
   btn.setBackgroundColour(DEFAULT_BACKGROUND_COLOUR);
   else
   btn.setBackgroundColour(#0000FF);
   }*/
}

class Screen2 extends Screen {
  private BarChartUI m_barChart;
  private ArrayList<String> m_data;

  public Screen2(int scaleX, int scaleY, String screenId) {
    super(scaleX, scaleY, screenId, DEFAULT_SCREEN_COLOUR);

    ButtonUI switchToScreen1Btn = createButton(width / 2 - 50, height / 2 - 50, 100, 100);
    switchToScreen1Btn.getOnMouseEnterEvent().addHandler(e -> changeOutlineColourOnEnter(e));
    switchToScreen1Btn.getOnMouseExitEvent().addHandler(e -> changeOutlineColourOnExit(e));
    switchToScreen1Btn.getOnClickEvent().addHandler(e -> switchScreen(e, SCREEN_1_ID));
    switchToScreen1Btn.setText("Screen 1");
    switchToScreen1Btn.setTextSize(25);

    RadioButtonGroupTypeUI group = new RadioButtonGroupTypeUI();
    addWidgetGroup(group);

    RadioButtonUI rb1 = new RadioButtonUI(100, 100, 100, 20, "Show data");
    rb1.getOnCheckedEvent().addHandler(e -> onCheckedRb1());
    rb1.setGrowMode(true);
    group.addMember(rb1);

    RadioButtonUI rb2 = new RadioButtonUI(100, 200, 100, 20, "Don't show data");
    rb2.getOnCheckedEvent().addHandler(e -> onCheckedRb2());
    rb2.setGrowMode(true);
    group.addMember(rb2);

    ImageUI i1 = new ImageUI(50, 50, 300, 300);
    addWidget(i1);

    createSlider(100, 400, 300, 50, 0, 100, 1);

    createLabel(10, 10, 100, 100, "Hello");

    m_barChart = new BarChartUI(200, 10, 200, 200);
    m_barChart.setTitle("Numbers");
    m_data = new ArrayList<String>();
    m_data.add("1");
    m_data.add("1");
    m_data.add("1");
    m_data.add("1");
    m_data.add("1");
    m_data.add("1");
    m_data.add("1");
    m_data.add("1");
    m_data.add("1");
    m_data.add("1");
    m_data.add("2");
    m_data.add("1");
    m_data.add("3");
    m_data.add("3");
    m_data.add("6");

    addWidget(m_barChart);

    rb1.check();
  }

  private void changeOutlineColourOnExit(EventInfoType e) {
    e.Widget.setOutlineColour(color(#000000));
  }

  private void changeOutlineColourOnEnter(EventInfoType e) {
    e.Widget.setOutlineColour(color(#FFFFFF));
  }

  private void onCheckedRb1() {
    m_barChart.addData(m_data, v -> v);
  }

  private void onCheckedRb2() {
    m_barChart.removeData();
  }
}

class FlightCodesBarchartDemo extends Screen {
  private BarChartUI<FlightType> chart;
  private ArrayList<FlightType> data;

  public FlightCodesBarchartDemo(int scaleX, int scaleY, String screenId) {
    super(scaleX, scaleY, screenId, color(150, 150, 150, 255));

    ButtonUI returnBtn = new ButtonUI(20, 20, 50, 50);
    returnBtn.setText("<-");
    returnBtn.setTextSize(25);
    returnBtn.getOnClickEvent().addHandler(e -> switchScreen(e, SCREEN_1_ID));
    addWidget(returnBtn);

    data = new ArrayList<FlightType>();
    FlightType ft1 = new FlightType();
    ft1.AirportOriginIndex = 1;
    ft1.AirportDestIndex = 20;
    FlightType ft2 = new FlightType();
    ft2.AirportOriginIndex = 2;
    ft2.AirportDestIndex = 32;
    FlightType ft3 = new FlightType();
    ft3.AirportOriginIndex = 1;
    ft3.AirportDestIndex = 19;
    data.add(ft1);
    data.add(ft2);
    data.add(ft3);

    chart = new BarChartUI<FlightType>(100, 100, (int)m_scale.x - 200, (int)m_scale.y - 200);
    addWidget(chart);

    RadioButtonUI destination = new RadioButtonUI( 100, (int)m_scale.y - 80, 200, 20, "Destination");
    RadioButtonUI origin = new RadioButtonUI(400, (int)m_scale.y - 80, 200, 20, "Origin");
    destination.setTextSize(20);
    origin.setTextSize(20);

    destination.getOnClickEvent().addHandler(e -> onDestinationClicked(e));
    origin.getOnClickEvent().addHandler(e -> onOriginClicked(e));

    RadioButtonGroupTypeUI group = new RadioButtonGroupTypeUI();
    group.addMember(destination);
    group.addMember(origin);
    addWidgetGroup(group);

    destination.check();
  }

  private void onOriginClicked(EventInfoType e) {
    if (chart != null && data != null) {
      chart.removeData();
      // When conversion from index to code is implemented use that.
      chart.addData(data, v -> Short.toString(v.AirportOriginIndex));
      chart.setTitle("Flight origin indicies");
    }
  }

  private void onDestinationClicked(EventInfoType e) {
    if (chart != null && data != null) {
      chart.removeData();
      // When conversion from index to code is implemented use that.
      chart.addData(data, v -> Short.toString(v.AirportDestIndex));
      chart.setTitle("Flight destination indicies");
    }
  }
}

class TwoDMapScreen extends Screen {
  FlightMap2DUI m_flightMap;
  QueryManagerClass m_twodQueryManager;

  public TwoDMapScreen (int scaleX, int scaleY, String screenId, QueryManagerClass query) {
    super(scaleX, scaleY, screenId, DEFAULT_SCREEN_COLOUR);

    m_twodQueryManager = query;
    int currentUIPosY = 20;
    int textSize = 20;

    m_flightMap = new FlightMap2DUI(100, 0, 100, 100);
    addWidget(m_flightMap);

    ButtonUI uiBackground = createButton(0, -1, 200, (displayHeight));
    uiBackground.setHighlightOutlineOnEnter(false);
    uiBackground.setBackgroundColour(color(DEFAULT_SCREEN_COLOUR));

    ButtonUI uiBackgroundTwo = createButton(0, (displayHeight-100), (displayWidth), (99));
    uiBackgroundTwo.setHighlightOutlineOnEnter(false);
    uiBackgroundTwo.setBackgroundColour(color(DEFAULT_SCREEN_COLOUR));

    ButtonUI returnBttn = createButton(20, currentUIPosY, 160, 50);
    returnBttn.getOnClickEvent().addHandler(e -> switchScreen(e, SCREEN_1_ID));
    returnBttn.setGrowMode(true);
    returnBttn.setText("Return");
    returnBttn.setTextSize(textSize);
    returnBttn.getLabel().setCentreAligned(true);

    currentUIPosY += 60;
  }
}

class ScreenFlightMap extends Screen {
  FlightMap3D m_flightMap3D;
  QueryManagerClass m_queryManager;
  EmptyWidgetUI m_flightMapUIParent;

  public ScreenFlightMap(int scaleX, int scaleY, String screenId, QueryManagerClass query) {
    super(scaleX, scaleY, screenId, color(0, 0, 0, 255));

    m_queryManager = query;

    int dragWindowX = width - 400;
    int dragWindowY = height;
    m_flightMap3D = new FlightMap3D(200, 0, dragWindowX, dragWindowY);
    addWidget(m_flightMap3D);

    // ATTENTION MATTHEW, SEE HERE!
    UserQueryUI userQueryUI = new UserQueryUI(0, 60, 1, 1, query);
    addWidget(userQueryUI);
    userQueryUI.setOnLoadHandler(flights -> {
      m_flightMap3D.loadFlights(flights, query);
    }
    );

    m_flightMapUIParent = new EmptyWidgetUI(0, 0);
    int currentUIPosY = 60;
    int textSize = 20;

    ButtonUI uiBackground = createButton(0, 0, 200, 00);
    uiBackground.setHighlightOutlineOnEnter(false);
    uiBackground.setBackgroundColour(color(DEFAULT_SCREEN_COLOUR));

    ButtonUI returnBttn = createButton(20, currentUIPosY, 160, 50);
    returnBttn.getOnClickEvent().addHandler(e -> switchScreen(e, SCREEN_1_ID));
    returnBttn.setGrowMode(true);
    returnBttn.setText("Return");
    returnBttn.setTextSize(textSize);
    returnBttn.getLabel().setCentreAligned(true);
    returnBttn.setParent(m_flightMapUIParent);

    currentUIPosY += 60;

    CheckboxUI dayNightCB = createCheckbox(20, currentUIPosY, 50, 50, "Perma-Day");
    dayNightCB.setGrowMode(true);
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
    connectionsEnabledCB.setGrowMode(true);
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
    markersEnabledCB.setGrowMode(true);
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
    airportTextCB.setGrowMode(true);
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
    lockTimeCB.setGrowMode(true);
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
    resetArcGrow.setGrowMode(true);
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
    label.setParent(m_flightMapUIParent);   

    /* TextboxUI airportOriginSearch = new TextboxUI(20, currentUIPosY, 160, 30);
     airportOriginSearch.setPlaceholderText("Origin");
     addWidget(airportOriginSearch);
     
     currentUIPosY += 40;
     
     TextboxUI airportDestSearch = new TextboxUI(20, currentUIPosY, 160, 30);
     airportDestSearch.setPlaceholderText("Origin");
     addWidget(airportDestSearch);
     
     currentUIPosY += 40;
     
     TextboxUI airlineSearch = new TextboxUI(20, currentUIPosY, 160, 30);
     airlineSearch.setPlaceholderText("Origin");
     addWidget(airlineSearch);
     
     currentUIPosY += 40;
     
     TextboxUI DateSearch = new TextboxUI(20, currentUIPosY, 160, 30);
     DateSearch.setPlaceholderText("Origin");
     addWidget(DateSearch);
     
     currentUIPosY += 40;
     
     TextboxUI DepartBeforeSearch = new TextboxUI(20, currentUIPosY, 160, 30);
     DepartBeforeSearch.setPlaceholderText("Origin");
     addWidget(DepartBeforeSearch);
     
     currentUIPosY += 40;
     
     TextboxUI DepartAfterSearch = new TextboxUI(20, currentUIPosY, 160, 30);
     DepartAfterSearch.setPlaceholderText("Origin");
     addWidget(DepartAfterSearch);
     
     currentUIPosY += 40;
     
     TextboxUI DistanceAboveSearch = new TextboxUI(20, currentUIPosY, 160, 30);
     DistanceAboveSearch.setPlaceholderText("Origin");
     addWidget(DistanceAboveSearch);
     
     currentUIPosY += 40;
     
     TextboxUI DepartDelayUnderSearch = new TextboxUI(20, currentUIPosY, 160, 30);
     DepartDelayUnderSearch.setPlaceholderText("Origin");
     addWidget(DepartDelayUnderSearch);
     
     currentUIPosY += 40;
     
     TextboxUI DepartDelayOverSearch = new TextboxUI(20, currentUIPosY, 160, 30);
     DepartDelayOverSearch.setPlaceholderText("Origin");
     addWidget(DepartDelayOverSearch);
     
     currentUIPosY += 40;
     
     TextboxUI ArriveBeforeSearch = new TextboxUI(20, currentUIPosY, 160, 30);
     ArriveBeforeSearch.setPlaceholderText("Origin");
     addWidget(ArriveBeforeSearch );
     
     currentUIPosY += 40;
     
     TextboxUI ArriveAfterSearch = new TextboxUI(20, currentUIPosY, 160, 30);
     ArriveAfterSearch.setPlaceholderText("Origin");
     addWidget(ArriveAfterSearch);
     
     currentUIPosY += 40;
     
     TextboxUI ArrivalDelayUnderSearch = new TextboxUI(20, currentUIPosY, 160, 30);
     ArrivalDelayUnderSearch.setPlaceholderText("Origin");
     addWidget(ArrivalDelayUnderSearch);
     
     currentUIPosY += 40;
     
     TextboxUI ArrivalDelayOverSearch = new TextboxUI(20, currentUIPosY, 160, 30);
     ArrivalDelayOverSearch.setPlaceholderText("Origin");
     addWidget(ArrivalDelayOverSearch);*/
  }

  public void startLoadingData(FlightType[] flights) {
    m_flightMap3D.loadFlights(flights, m_queryManager);
  }
  
  @Override
  public void draw(){
    super.draw();
    
    // Use this to test widget parenting. See how all the UI elements belonging to m_flightMapUIParent now use relative positions and scales to its position
    // m_flightMapUIParent.setPos(mouseX, 0); 
  }
}

class AlexTestingScreen extends Screen {
  private TextboxUI box;
  private ListboxUI<String> list;
  private ButtonUI clearListButton;
  private ButtonUI removeSelectedButton;
  private ButtonUI addItemButton;
  private DropdownUI<String> testDropdown;
  private ImageUI imageBox;
  private int counter = 0;

  public AlexTestingScreen(int scaleX, int scaleY, String screenId) {
    super(scaleX, scaleY, screenId, color(220, 220, 220, 255));
    box = new TextboxUI(50, 70, 200, 50);
    list = new ListboxUI<String>(50, 170, 200, 400, 40, v -> v);
    imageBox = new ImageUI(400, 50, 60, 60);

    addItemButton = createButton(300, 50, 80, 20);
    addItemButton.setText("Add item");
    addItemButton.getOnClickEvent().addHandler(e -> addItemOnClick(e));

    clearListButton = createButton(300, 90, 80, 20);
    clearListButton.setText("Clear");
    clearListButton.getOnClickEvent().addHandler(e -> clearListOnClick(e));

    removeSelectedButton = createButton(300, 130, 80, 20);
    removeSelectedButton.setText("Remove selected");
    removeSelectedButton.getOnClickEvent().addHandler(e -> list.removeSelected());

    testDropdown = new DropdownUI<String>(400, 90, 200, 400, 30, v -> v);
    testDropdown.add("One");
    testDropdown.add("Two");
    testDropdown.add("Three");
    testDropdown.add("One");
    testDropdown.add("Two");
    testDropdown.add("Three");
    testDropdown.add("One");
    testDropdown.add("Two");
    testDropdown.add("Three");
    testDropdown.add("One");
    testDropdown.add("Two");
    testDropdown.add("Three");
    testDropdown.add("One");
    testDropdown.add("Two");
    testDropdown.add("Three");

    addWidget(box);
    addWidget(list);
    addWidget(testDropdown);
    addWidget(imageBox);


    ButtonUI returnBttn = createButton(20, displayHeight - 60, 160, 50);

    returnBttn.getOnClickEvent().addHandler(e -> switchScreen(e, SCREEN_1_ID));
    returnBttn.setGrowMode(true);
    returnBttn.setText("<-");
    returnBttn.setTextSize(20);
    returnBttn.getLabel().setCentreAligned(true);
  }

  private void addItemOnClick(EventInfoType e) {
    list.add("" + counter);
    counter++;
  }

  private void clearListOnClick(EventInfoType e) {
    list.clear();
  }
}

// Descending code authorship changes:
// A. Robertson, Wrote Screen1 and Screen2 presets
// F. Wright, Modified and simplified code to fit coding standard. Fixed checkbox issues with colours, 6pm 04/03/24
// F. Wright, Refactored screen, presets and applied grow mode to relevant widgets, 1pm 07/03/24
// F. Wright, Created 3D flight map screen using OpenGL GLSL shaders and P3D features. Implemented light shading and day-night cycle, 9pm 07/03/24
// M. Orlowski, Worked on 2D Map Button, 1pm 12/03/2024
// CKM, reintroduced some code that was overwritten, 14:00 12/03
// CKM, implemented spin control for 3D map, 10:00 13/03
// M. Orlowski, Added 2D calls, 12:00 13/03
// M. Poole added TextBoxes and removed background 5pm 13/03
