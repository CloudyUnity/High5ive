class FlightCodesBarchartDemo extends Screen {
  private HistogramChartUI<FlightType, String> chart;
  private ArrayList<FlightType> data;

  public FlightCodesBarchartDemo(String screenId) {
    super(screenId, color(150, 150, 150, 255));
  }

  @Override
    public void init() {
    super.init();
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

    chart = new HistogramChartUI<FlightType, String>(100, 100, (int)m_scale.x - 200, (int)m_scale.y - 200);
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
