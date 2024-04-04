/**
 * A. Robertson
 *
 * Class representing a group of widgets. Used for Radio Buttons.
 */

class WidgetGroupType {
  protected ArrayList<Widget> Members;

  /**
   * A. Robertson
   *
   * Constructs a new WidgetGroup with an empty list of members.
   */
  public WidgetGroupType() {
    Members = new ArrayList<Widget>();
  }

  /**
   * A. Robertson
   *
   * Gets the list of members of the widget group.
   *
   * @returns the list of members.
   */
  public ArrayList<Widget> getMembers() {
    return Members;
  }
}

/**
 * A. Robertson
 *
 * Abstract class representing a Widget. All controls included in a screen must extend Widget.
 */
abstract class Widget {

  protected PVector m_pos, m_scale;
  protected PVector m_basePos, m_baseScale;
  protected Widget m_parentWidget = null;
  protected ArrayList<Widget> m_children;

  protected int m_backgroundColour = DEFAULT_BACKGROUND_COLOUR;
  protected int m_foregroundColour = DEFAULT_FOREGROUND_COLOUR;
  protected int m_outlineColour = DEFAULT_OUTLINE_COLOUR;

  protected boolean m_drawOutlineEnabled = true;
  protected EventType<EventInfoType> m_onMouseEnterEvent = new EventType<EventInfoType>();
  protected EventType<EventInfoType> m_onMouseExitEvent = new EventType<EventInfoType>();
  protected EventType<EventInfoType> m_onFocusGainedEvent = new EventType<EventInfoType>();
  protected EventType<EventInfoType> m_onFocusLostEvent = new EventType<EventInfoType>();

  private float m_growScale = 1.0f;
  private float m_growMult = 1.0f;
  protected boolean m_mouseHovered = false;
  protected boolean m_focused = false;
  protected boolean m_rendered = true;
  protected boolean m_active = true;

  /**
   * A. Robertson
   *
   * Constructs a new Widget from a position and scale.
   *
   * @param pos The position of the widget.
   * @param scale The size of the widget.
   */
  public Widget(PVector pos, PVector scale) {
    m_pos = pos;
    m_scale = scale;
    m_basePos = m_pos.copy();
    m_baseScale = m_scale.copy();

    m_children = new ArrayList<Widget>();

    getOnMouseEnterEvent().addHandler(e -> m_mouseHovered = true);
    getOnMouseExitEvent().addHandler(e -> m_mouseHovered = false);
  }

  /**
   * A. Robertson
   *
   * Constructs a new Widget from a individual position and scale values.
   *
   * @param posX The x position of the widget.
   * @param posY the y position of the widget.
   * @param scaleX The width of the widget.
   * @param scaleY The width of the widget.
   */
  public Widget(int posX, int posY, int scaleX, int scaleY) {
    m_pos = new PVector(posX, posY);
    m_scale = new PVector(scaleX, scaleY);
    m_basePos = m_pos.copy();
    m_baseScale = m_scale.copy();

    m_children = new ArrayList<Widget>();

    getOnMouseEnterEvent().addHandler(e -> m_mouseHovered = true);
    getOnMouseExitEvent().addHandler(e -> m_mouseHovered = false);
  }

  /**
   * A. Robertson
   *
   * Gets if the widget is active or not.
   *
   * @returns A boolean representing if the widget is active or not.
   */
  public boolean getActive() {
    return m_active;
  }

  /**
   * A. Robertson
   *
   * Sets if the widget is active or not.
   *
   * @param active A boolean representing if the control is active.
   */
  public void setActive(boolean active) {
    m_active = active;
    for (Widget child : m_children)
      child.setActive(active);
  }

  /**
   * A. Robertson
   *
   * Gets the list of child widgets.
   *
   * @returns The list of child widgets.
   */
  public ArrayList<Widget> getChildren() {
    return m_children;
  }

  /**
   * A. Robertson
   *
   * Sets if the outline should be drawn or not.
   *
   * @param drawOutline A boolean representing if the outline should be drawn.
   */
  public void setDrawOutline(boolean drawOutline) {
    m_drawOutlineEnabled = drawOutline;
  }

