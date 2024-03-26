class Screen2 extends Screen {
  private HistogramChartUI m_barChart;
  private ArrayList<String> m_data;

  public Screen2(String screenId) {
    super(screenId, DEFAULT_SCREEN_COLOUR);
  }

  @Override
    public void init() {
    super.init();
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

    m_barChart = new HistogramChartUI(200, 10, 200, 200);
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
