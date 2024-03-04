class RadioButton extends Widget implements IClickable {
  public RadioButton(int x, int y, int width, int height, String label) {
      super(x, y, width, height);
      this.checkedColour = DEFAULT_CHECKED_COLOUR;
      this.label = new Label(this.x + this.height, this.y, this.width - this.height, this.height, label);
  
      this.onCheckedEvent = new Event<EventInfo>();

      this.onClickEvent = new Event<EventInfo>();
      this.onClickEvent.addHandler(e -> {
        RadioButton box = (RadioButton)e.widget;
        if (!box.getChecked())
          this.onCheckedEvent.raise(e);
        box.setChecked(true);
      });
  }
  
  @ Override
  public void draw() {
    super.draw();
    ellipseMode(RADIUS);
    fill(this.checked ? this.checkedColour : this.backgroundColour);
    circle(this.x + this.height / 2, this.y + this.height / 2, this.height / 2);
    
    this.label.draw();
  }
  
  public Event<EventInfo> getOnClickEvent() {
    return this.onClickEvent; 
  }
  
  public Event<EventInfo> getOnCheckedEvent() {
    return this.onCheckedEvent;
  }
  
  public void setChecked(boolean checked) {
    this.checked = checked;
  }
  
  public boolean getChecked() {
    return this.checked;
  }
  
  public void setText(String text) {
    this.label.setText(text);
  }

  /**
   * Sets the button text size.
   *
   * @param  textSize The size of the text.
   * @throws IllegalArgumentException when the size argument is negative.
   **/
  public void setTextSize(int textSize) {
    this.label.setTextSize(textSize);
  }
  
  private Event<EventInfo> onClickEvent;
  private Event<EventInfo> onCheckedEvent;
  private Label label;
  private boolean checked;
  private color checkedColour;
  public final color DEFAULT_CHECKED_COLOUR = color(#00BCD4);
}
