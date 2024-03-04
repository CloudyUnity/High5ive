class Screen1 extends Screen {
  public Screen1(int width, int height, String screenId) {
    super(width, height, screenId);
    
    Button redBtn = new Button(50, 50, 200, 100);
    Button greenBtn = new Button(50, 200, 200, 100);
    Button blueBtn = new Button(50, 350, 200, 100);
    Button switchToScreen2Btn = new Button(350, 200, 100, 100);

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

    Checkbox cb = new Checkbox(400, 400, 200, 50, "My checkbox");
    this.addWidget(cb);

    switchToScreen2Btn.getOnClickEvent().addHandler(e -> switchToScreen2OnClick(e));

    this.addWidget(redBtn);
    this.addWidget(greenBtn);
    this.addWidget(blueBtn);
    this.addWidget(switchToScreen2Btn);
  }

  private void redButtonOnClick(EventInfo e) {
    Button btn = (Button)e.widget;
    if (btn.getBackgroundColour() == color(#FF0000))
      btn.setBackgroundColour(btn.DEFAULT_BACKGROUND_COLOUR);
    else
      btn.setBackgroundColour(color(#FF0000));
  }

  private void greenButtonOnClick(EventInfo e) {
    Button btn = (Button)e.widget;
    if (btn.getBackgroundColour() == color(#00FF00))
      btn.setBackgroundColour(btn.DEFAULT_BACKGROUND_COLOUR);
    else
      btn.setBackgroundColour(color(#00FF00));
  }

  private void blueButtonOnClick(EventInfo e) {
    Button btn = (Button)e.widget;
    if (btn.getBackgroundColour() == color(#0000FF))
      btn.setBackgroundColour(btn.DEFAULT_BACKGROUND_COLOUR);
    else
      btn.setBackgroundColour(color(#0000FF));
  }
  
  private void switchToScreen2OnClick(EventInfo e) {
    onSwitchScreen.raise(new SwitchScreenEventInfo(e.x, e.y, SCREEN2_ID, e.widget));
  }

  private void changeOutlineColourOnExit(EventInfo e) {
    e.widget.setOutlineColour(color(#000000));
  }

  private void changeOutlineColourOnEnter(EventInfo e) {
    e.widget.setOutlineColour(color(#FFFFFF));
  }
}
