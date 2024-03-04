import java.util.function.Consumer;

abstract class Widget {

  public final int DEFAULT_FOREGROUND_COLOUR = color(0x000000);
  public final int DEFAULT_BACKGROUND_COLOUR = color(0xF9F9F9);
  public final int DEFAULT_OUTLINE_COLOUR = color(0x000000);
  protected int x, y, width, height;
  protected color backgroundColour, foregroundColour;
  private color outlineColour;
  private boolean drawOutline;
  private Event<EventInfo> onMouseEnterEvent;
  private Event<EventInfo> onMouseExitEvent;

  public Widget(int x, int y, int width, int height) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.backgroundColour = DEFAULT_BACKGROUND_COLOUR;
    this.foregroundColour = DEFAULT_FOREGROUND_COLOUR;
    this.outlineColour = DEFAULT_OUTLINE_COLOUR;
    this.drawOutline = true;
    this.onMouseEnterEvent = new Event<EventInfo>();
    this.onMouseExitEvent = new Event<EventInfo>();
  }

  public void setDrawOutline(boolean drawOutline) {
    this.drawOutline = drawOutline;
  }

  public void setBackgroundColour(color backgroundColour) {
    this.backgroundColour = backgroundColour;
  }

  public void setForegroundColour(color foregroundColour) {
    this.foregroundColour = foregroundColour;
  }

  public void setOutlineColour(color outlineColour) {
    this.outlineColour = outlineColour;
  }

  public color getBackgroundColour() {
    return this.backgroundColour;
  }

  public color getForegroundColour() {
    return this.foregroundColour;
  }

  public color getOutlineColour() {
    return this.outlineColour;
  }

  public int getX() {
    return this.x;
  }

  public int getY() {
    return this.y;
  }

  public int getWidth() {
    return this.width;
  }

  public int getHeight() {
    return this.height;
  }

  /**
   * Sets the x position of the widget.
   *
   * @param  x The new x position.
   * @throws IllegalArgumentException when the x argument is negative.
   **/
  public void setX(int x) {
    if (x < 0)
      throw new IllegalArgumentException("X position cannot be negative.");
    else
      this.x = x;
  }

  /**
   * Sets the y position of the widget.
   *
   * @param  y The new y position.
   * @throws IllegalArgumentException when the y argument is negative.
   **/
  public void setY(int y) {
    if (y < 0)
      throw new IllegalArgumentException("Y position cannot be negative.");
    else
      this.y = y;
  }

  /**
   * Sets the width of the widget.
   *
   * @param  width The new width.
   * @throws IllegalArgumentException when the width argument is negative.
   **/
  public void setWidth(int width) {
    if (width < 0)
      throw new IllegalArgumentException("Width cannot be negative.");
    else
      this.width = width;
  }

  /**
   * Sets the height of the widget.
   *
   * @param  height The new height.
   * @throws IllegalArgumentException when the height argument is negative.
   **/
  public void setHeight(int height) {
    if (height < 0)
      throw new IllegalArgumentException("Height cannot be negative.");
    else
      this.height = height;
  }

  public boolean isPositionInside(int mx, int my) {
    return
      mx >= this.x && mx <= (this.x + this.width) &&
      my >= this.y && my <= (this.y + this.height);
  }

  public void draw() {
    if (drawOutline)
      stroke(outlineColour);
    else
      noStroke();
  }

  public Event<EventInfo> getOnMouseEnterEvent() {
    return this.onMouseEnterEvent;
  }

  public Event<EventInfo> getOnMouseExitEvent() {
    return this.onMouseExitEvent;
  }
}
