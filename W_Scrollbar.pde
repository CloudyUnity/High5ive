/**
 * A. Robertson
 *
 * Represents the scrollbar UI along with addign the functionality of
 * the scroll bar itself.
 */


class ScrollbarUI extends Widget implements IClickable, IWheelInput, IDraggable {
  private int m_numberOfElements;
  private int m_currentTopElement;
  private int m_numberOfViewedElements;
  private EventType<EventInfoType> m_onClickEvent;
  private EventType<MouseWheelEventInfoType> m_onMouseWheelEvent;
  private EventType<MouseDraggedEventInfoType> m_onMouseDraggedEvent;

  /**
   * A. Robertson
   *
   * Initializes a new scrollbar widget with the specified parameters.
   *
   * @param x The x-coordinate of the scrollbar's position.
   * @param y The y-coordinate of the scrollbar's position.
   * @param scaleX The horizontal scale of the scrollbar.
   * @param scaleY The vertical scale of the scrollbar.
   * @param numElements The total number of elements.
   * @param numViewed The number of elements visible at a time.
   */

  public ScrollbarUI(int x, int y, int scaleX, int scaleY, int numElements, int numViewed) {
    super(x, y, scaleX, scaleY);

    setDrawOutline(false);

    m_numberOfElements = numElements;
    m_currentTopElement = 0;
    m_numberOfViewedElements = numViewed;
    m_foregroundColour = #ADADAD;

    m_onClickEvent = new EventType<EventInfoType>();
    m_onMouseWheelEvent = new EventType<MouseWheelEventInfoType>();
    m_onMouseDraggedEvent = new EventType<MouseDraggedEventInfoType>();

    m_onClickEvent.addHandler(e -> onClick(e));
    m_onMouseWheelEvent.addHandler(e -> onMouseWheel(e));
    m_onMouseDraggedEvent.addHandler(e -> onMouseDragged(e));
  }

  @ Override
  /**
   * A. Robertson
   *
   * Draws the scrollbar UI along with the scroll bar.
   */

    public void draw() {
    super.draw();

    fill(m_backgroundColour);
    rect(m_pos.x, m_pos.y, m_scale.x, m_scale.y);

    fill(m_foregroundColour);
    double startPercent = (double)m_currentTopElement / (double)m_numberOfElements;
    int startY = (int)(startPercent * (double)m_scale.y);
    int barHeight = (int)(((double)m_numberOfViewedElements/(double)m_numberOfElements) * m_scale.y) - 2; // -2 to give a little space at the top.
    rect(m_pos.x + 1, m_pos.y + startY + 1, 8, barHeight, 4);
  }

  /**
   * A. Robertson
   *
   * Retrieves the event type for handling mouse wheel events on the scrollbar.
   *
   * @return The event type for mouse wheel events.
   */

  public EventType<MouseWheelEventInfoType> getOnMouseWheelEvent() {
    return m_onMouseWheelEvent;
  }
  /**
   * A. Robertson
   *
   * Retrieves the event type for handling click events on the scrollbar.
   *
   * @return The event type for click events.
   */


  public EventType<EventInfoType> getOnClickEvent() {
    return m_onClickEvent;
  }
  /**
   * A. Robertson
   *
   * Retrieves the event type for handling dragged events on the scrollbar.
   *
   * @return The event type for dragged events.
   */


  public EventType<MouseDraggedEventInfoType> getOnDraggedEvent() {
    return m_onMouseDraggedEvent;
  }
  /**
   * A. Robertson
   *
   * Gets the index of the current top element of the scrollbar.
   *
   * @param top The index of the top element to set.
   */


  public int getCurrentTop() {
    return m_currentTopElement;
  }
  /**
   * A. Robertson
   *
   * Sets the index of the current top element of the scrollbar.
   *
   * @param top The index of the top element to set.
   */

  public void setCurrentTop(int top) {
    m_currentTopElement = top;
  }
  /**
   * A. Robertson
   *
   * Sets the total number of elements for the scrollbar.
   *
   * @param num The total number of elements.
   */

  public void setNumberOfElements(int num) {
    m_numberOfElements = num;
  }
  /**
   * A. Robertson
   *
   * Sets the number of elements visible at a time for the scrollbar.
   *
   * @param num The number of elements visible.
   */

  public void setNumberOfViewedElements(int num) {
    m_numberOfViewedElements = num;
  }

  /**
   * A. Robertson
   *
   * Handles the mouse wheel event for scrolling the scrollbar.
   *
   * @param e The mouse wheel event information.
   */
  

    private void onMouseWheel(MouseWheelEventInfoType e) {
    if (getActive()) {
      boolean wheelCountNegative = e.WheelCount < 0;
      boolean wheelCountPositive = e.WheelCount > 0;
      boolean validElement = m_currentTopElement < m_numberOfElements - m_numberOfViewedElements; // This needs a better name but I don't understand it

      if (wheelCountNegative && m_currentTopElement > 0)
        m_currentTopElement--;
      else if (wheelCountPositive && validElement)
        m_currentTopElement++;
    }
  }
  /**
   * A. Robertson
   *
   * Handles the click event for adjusting the position of the scrollbar.
   *
   * @param e The click event information.
   */


  private void onClick(EventInfoType e) {
    double percentage = (e.Y - m_pos.y) / m_scale.y;
    m_currentTopElement = Math.max(0, Math.min((int)(percentage * (double)m_numberOfElements) - 1, m_numberOfElements - m_numberOfViewedElements));
  }
  /**
   * A. Robertson
   *
   * Handles the mouse dragged event for adjusting the position of the scrollbar.
   *
   * @param e The mouse dragged event information.
   */


  private void onMouseDragged(MouseDraggedEventInfoType e) {
    onClick(new EventInfoType(0, e.Y, this));
  }
}