  /**
   * A. Robertson
   *
   * Sets the background colour of the widget.
   */
  public void setBackgroundColour(int backgroundColour) {
    m_backgroundColour = backgroundColour;
  }

  /**
   * A. Robertson
   *
   * Sets the foreground colour of the widget.
   */
  public void setForegroundColour(int foregroundColour) {
    m_foregroundColour = foregroundColour;
  }

  /**
   * A. Robertson
   *
   * Sets the outline colour of the widget.
   *
   * @param outlineColour The colour the outline of the widget should be.
   */
  public void setOutlineColour(int outlineColour) {
    m_outlineColour = outlineColour;
  }

  /**
   * A. Robertson
   *
   * Gets the background colour of the widget
   *
   * @returns The current background colour of the widget.
   */
  public int getBackgroundColour() {
    return this.m_backgroundColour;
  }

  /**
   * A. Robertson
   *
   * Gets the foreground colour of the widget.
   *
   * @returns The foreground colour of the widget.
   */
  public int getForegroundColour() {
    return m_foregroundColour;
  }

  /**
   * A. Robertson
   *
   * Gets the outline colour of the widget.
   *
   * @returns The outline colour of the widget.
   */
  public int getOutlineColour() {
    return m_outlineColour;
  }

  /**
   * A. Robertson
   *
   * Gets the position of the widget.
   *
   * @returns The position of the widget.
   */
  public PVector getPos() {
    return m_pos;
  }

  /**
   * A. Robertson
   *
   * Gets the scale of the widget.
   *
   * @returns The scale of the widget.
   */
  public PVector getScale() {
    return m_scale;
  }

  /**
   * F. Wright
   *
   * Sets the parent of the widget.
   *
   * @param parent The new parent widget.
   */
  public void setParent(Widget parent) {
    m_parentWidget = parent;
  }

  /**
   * F. Wright
   *
   * Sets the growth scale of the widget.
   *
   * @param value The growth scale to be used.
   */
  public void setGrowScale(float value) {
    m_growScale = value;
  }

  /**
   * F. Wright
   *
   * Sets if the widget should render.
   *
   * @param enabled A boolean representing if the widget should render.
   */
  public void setRendering(boolean enabled) {
    m_rendered = enabled;
  }

  /**
   * F. Wright
   *
   * Gets if the widget is rendering.
   *
   * @returns A boolean representing if the widget is rendering.
   */
  public boolean getRenderingEnabled() {
    return m_rendered;
  }

  /**
   * A. Robertson
   *
   * Sets the x position of the widget.
   *
   * @param  x The new x position.
   **/
  public void setPos(int x, int y) {
    m_basePos = new PVector(x, y);
    m_pos = m_basePos.copy();
  }

  /**
   * F. Wright
   *
   * Sets the position of the widget.
   *
   * @param newPos A vector representing the new position.
   */
  public void setPos(PVector newPos) {
    m_basePos = newPos;
    m_pos = m_basePos.copy();
  }

  /**
   * A. Robertson
   *
   * Sets the width and height of the widget.
   *
   * @param  w The new width.
   * @param h The new height.
   * @throws IllegalArgumentException when the width or height argument is negative.
   **/
  public void setScale(int w, int h) {
    if (w < 0 || h < 0)
      throw new IllegalArgumentException("Scale cannot be negative.");

    m_baseScale = new PVector(w, h);
    m_scale = m_baseScale.copy();
  }

  /**
   * F. Wright
   *
   * Sets the width and height of the widget.
   *
   * @param newScale The new width and height of the widget.
   * @throws IllegalArgumentException when the width or height argument is negative.
   */
  public void setScale(PVector newScale) {
    if (newScale.x < 0 || newScale.y < 0)
      throw new IllegalArgumentException("Scale cannot be negative.");

    m_baseScale = newScale;
    m_scale = m_baseScale.copy();
  }

  /**
   * A. Robertson
   *
   * Checks if a position is inside the widget.
   *
   * @param mx The x component of the position to be checked.
   * @param my The y component of the position to be checked.
   * @returns Weather the provided position is inside the widget.
   */
  public boolean isPositionInside(int mx, int my) {
    return
      mx >= m_pos.x && mx <= (m_pos.x + m_scale.x) &&
      my >= m_pos.y && my <= (m_pos.y + m_scale.y);
  }

