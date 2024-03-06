class Screen1 extends Screen {
  public Screen1(int scaleX, int scaleY, String screenId) {
    super(scaleX, scaleY, screenId, color(220, 220, 220, 255));

    ButtonUI redBtn = new ButtonUI(50, 50, 200, 100);
    ButtonUI greenBtn = new ButtonUI(50, 200, 200, 100);
    ButtonUI blueBtn = new ButtonUI(50, 350, 200, 100);
    ButtonUI switchToScreen2Btn = new ButtonUI(350, 200, 100, 100);

    switchToScreen2Btn.setText("Screen 2");
    switchToScreen2Btn.setTextSize(25);

    redBtn.setText("Red");
    redBtn.setTextSize(30);

    greenBtn.setText("Green");
    greenBtn.setTextSize(30);

    blueBtn.setText("Blue");
    blueBtn.setTextSize(30);

    redBtn.getOnClickEvent().addHandler(e -> redButtonOnClick(e));
    greenBtn.getOnClickEvent().addHandler(e -> greenButtonOnClick(e));
    blueBtn.getOnClickEvent().addHandler(e -> blueButtonOnClick(e));

    redBtn.getOnMouseEnterEvent().addHandler(e -> changeOutlineColourOnEnter(e));
    greenBtn.getOnMouseEnterEvent().addHandler(e -> changeOutlineColourOnEnter(e));
    blueBtn.getOnMouseEnterEvent().addHandler(e -> changeOutlineColourOnEnter(e));
    switchToScreen2Btn.getOnMouseEnterEvent().addHandler(e -> changeOutlineColourOnEnter(e));

    redBtn.getOnMouseExitEvent().addHandler(e -> changeOutlineColourOnExit(e));
    greenBtn.getOnMouseExitEvent().addHandler(e -> changeOutlineColourOnExit(e));
    blueBtn.getOnMouseExitEvent().addHandler(e -> changeOutlineColourOnExit(e));
    switchToScreen2Btn.getOnMouseExitEvent().addHandler(e -> changeOutlineColourOnExit(e));

    CheckboxUI cb = new CheckboxUI(400, 400, 200, 50, "My checkbox");
    cb.setCheckedColour(color(255, 255, 0, 255));
    addWidget(cb);    

    switchToScreen2Btn.getOnClickEvent().addHandler(e -> switchToScreen2OnClick(e));

    addWidget(redBtn);
    addWidget(greenBtn);
    addWidget(blueBtn);
    addWidget(switchToScreen2Btn);
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

  private void switchToScreen2OnClick(EventInfoType e) {
    s_ApplicationClass.switchScreen(new SwitchScreenEventInfoType(e.X, e.Y, SCREEN_2_ID, e.Widget));
  }

  private void changeOutlineColourOnExit(EventInfoType e) {
    e.Widget.setOutlineColour(#000000);
  }

  private void changeOutlineColourOnEnter(EventInfoType e) {
    e.Widget.setOutlineColour(#FFFFFF);
  }
}

class Screen2 extends Screen {
  private BarChartUI m_barChart;
  private ArrayList<String> m_data;

  public Screen2(int scaleX, int scaleY, String screenId) {
    super(scaleX, scaleY, screenId, color(150, 150, 150, 255));

    ButtonUI switchToScreen1Btn = new ButtonUI(width / 2 - 50, height / 2 - 50, 100, 100);
    switchToScreen1Btn.setText("Screen 1");
    switchToScreen1Btn.setTextSize(25);

    switchToScreen1Btn.getOnMouseEnterEvent().addHandler(e -> changeOutlineColourOnEnter(e));
    switchToScreen1Btn.getOnMouseExitEvent().addHandler(e -> changeOutlineColourOnExit(e));
    switchToScreen1Btn.getOnClickEvent().addHandler(e -> switchToScreen1OnClick(e));

    RadioButtonGroupTypeUI group = new RadioButtonGroupTypeUI();

    RadioButtonUI rb1 = new RadioButtonUI(100, 100, 100, 20, "Show data");
    RadioButtonUI rb2 = new RadioButtonUI(100, 200, 100, 20, "Don't show data");

    rb1.getOnCheckedEvent().addHandler(e -> onCheckedRb1());
    rb2.getOnCheckedEvent().addHandler(e -> onCheckedRb2());

    group.addMember(rb1);
    group.addMember(rb2);


    addWidget(switchToScreen1Btn);

    addWidgetGroup(group);

    SliderUI slider = new SliderUI(100, 400, 300, 50, 0, 100, 1);
    addWidget(slider);

    LabelUI label = new LabelUI(10, 10, 100, 100, "Hello");
    addWidget(label);

    m_barChart = new BarChartUI(200, 10, 200, 200);
    m_data = new ArrayList<String>();
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

  private void switchToScreen1OnClick(EventInfoType e) {
    s_ApplicationClass.switchScreen(new SwitchScreenEventInfoType(e.X, e.Y, SCREEN_1_ID, e.Widget));
  }

  private void changeOutlineColourOnExit(EventInfoType e) {
    e.Widget.setOutlineColour(color(#000000));
  }

  private void changeOutlineColourOnEnter(EventInfoType e) {
    e.Widget.setOutlineColour(color(#FFFFFF));
  }

  private void onCheckedRb1() {
    if (DEBUG_MODE)
      println("Rb1 checked");
    m_barChart.addData(m_data, v -> v);
  }

  private void onCheckedRb2() {
    if (DEBUG_MODE)
      println("Rb2 checked");
    m_barChart.removeData();
  }
}

// Descending code authorship changes:
// A. Robertson, ___
// F. Wright, Modified and simplified code to fit coding standard. Fixed checkbox issues with colours, 6pm 04/03/24
