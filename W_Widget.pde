class WidgetGroupType {
  protected ArrayList<Widget> Members;

  public WidgetGroupType() {
    Members = new ArrayList<Widget>();
  }

  public ArrayList<Widget> getMembers() {
    return Members;
  }
}

abstract class Widget {

  protected PVector m_pos, m_scale;
  protected final PVector m_basePos, m_baseScale;

  protected int m_backgroundColour = DEFAULT_BACKGROUND_COLOUR;
  protected int m_foregroundColour = DEFAULT_FOREGROUND_COLOUR;
  protected int m_outlineColour = DEFAULT_OUTLINE_COLOUR;

  protected boolean m_drawOutlineEnabled = true;
  protected Event<EventInfoType> m_onMouseEnterEvent = new Event<EventInfoType>();
  protected Event<EventInfoType> m_onMouseExitEvent = new Event<EventInfoType>();
  protected Event<EventInfoType> m_onFocusGainedEvent = new Event<EventInfoType>();
  protected Event<EventInfoType> m_onFocusLostEvent = new Event<EventInfoType>();

  private boolean m_growMode = false;
  protected boolean m_mouseHovered = false;
  protected boolean m_focused = false;

  public Widget(PVector pos, PVector scale) {
    m_pos = pos;
    m_scale = scale;
    m_basePos = m_pos.copy();
    m_baseScale = m_scale.copy();

    getOnMouseEnterEvent().addHandler(e -> m_mouseHovered = true);
    getOnMouseExitEvent().addHandler(e -> m_mouseHovered = false);
  }

  public Widget(int posX, int posY, int scaleX, int scaleY) {
    m_pos = new PVector(posX, posY);
    m_scale = new PVector(scaleX, scaleY);
    m_basePos = m_pos.copy();
    m_baseScale = m_scale.copy();

    getOnMouseEnterEvent().addHandler(e -> m_mouseHovered = true);
    getOnMouseExitEvent().addHandler(e -> m_mouseHovered = false);
  }

  public void setDrawOutline(boolean drawOutline) {
    m_drawOutlineEnabled = drawOutline;
  }

  public void setBackgroundColour(int backgroundColour) {
    m_backgroundColour = backgroundColour;
  }

  public void setForegroundColour(int foregroundColour) {
    m_foregroundColour = foregroundColour;
  }

  public void setOutlineColour(int outlineColour) {
    m_outlineColour = outlineColour;
  }

  public int getBackgroundColour() {
    return this.m_backgroundColour;
  }

  public int getForegroundColour() {
    return m_foregroundColour;
  }

  public int getOutlineColour() {
    return m_outlineColour;
  }

  public PVector getPos() {
    return m_pos;
  }

  public PVector getScale() {
    return m_scale;
  }

  public void setGrowMode(boolean enabled) {
    m_growMode = enabled;
  }

  /**
   * Sets the x position of the widget.
   *
   * @param  x The new x position.
   * @throws IllegalArgumentException when the x argument is negative.
   **/
  public void setPos(int x, int y) {
    if (x < 0 || y < 0)
      throw new IllegalArgumentException("Position cannot be negative.");

    m_pos = new PVector(x, y);
  }

  public void setPos(PVector newPos) {
    if (newPos.x < 0 || newPos.y < 0)
      throw new IllegalArgumentException("Position cannot be negative.");

    m_pos = newPos;
  }

  /**
   * Sets the width of the widget.
   *
   * @param  width The new width.
   * @throws IllegalArgumentException when the width argument is negative.
   **/
  public void setScale(int w, int h) {
    if (w < 0 || h < 0)
      throw new IllegalArgumentException("Scale cannot be negative.");

    m_scale = new PVector(w, h);
  }

  public void setScale(PVector newScale) {
    if (newScale.x < 0 || newScale.y < 0)
      throw new IllegalArgumentException("Scale cannot be negative.");

    m_scale = newScale;
  }

  public boolean isPositionInside(int mx, int my) {
    return
      mx >= m_pos.x && mx <= (m_pos.x + m_scale.x) &&
      my >= m_pos.y && my <= (m_pos.y + m_scale.y);
  }

  protected void drawOutline() {
    if (m_drawOutlineEnabled)
      stroke(color(m_outlineColour));
    else
      noStroke();
  }

  public void draw() {
    drawOutline();

    if (m_growMode) {
      float mult = 1.1f;
      float lerpSpeed = m_mouseHovered ? 0.2 : 0.1;

      PVector baseScaleCopy = m_baseScale.copy();
      if (m_mouseHovered)
        baseScaleCopy.mult(mult);

      m_scale = PVector.lerp(m_scale, baseScaleCopy, lerpSpeed);

      PVector extension = m_scale.copy().sub(m_baseScale);
      m_pos = m_basePos.copy().sub(extension.mult(0.5));
    }
  }

  public boolean isFocused() {
    return m_focused;
  }

  public void setFocused(boolean focused) {
    m_focused = focused;
    if (m_focused)
      m_onFocusGainedEvent.raise(new EventInfoType((int)m_pos.x, (int)m_pos.y, this));
    else
      m_onFocusLostEvent.raise(new EventInfoType((int)m_pos.x, (int)m_pos.y, this));
  }

  public void setFocused(boolean focused, int x, int y) {
    m_focused = focused;
    if (m_focused)
      m_onFocusGainedEvent.raise(new EventInfoType(x, y, this));
    else
      m_onFocusLostEvent.raise(new EventInfoType(x, y, this));
  }

  public Event<EventInfoType> getOnMouseEnterEvent() {
    return m_onMouseEnterEvent;
  }

  public Event<EventInfoType> getOnMouseExitEvent() {
    return m_onMouseExitEvent;
  }

  public Event<EventInfoType> getOnFocusGainedEvent() {
    return m_onFocusGainedEvent;
  }

  public Event<EventInfoType> getOnFocusLostEvent() {
    return m_onFocusLostEvent;
  }
}

// Descending code authorship changes:
// A. Robertson, Created widget base class and widget group, 12pm 04/03/24
// F. Wright, Modified and simplified code to fit coding standard. Combined all Widget related classes/structs into the Widget tab, 6pm 04/03/24
// F. Wright, Implemented new "grow mode" for any widgets which makes them feel jucier when hovered, 1pm 07/03/24
