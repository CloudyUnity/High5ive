import java.util.function.Function;
import java.util.TreeMap;
import java.util.Map;
import java.util.function.Consumer;

// CKM : Proposed for Deprecation

class SliderUI extends Widget implements IDraggable, IClickable {
  private LabelUI m_label;
  private int m_labelSpace;
  private double m_min, m_max, m_interval, m_value;
  private int m_filledColour;
  private Event<MouseDraggedEventInfoType> m_onDraggedEvent;
  private Event<EventInfoType> m_onClickEvent;

  public SliderUI(int posX, int posY, int scaleX, int scaleY, double min, double max, double interval) {
    super(posX, posY, scaleX, scaleY);
    m_onDraggedEvent = new Event<MouseDraggedEventInfoType>();
    m_onClickEvent = new Event<EventInfoType>();
    m_min = min;
    m_max = max;
    m_value = min;
    m_interval = interval;
    m_labelSpace = scaleY / 3;
    m_label = new LabelUI(posX, posY, scaleX, m_labelSpace, String.format("Value: %.2f", m_value));
    m_label.setCentreAligned(true);
    m_label.setTextSize(15);
    m_filledColour = DEFAULT_SLIDER_FILLED_COLOUR;

    m_onDraggedEvent.addHandler(e -> onDraggedHandler(e));
    m_onClickEvent.addHandler(e -> onClickHandler(e));
  }

  @ Override
    public void draw() {
    super.draw();
    
    fill(color(m_backgroundColour));
    rect(m_pos.x, m_pos.y + m_labelSpace, m_scale.x, m_scale.y - m_labelSpace);
    
    fill(color(m_filledColour));
    rect(m_pos.x, m_pos.y + m_labelSpace, (int)(m_scale.x * ((m_value - m_min) / (m_max - m_min))), m_scale.y - m_labelSpace);
    
    m_label.draw();
  }

  public void setLabelText(String text) {
    m_label.setText(text);
  }

  public double getValue() {
    return m_value;
  }

  public Event<MouseDraggedEventInfoType> getOnDraggedEvent() {
    return m_onDraggedEvent;
  }

  public Event<EventInfoType> getOnClickEvent() {
    return m_onClickEvent;
  }

  private void onDraggedHandler(MouseDraggedEventInfoType e) {
    double percentAcross = clamp((double)(e.X - m_pos.x) / (double)(m_scale.x), 0.0, 1.0);
    double unrounded = ((double)m_min + percentAcross * (double)(m_max - m_min));
    
    m_value = m_interval * (Math.round(unrounded/m_interval));
    
    m_label.setText(String.format("Value: %.2f", m_value));
  }

  private void onClickHandler(EventInfoType e) {
    double percentAcross = clamp((double)(e.X - m_pos.x) / (double)(m_scale.x), 0.0, 1.0);
    double unrounded = ((double)m_min + percentAcross * (double)(m_max - m_min));
    
    m_value = m_interval * (Math.round(unrounded/m_interval));
    
    m_label.setText(String.format("Value: %.2f", m_value));
  }

  private double clamp(double val, double min, double max) {
    return Math.max(min, Math.min(max, val));
  }
}

// Code authorship:
// A. Robertson, Created slider widget, 12pm 04/03/24
