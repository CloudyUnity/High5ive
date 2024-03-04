class Screen2 extends Screen {
  public Screen2(int width, int height, String screenId) {
    super(width, height, screenId);

    Button switchToScreen1Btn = new Button(SCREEN_WIDTH / 2 - 50, SCREEN_HEIGHT / 2 - 50, 100, 100);
    switchToScreen1Btn.setText("Screen 1");
    switchToScreen1Btn.setTextSize(25);

    switchToScreen1Btn.getOnMouseEnterEvent().addHandler(e -> changeOutlineColourOnEnter(e));
    switchToScreen1Btn.getOnMouseExitEvent().addHandler(e -> changeOutlineColourOnExit(e));
    switchToScreen1Btn.getOnClickEvent().addHandler(e -> switchToScreen1OnClick(e));

    RadioButtonGroup group = new RadioButtonGroup();

    RadioButton rb1 = new RadioButton(100, 100, 100, 20, "Show data");
    RadioButton rb2 = new RadioButton(100, 200, 100, 20, "Don't show data");
    
    rb1.getOnCheckedEvent().addHandler(e -> onCheckedRb1(e));
    rb2.getOnCheckedEvent().addHandler(e -> onCheckedRb2(e));

    group.addMember(rb1);
    group.addMember(rb2);

    this.addWidget(switchToScreen1Btn);

    this.addWidgetGroup(group);

    Slider slider = new Slider(100, 400, 300, 50, 0, 100, 1);
    this.addWidget(slider);

    Label label = new Label(10, 10, 100, 100, "Hello");
    this.addWidget(label);
    
    this.barChart = new BarChart(200, 10, 200, 200);
    this.data = new ArrayList<String>();
    this.data.add("1");
    this.data.add("1");
    this.data.add("2");
    this.data.add("1");
    this.data.add("3");
    this.data.add("3");
    this.data.add("6");

    this.addWidget(this.barChart);
  }
  
  private void switchToScreen1OnClick(EventInfo e) {
    onSwitchScreen.raise(new SwitchScreenEventInfo(e.x, e.y, SCREEN1_ID, e.widget));
  }

  private void changeOutlineColourOnExit(EventInfo e) {
    e.widget.setOutlineColour(color(#000000));
  }

  private void changeOutlineColourOnEnter(EventInfo e) {
    e.widget.setOutlineColour(color(#FFFFFF));
  }
  
  private void onCheckedRb1(EventInfo e) {
    println("Rb1 checked");
    this.barChart.addData(this.data, v -> v);
  }
  
  private void onCheckedRb2(EventInfo e) {
    println("Rb2 checked");
    this.barChart.removeData();
  }
  
  BarChart barChart;
  ArrayList<String> data;
}
