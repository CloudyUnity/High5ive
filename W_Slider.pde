/**
 * A. Robertson
 *
 * Represents a slider widget with a draggable handle and clickable area.
 */

class SliderUI extends Widget implements IDraggable, IClickable {
  private LabelUI m_label;
  private int m_labelSpace;
  private double m_min, m_max, m_interval, m_value;
  private int m_filledColour;
  private EventType<MouseDraggedEventInfoType> m_onDraggedEvent;
  private EventType<EventInfoType> m_onClickEvent;

  /**
   * A. Robertson
   *
   * Initializes a new SliderUI instance with the specified parameters.
   *
   * @param posX The x-coordinate of the slider's position.
   * @param posY The y-coordinate of the slider's position.
   * @param scaleX The horizontal scale of the slider.
   * @param scaleY The vertical scale of the slider.
   * @param min The minimum value of the slider.
   * @param max The maximum value of the slider.
   * @param interval The interval between each step of the slider.
   */
  public SliderUI(int posX, int posY, int scaleX, int scaleY, double min, double max, double interval) {
    super(posX, posY, scaleX, scaleY);
    m_onDraggedEvent = new EventType<MouseDraggedEventInfoType>();
    m_onClickEvent = new EventType<EventInfoType>();
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
  
  /**
   * A. Robertson
   *
   * Draws the slider UI along with its label.
   */
   @Override
    public void draw() {
    super.draw();

    fill(color(m_backgroundColour));
    rect(m_pos.x, m_pos.y + m_labelSpace, m_scale.x, m_scale.y - m_labelSpace, DEFAULT_WIDGET_ROUNDNESS_3);

    fill(color(m_filledColour));
    rect(m_pos.x, m_pos.y + m_labelSpace, (int)(m_scale.x * ((m_value - m_min) / (m_max - m_min))), m_scale.y - m_labelSpace, DEFAULT_WIDGET_ROUNDNESS_1);

    m_label.draw();
  }
  
  /**
   * A. Robertson
   *
   * Sets the text of the label associated with the slider.
   *
   * @param text The text to set for the label.
   */
  public void setLabelText(String text) {
    m_label.setText(text);
  }
  
  /**
   * A. Robertson
   *
   * Retrieves the current value of the slider.
   *
   * @return The current value of the slider.
   */
  public double getValue() {
    return m_value;
  }
  
  /**
   * A. Robertson
   *
   * Retrieves the event type for handling mouse dragged events on the slider.
   *
   * @return The event type for mouse dragged events.
   */
  public EventType<MouseDraggedEventInfoType> getOnDraggedEvent() {
    return m_onDraggedEvent;
  }
  
  /**
   * A. Robertson
   *
   * Retrieves the event type for handling click events on the slider.
   *
   * @return The event type for click events.
   */
  public EventType<EventInfoType> getOnClickEvent() {
    return m_onClickEvent;
  }

  /**
   * A. Robertson
   *
   * Handles the dragged event for the slider, updating the value and label accordingly.
   *
   * @param e The mouse dragged event information.
   */
  private void onDraggedHandler(MouseDraggedEventInfoType e) {
    double percentAcross = clamp((double)(e.X - m_pos.x) / (double)(m_scale.x), 0.0, 1.0);
    double unrounded = ((double)m_min + percentAcross * (double)(m_max - m_min));

    m_value = m_interval * (Math.round(unrounded/m_interval));

    m_label.setText(String.format("Value: %.2f", m_value));
  }

  /**
   * A. Robertson
   *
   * Handles the click event for the slider, updating the value and label accordingly.
   *
   * @param e The click event information.
   */
  private void onClickHandler(EventInfoType e) {
    double percentAcross = clamp((double)(e.X - m_pos.x) / (double)(m_scale.x), 0.0, 1.0);
    double unrounded = ((double)m_min + percentAcross * (double)(m_max - m_min));

    m_value = m_interval * (Math.round(unrounded/m_interval));

    m_label.setText(String.format("Value: %.2f", m_value));
  }
  
  /**
   * A. Robertson
   *
   * Clamps the given value within the specified range.
   *
   * @param val The value to clamp.
   * @param min The minimum value of the range.
   * @param max The maximum value of the range.
   * @return The clamped value.
   */
  private double clamp(double val, double min, double max) {
    return Math.max(min, Math.min(max, val));
  }
}

// Code authorship:
// A. Robertson, Created slider widget, 12pm 04/03/24
