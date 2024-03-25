class ScrollbarUI extends Widget implements IClickable, IWheelInput, IDraggable {
  private int m_numberOfElements;
  private int m_currentTopElement;
  private int m_numberOfViewedElements;
  private EventType<EventInfoType> m_onClickEvent;
  private EventType<MouseWheelEventInfoType> m_onMouseWheelEvent;
  private EventType<MouseDraggedEventInfoType> m_onMouseDraggedEvent;

  public ScrollbarUI(int x, int y, int width, int height, int numElements, int numViewed) {
    super(x, y, width, height);
    
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

  public EventType<MouseWheelEventInfoType> getOnMouseWheelEvent() {
    return m_onMouseWheelEvent;
  }

  public EventType<EventInfoType> getOnClickEvent() {
    return m_onClickEvent;
  }
  
  public EventType<MouseDraggedEventInfoType> getOnDraggedEvent() {
    return m_onMouseDraggedEvent;
  }

  public int getCurrentTop() {
    return m_currentTopElement;
  }

  public void setCurrentTop(int top) {
    m_currentTopElement = top;
  }

  public void setNumberOfElements(int num) {
    m_numberOfElements = num;
  }

  public void setNumberOfViewedElements(int num) {
    m_numberOfViewedElements = num;
  }

  private void onMouseWheel(MouseWheelEventInfoType e) {
    if (getActive()) {
      if (e.wheelCount < 0 && m_currentTopElement > 0)
        m_currentTopElement--;
      else if (e.wheelCount > 0 && m_currentTopElement < m_numberOfElements - m_numberOfViewedElements)
        m_currentTopElement++;
    }
  }
  
  private void onClick(EventInfoType e) {
    double percentage = (e.Y - m_pos.y) / m_scale.y;
    m_currentTopElement = Math.max(0, Math.min((int)(percentage * (double)m_numberOfElements) - 1, m_numberOfElements - m_numberOfViewedElements));
  }
  
  private void onMouseDragged(MouseDraggedEventInfoType e) {
    onClick(new EventInfoType(0, e.Y, this));
  }
}
