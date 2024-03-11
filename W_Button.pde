import java.util.function.Function;
import java.util.TreeMap;
import java.util.Map;
import java.util.function.Consumer;

class ButtonUI extends Widget implements IClickable {
  private Event<EventInfoType> m_onClickEvent;
  private LabelUI m_label;
  private boolean m_highlightOutlineOnEnter;

  public ButtonUI(int posX, int posY, int scaleX, int scaleY) {
    super(posX, posY, scaleX, scaleY);
    m_onClickEvent = new Event<EventInfoType>();
    m_label = new LabelUI(posX, posY, scaleX, scaleY, null);
    m_label.setCentreAligned(true);
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

  public void setTextSize(int textSize) {
    m_label.setTextSize(textSize);
  }

  public void setTextXOffset(int textXOffset) {
    m_label.setTextXOffset(textXOffset);
  }

  public void setTextYOffset(int textYOffset) {
    m_label.setTextYOffset(textYOffset);
  }

  public LabelUI getLabel() {
    return m_label;
  }
}

// Code authorship:
// A. Robertson, Created button widget, 12pm 04/04/24
