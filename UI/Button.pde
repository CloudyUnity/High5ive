import java.util.function.Consumer;

class Button extends Widget implements IClickable {
  public Button(int x, int y, int width, int height) {
    super(x, y, width, height);
    this.textSize = 12;
    this.onClickEvent = new Event<EventInfo>();
    this.textXOffset = 5;
    this.textYOffset = 0;
    
    this.label = new Label(x, y, this.width, this.height, null);
  }

  @ Override
  public void draw() {
    super.draw();
    fill(this.backgroundColour);
    rect(this.x, this.y, this.width, this.height);

    this.label.draw();
  }

  public Event<EventInfo> getOnClickEvent() {
    return this.onClickEvent;
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

  /**
   * Sets the button text offset from the left edge if not centred.
   *
   * @param  textXOffset The offset from the left edge of the button.
   * @throws IllegalArgumentException when the textXOffset argument is negative.
   **/
  public void setTextXOffset(int textXOffset) {
    this.label.setTextXOffset(textXOffset);
  }

  /**
   * Sets the button text offset from the top edge if not centred.
   *
   * @param  textXOffset The offset from the left edge of the button.
   * @throws IllegalArgumentException when the textXOffset argument is negative.
   **/
  public void setTextYOffset(int textYOffset) {
    this.label.setTextYOffset(textYOffset);
  }

  private Event<EventInfo> onClickEvent;
  private int textSize, textXOffset, textYOffset;
  private Label label;
}
