import java.util.function.Function;
import java.util.TreeMap;
import java.util.Map;
import java.util.function.Consumer;

class ButtonUI extends Widget implements IClickable {
  private Event<EventInfoType> m_onClickEvent;
  private int m_textSize, m_textXOffset, m_textYOffset;
  private LabelUI m_label;
  private boolean m_highlightOutlineOnEnter;

  public ButtonUI(int posX, int posY, int scaleX, int scaleY) {
    super(posX, posY, scaleX, scaleY);
    m_textSize = 12;
    m_onClickEvent = new Event<EventInfoType>();
    m_textXOffset = 5;
    m_textYOffset = 0;
    m_label = new LabelUI(posX, posY, scaleX, scaleY, null);
    m_highlightOutlineOnEnter = true;
    getOnMouseEnterEvent().addHandler(e -> changeOutlineColourOnEnter(e));
    getOnMouseExitEvent().addHandler(e -> changeOutlineColourOnExit(e));
  }

  @ Override
    public void draw() {
    super.draw();
    
    fill(m_backgroundColour);
    rect(m_pos.x, m_pos.y, m_scale.x, m_scale.y);
    
    m_label.draw();
  }

  public Event<EventInfoType> getOnClickEvent() {
    return m_onClickEvent;
  }

  public void setText(String text) {
    m_label.setText(text);
  }
  
  public void setHighlightOutlineOnEnter(boolean highlightOutlineOnEnter) {
    if (!highlightOutlineOnEnter)
      setOutlineColour(#000000);
    m_highlightOutlineOnEnter = highlightOutlineOnEnter;
  }
  
  private void changeOutlineColourOnExit(EventInfoType e) {
    if (m_highlightOutlineOnEnter)
      e.Widget.setOutlineColour(#000000);
  }

  private void changeOutlineColourOnEnter(EventInfoType e) {
    if (m_highlightOutlineOnEnter)
      e.Widget.setOutlineColour(#FFFFFF);
  }

  /**
   * Sets the button text size.
   *
   * @param  textSize The size of the text.
   * @throws IllegalArgumentException when the size argument is negative.
   **/
  public void setTextSize(int textSize) {
    m_label.setTextSize(textSize);
  }

  /**
   * Sets the button text offset from the left edge if not centred.
   *
   * @param  textXOffset The offset from the left edge of the button.
   * @throws IllegalArgumentException when the textXOffset argument is negative.
   **/
  public void setTextXOffset(int textXOffset) {
    m_label.setTextXOffset(textXOffset);
  }

  /**
   * Sets the button text offset from the top edge if not centred.
   *
   * @param  textXOffset The offset from the left edge of the button.
   * @throws IllegalArgumentException when the textXOffset argument is negative.
   **/
  public void setTextYOffset(int textYOffset) {
    m_label.setTextYOffset(textYOffset);
  }
}
