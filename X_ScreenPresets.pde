class Screen1 extends Screen {
  public Screen1(int scaleX, int scaleY, String screenId) {
    super(scaleX, scaleY, screenId, color(220, 220, 220, 255));

    ButtonUI redBtn = createButton(50, 50, 200, 100);
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
    blueBtn.setGrowMode(true);

    ButtonUI switchToScreen2Btn = createButton(350, 20, 100, 100);
    switchToScreen2Btn.getOnClickEvent().addHandler(e -> switchScreen(e, SCREEN_2_ID));
    switchToScreen2Btn.setText("Screen 2");
    switchToScreen2Btn.setTextSize(25);
    switchToScreen2Btn.setGrowMode(true);

    ButtonUI switchToDemo = createButton(350, 140, 100, 100);
    switchToDemo.getOnClickEvent().addHandler(e -> switchScreen(e, SWITCH_TO_DEMO_ID));
    switchToDemo.setText("Barchart demo");
    switchToDemo.setTextSize(25);
    switchToDemo.setGrowMode(true);

    ButtonUI switchTo3D = createButton(350, 260, 100, 100);
    switchTo3D.getOnClickEvent().addHandler(e -> switchScreen(e, SCREEN_FLIGHT_MAP_ID));
    switchTo3D.setText("3D (WIP)");
    switchTo3D.setTextSize(25);
    switchTo3D.setGrowMode(true);

    CheckboxUI cb = createCheckbox(400, 400, 200, 50, "My checkbox");
    cb.setCheckedColour(color(255, 255, 0, 255));
    cb.setGrowMode(true);
  }

  private void redButtonOnClick(EventInfoType e) {
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
  }
}

class Screen2 extends Screen {
  private BarChartUI m_barChart;
  private ArrayList<String> m_data;

  public Screen2(int scaleX, int scaleY, String screenId) {
    super(scaleX, scaleY, screenId, color(150, 150, 150, 255));

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

class ScreenFlightMap extends Screen {
  public ScreenFlightMap(int scaleX, int scaleY, String screenId) {
    super(scaleX, scaleY, screenId, color(0, 0, 0, 255));

    FlightMap3D flight3D = new FlightMap3D();
    addWidget(flight3D);

    ButtonUI returnBttn = createButton(20, 20, 25, 25);
    returnBttn.setBackgroundColour(color(255, 255, 255, 255));
    returnBttn.setGrowMode(true);
    returnBttn.setText("<-");
    returnBttn.getOnClickEvent().addHandler(e -> switchScreen(e, SCREEN_1_ID));
    
    LabelUI label = createLabel(0, 30, width, 50, "Finn's Cosmic Globe Adventure!");
    label.setForegroundColour(color(255,255,255,255));
    label.setCentreAligned(true);
    label.setTextSize(20);
  }

  public void applyFlightData(FlightType[] flightData) {
    for (int i = 0; i < flightData.length; i++) {
    }
  }
}

// Descending code authorship changes:
// A. Robertson, ___
// F. Wright, Modified and simplified code to fit coding standard. Fixed checkbox issues with colours, 6pm 04/03/24
// F. Wright, Refactored screen, presets and applied grow mode to relevant widgets, 1pm 07/03/24
// F. Wright, Created 3D flight map screen using OpenGL GLSL shaders and P3D features. Implemented light shading and day-night cycle, 9pm 07/03/24
