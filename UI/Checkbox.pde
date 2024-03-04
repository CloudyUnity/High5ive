class Checkbox extends Widget implements IClickable {
  public Checkbox(int x, int y, int width, int height, String label) {
    super(x, y, width, height);
    this.label = new Label(this.x + this.height + this.textPadding, this.y, this.width - this.height - this.textPadding, this.height, label);
    this.textPadding = 5;
    this.checkedColour = this.DEFAULT_CHECKED_COLOUR;
    this.onClickEvent = new Event<EventInfo>();

    this.onClickEvent.addHandler(e -> {
      Checkbox box = (Checkbox)e.widget;
      box.setChecked(!(box.getChecked()));
    }
    );
  }

  @ Override
    public void draw() {
    super.draw();
    fill(this.checked ? this.checkedColour : this.backgroundColour);
    rect(this.y, this.y, this.height, this.height);

    this.label.draw();
  }

  public Event<EventInfo> getOnClickEvent() {
    return this.onClickEvent;
  }

  public void setCheckedColour(color checkedColour) {
    this.checkedColour = checkedColour;
  }

  public boolean getChecked() {
    return checked;
  }

  public void setChecked(boolean checked) {
    this.checked = checked;
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
  
  public void setText(String text) {
    this.label.setText(text);
  }

  private Label label;
  private int textPadding;
  private Event<EventInfo> onClickEvent;
  private boolean checked;
  private color checkedColour;
  public final color DEFAULT_CHECKED_COLOUR = color(#00BCD4);
}
