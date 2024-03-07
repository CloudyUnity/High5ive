import java.util.function.Consumer;

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
  
  protected int m_backgroundColour = DEFAULT_BACKGROUND_COLOUR;
  protected int m_foregroundColour = DEFAULT_FOREGROUND_COLOUR;
  protected int m_outlineColour = DEFAULT_OUTLINE_COLOUR;
  
  private boolean m_drawOutlineEnabled = true;
  private Event<EventInfoType> m_onMouseEnterEvent = new Event<EventInfoType>();
  private Event<EventInfoType> m_onMouseExitEvent = new Event<EventInfoType>();

  public Widget(PVector pos, PVector scale) {
    m_pos = pos;
    m_scale = scale;
  }
  
  public Widget(int posX, int posY, int scaleX, int scaleY) {
    m_pos = new PVector(posX, posY);
    m_scale = new PVector(scaleX, scaleY);
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

  public void draw() {
    if (m_drawOutlineEnabled)
      stroke(color(m_outlineColour));
    else
      noStroke();
  }

  public Event<EventInfoType> getOnMouseEnterEvent() {
    return m_onMouseEnterEvent;
  }

  public Event<EventInfoType> getOnMouseExitEvent() {
    return m_onMouseExitEvent;
  }
}

// Descending code authorship changes:
// A. Robertson, Created widget base class and widget group, 12pm 04/03/24
// F. Wright, Modified and simplified code to fit coding standard. Combined all Widget related classes/structs into the Widget tab, 6pm 04/03/24
