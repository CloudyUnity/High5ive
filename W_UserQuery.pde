class UserQueryUI extends Widget implements IClickable, IWheelInput {

  private Event<EventInfoType> m_onClickEvent;
  private Event<MouseMovedEventInfoType> m_onMouseMovedEvent;
  private Event<MouseDraggedEventInfoType> m_onMouseDraggedEvent;
  private Event<KeyPressedEventInfoType> m_onKeyPressedEvent;
  private Event<MouseWheelEventInfoType> m_mouseWheelEvent;
  
  private Consumer<FlightType[]> m_onLoadDataEvent;

  QueryManagerClass m_queryManager;
  ArrayList <Widget> m_subWidgets = new ArrayList<Widget>();
  private TextboxUI m_day;

  UserQueryUI(int posX, int posY, int scaleX, int scaleY, QueryManagerClass queryManager) {
    super(posX, posY, scaleX, scaleY);

    m_onClickEvent = new Event<EventInfoType>();
    m_onMouseMovedEvent = new Event<MouseMovedEventInfoType>();
    m_onMouseDraggedEvent = new Event<MouseDraggedEventInfoType>();
    m_onKeyPressedEvent = new Event<KeyPressedEventInfoType>();
    m_mouseWheelEvent = new Event<MouseWheelEventInfoType>();

    m_onClickEvent.addHandler(e -> onMouseClick());
    m_onMouseMovedEvent.addHandler(e -> onMouseMoved());
    m_onMouseDraggedEvent.addHandler(e -> onMouseDragged());
    m_onKeyPressedEvent.addHandler(e -> onKeyPressed(e));
    m_mouseWheelEvent.addHandler(e -> onMouseWheel(e));
    
    m_queryManager = queryManager;

    m_day =  new TextboxUI(20, 20, 160, 30);
    m_subWidgets.add(m_day);
    m_day.setPlaceholderText("Day");

    // Initialise all UI elements
    // Set handlers to functions below
    //   For example, the "save" button should call saveQuery() when clicked
  }

  public void setOnLoadHandler(Consumer<FlightType[]> dataEvent) {
    m_onLoadDataEvent = dataEvent;
  }

  private void loadData() {
    // Load data here. Take info from all user inputs to build queries and apply them
    
    FlightType[] result = null;
    m_onLoadDataEvent.accept(result);
  }
  
  private void saveQuery(){
    // Saves currently written user input into a query
    // Adds to query output field textbox thing
    // Set all user inputs back to default
  }
  
  private void clearQueries(){
    // Clear all currently saved user queries
  }
  
  private void changeDataToUS(){
  }
  
  private void changeDataToWorld(){
  } 

  @Override
    public void draw() {
    for (var widget : m_subWidgets)
      widget.draw();
  }

  public Event<MouseMovedEventInfoType> getOnMouseMovedEvent() {
    return m_onMouseMovedEvent;
  }

  public Event<MouseDraggedEventInfoType> getOnMouseDraggedEvent() {
    return m_onMouseDraggedEvent;
  }

  public Event<EventInfoType> getOnClickEvent() {
    return m_onClickEvent;
  }

  public Event<KeyPressedEventInfoType> getOnKeyPressedEvent() {
    return m_onKeyPressedEvent;
  }

  public Event<MouseWheelEventInfoType> getOnMouseWheelEvent() {
    return m_mouseWheelEvent;
  }

  private void onMouseMoved() {
    for (Widget widget : m_subWidgets) {
      boolean mouseInsideWidget = widget.isPositionInside(mouseX, mouseY);
      boolean previousMouseInsideWidget = widget.isPositionInside(pmouseX, pmouseY);

      if (mouseInsideWidget && !previousMouseInsideWidget) {
        widget.getOnMouseEnterEvent().raise(new EventInfoType(mouseX, mouseY, widget));
      }

      if (!mouseInsideWidget && previousMouseInsideWidget) {
        widget.getOnMouseExitEvent().raise(new EventInfoType(mouseX, mouseY, widget));
      }
    }
  }

  private void onMouseClick() {
    for (Widget child : m_subWidgets) {
      if (child instanceof IClickable) {
        if (child.isPositionInside(mouseX, mouseY)) {
          ((IClickable)child).getOnClickEvent().raise(new EventInfoType(mouseX, mouseY, child));
          child.setFocused(true);
        } else {
          child.setFocused(false);
        }
      }
    }
  }

  private void onMouseDragged() {
    for (Widget child : m_subWidgets) {
      if (child instanceof IDraggable && child.isPositionInside(pmouseX, pmouseY))
        ((IDraggable)child).getOnDraggedEvent().raise(new MouseDraggedEventInfoType(mouseX, mouseY, pmouseX, pmouseY, child));
    }
  }

  private void onMouseWheel(MouseWheelEventInfoType e) {
    for (Widget child : m_subWidgets) {
      if (child instanceof IWheelInput && (child.isFocused() || child.isPositionInside(mouseX, mouseY)))
        ((IWheelInput)child).getOnMouseWheelEvent().raise(new MouseWheelEventInfoType(mouseX, mouseY, e.wheelCount, child));
    }
  }

  private void onKeyPressed(KeyPressedEventInfoType e) {
    for (Widget child : m_subWidgets) {
      if (child instanceof IKeyInput && child.isFocused())
        ((IKeyInput)child).getOnKeyPressedEvent().raise(new KeyPressedEventInfoType(e.X, e.Y, e.pressedKey, e.pressedKeyCode, child));
    }
  }
}
