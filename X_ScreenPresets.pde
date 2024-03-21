class Screen1 extends Screen {
  public Screen1(String screenId) {
    super(screenId, DEFAULT_SCREEN_COLOUR);
    /* ButtonUI redBtn = createButton(50, 50, 200, 100);
     redBtn.getOnClickEvent().addHandler(e -> redButtonOnClick(e));
     redBtn.setText("Red");
     redBtn.setTextSize(30);
     redBtn.setGrowScale(1.05);
     
     ButtonUI greenBtn = createButton(50, 200, 200, 100);
     greenBtn.getOnClickEvent().addHandler(e -> greenButtonOnClick(e));
     greenBtn.setText("Green");
     greenBtn.setTextSize(30);
     greenBtn.setGrowScale(1.05);
     
     ButtonUI blueBtn = createButton(50, 350, 200, 100);
     blueBtn.getOnClickEvent().addHandler(e -> blueButtonOnClick(e));
     blueBtn.setText("Blue");
     blueBtn.setTextSize(30);
     blueBtn.setGrowScale(1.05);*/
    float growScale = 1.05;

    ButtonUI switchToTextboxDemo = createButton(20, 170, 250, 100);
    switchToTextboxDemo.getOnClickEvent().addHandler(e -> switchToTextBoxDemoOnClick(e));
    switchToTextboxDemo.setText("Alex testing");
    switchToTextboxDemo.setTextSize(30);
    switchToTextboxDemo.setGrowScale(growScale);

    ButtonUI switchToScreen2Btn = createButton(20, 320, 250, 100);
    switchToScreen2Btn.getOnClickEvent().addHandler(e -> switchScreen(e, SCREEN_2_ID));
    switchToScreen2Btn.setText("Screen 2");
    switchToScreen2Btn.setTextSize(25);
    switchToScreen2Btn.setGrowScale(growScale);

    ButtonUI switchToDemo = createButton(20, 470, 250, 100);
    switchToDemo.getOnClickEvent().addHandler(e -> switchScreen(e, SWITCH_TO_DEMO_ID));
    switchToDemo.setText("Barchart demo");
    switchToDemo.setTextSize(25);
    switchToDemo.setGrowScale(growScale);

    ButtonUI switchTo2D = createButton(20, 20, 100, 100);
    switchTo2D.getOnClickEvent().addHandler(e -> switchScreen(e, SCREEN_TWOD_MAP_ID));
    switchTo2D.setText("2D (WIP)");
    switchTo2D.setTextSize(25);
    switchTo2D.setGrowScale(growScale);

    ButtonUI switchTo3D = createButton(170, 20, 100, 100);
    switchTo3D.getOnClickEvent().addHandler(e -> switchScreen(e, SCREEN_FLIGHT_MAP_ID));
    switchTo3D.setText("3D");
    switchTo3D.setTextSize(25);
    switchTo3D.setGrowScale(growScale);

    ButtonUI switchToCharts = createButton(500, 20, 100, 100);
    switchToCharts.getOnClickEvent().addHandler(e -> switchScreen(e, SCREEN_CHARTS_ID));
    switchToCharts.setText("Charts (WIP)");
    switchToCharts.setTextSize(25);

    switchToCharts.setGrowScale(1.05);

  }

  private void switchToTextBoxDemoOnClick(EventInfoType e) {
    switchScreen(e, ALEX_TESTING_ID);
  }
}

class Screen2 extends Screen {
  private BarChartUI m_barChart;
  private ArrayList<String> m_data;

  public Screen2(String screenId) {
    super(screenId, DEFAULT_SCREEN_COLOUR);

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
    rb1.setGrowScale(1.05);
    group.addMember(rb1);

    RadioButtonUI rb2 = new RadioButtonUI(100, 200, 100, 20, "Don't show data");
    rb2.getOnCheckedEvent().addHandler(e -> onCheckedRb2());
    rb2.setGrowScale(1.05);
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
  private BarChartUI<FlightType, String> chart;
  private ArrayList<FlightType> data;

  public FlightCodesBarchartDemo(String screenId) {
    super(screenId, color(150, 150, 150, 255));

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

    chart = new BarChartUI<FlightType, String>(100, 100, (int)m_scale.x - 200, (int)m_scale.y - 200);
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

  public TwoDMapScreen (String screenId, QueryManagerClass query) {
    super(screenId, DEFAULT_SCREEN_COLOUR);

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
    returnBttn.setGrowScale(1.05);
    returnBttn.setText("Return");
    returnBttn.setTextSize(textSize);
    returnBttn.getLabel().setCentreAligned(true);

    currentUIPosY += 60;
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

  public AlexTestingScreen(String screenId) {
    super(screenId, color(220, 220, 220, 255));
    box = new TextboxUI(50, 70, 200, 50);
    list = new ListboxUI<String>(50, 170, 200, 400, 40, v -> v);
    imageBox = new ImageUI(400, 50, 60, 60);
    
    box.setPlaceholderText("Placeholder...");

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
    
    testDropdown.setSearchable(true);

    addWidget(box);
    addWidget(list);
    addWidget(testDropdown);
    addWidget(imageBox);


    ButtonUI returnBttn = createButton(20, displayHeight - 60, 160, 50);

    returnBttn.getOnClickEvent().addHandler(e -> switchScreen(e, SCREEN_1_ID));
    returnBttn.setGrowScale(1.05);
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