  /**
   * A. Robertson
   *
   * Draws the outline of the widget if it should be drawn.
   */
  protected void drawOutline() {
    if (m_drawOutlineEnabled)
      stroke(color(m_outlineColour));
    else
      noStroke();
  }

  /**
   * A. Robertson/F. Wright
   *
   * Draws the widget.
   */
  public void draw() {
    drawOutline();

    m_pos = m_basePos.copy();
    m_scale = m_baseScale.copy();

    float lerpSpeed = m_mouseHovered ? 0.2 : 0.1;
    float targetMult = m_mouseHovered ? m_growScale : 1.0f;
    m_growMult = lerp(m_growMult, targetMult, lerpSpeed);
    m_scale.mult(m_growMult);

    PVector extension = m_scale.copy().sub(m_baseScale);
    m_pos = m_basePos.copy().sub(extension.mult(0.5));

    Widget curParent = m_parentWidget;
    while (curParent != null) {
      m_pos.add(curParent.m_basePos);
      m_scale.x *= curParent.m_baseScale.x;
      m_scale.y *= curParent.m_baseScale.y;
      curParent = curParent.m_parentWidget;
    }
  }

  /**
   * A. Robertson
   *
   * Returns if the widget is focused.
   *
   * @returns If the widget is focused.
   */
  public boolean isFocused() {
    return m_focused;
  }

  /**
   * A. Robertson
   *
   * Sets if the widget is focused.
   *
   * @param focused If the widget should be focused.
   */
  public void setFocused(boolean focused) {
    m_focused = focused;
    if (m_focused)
      m_onFocusGainedEvent.raise(new EventInfoType((int)m_pos.x, (int)m_pos.y, this));
    else
      m_onFocusLostEvent.raise(new EventInfoType((int)m_pos.x, (int)m_pos.y, this));
  }

  /**
   * A. Robertson
   *
   * Sets if the widget is focused.
   *
   * @param focused If the widget should be focused.
   * @param x The x position the event should occur in.
   * @param y The y position the event should occur in.
   */
  public void setFocused(boolean focused, int x, int y) {
    m_focused = focused;
    if (m_focused)
      m_onFocusGainedEvent.raise(new EventInfoType(x, y, this));
    else
      m_onFocusLostEvent.raise(new EventInfoType(x, y, this));
  }

  /**
   * A. Robertson
   *
   * Gets the on mouse enter event.
   *
   * @returns The onMouseEnterEvent.
   */
  public EventType<EventInfoType> getOnMouseEnterEvent() {
    return m_onMouseEnterEvent;
  }

  /**
   * A. Robertson
   *
   * Gets the on mouse exit event.
   *
   * @returns The onMouseExitEvent.
   */
  public EventType<EventInfoType> getOnMouseExitEvent() {
    return m_onMouseExitEvent;
  }

  /**
   * A. Robertson
   *
   * Gets the on focus gained event.
   *
   * @returns The onFocusGainedEvent.
   */
  public EventType<EventInfoType> getOnFocusGainedEvent() {
    return m_onFocusGainedEvent;
  }

  /**
   * A. Robertson
   *
   * Gets the on focus lost event.
   *
   * @returns The onFocuslostEvent.
   */
  public EventType<EventInfoType> getOnFocusLostEvent() {
    return m_onFocusLostEvent;
  }
}

/**
 * F. Wright
 *
 * A class representing an empty widget.
 *
 * @extends Widget
 */
class EmptyWidgetUI extends Widget {
  /**
   * F. Wright
   *
   * Constructs a new empty widget.
   *
   * @param posX The x position of the new widget.
   * @param posY The y position of the new widget.
   */
  EmptyWidgetUI(int posX, int posY) {
    super(posX, posY, 1, 1);
  }
}

// Descending code authorship changes:
// A. Robertson, Created widget base class and widget group, 12pm 04/03/24
// F. Wright, Modified and simplified code to fit coding standard. Combined all Widget related classes/structs into the Widget tab, 6pm 04/03/24
// F. Wright, Implemented new "grow mode" for any widgets which makes them feel jucier when hovered, 1pm 07/03/24
// F. Wright, Implemented a widget parenting system, 1pm 15/03/24
