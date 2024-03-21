abstract class Screen extends Widget implements IClickable, IWheelInput {

  private ArrayList<Widget> m_children;
  private ArrayList<WidgetGroupType> m_groups;

  private String m_screenId;
  private color m_backgroundColor;

  private EventType<EventInfoType> m_onClickEvent;
  private EventType<MouseMovedEventInfoType> m_onMouseMovedEvent;
  private EventType<MouseDraggedEventInfoType> m_onMouseDraggedEvent;
  private EventType<KeyPressedEventInfoType> m_onKeyPressedEvent;
  private EventType<MouseWheelEventInfoType> m_mouseWheelEvent;

  Screen(String screenId, int backgroundColor) {
    super(0, 0, displayWidth, displayHeight);
    m_children = new ArrayList<Widget>();
    m_groups = new ArrayList<WidgetGroupType>();
    m_screenId = screenId;
    m_backgroundColor = backgroundColor;

    m_onClickEvent = new EventType<EventInfoType>();
    m_onMouseMovedEvent = new EventType<MouseMovedEventInfoType>();
    m_onMouseDraggedEvent = new EventType<MouseDraggedEventInfoType>();
    m_onKeyPressedEvent = new EventType<KeyPressedEventInfoType>();
    m_mouseWheelEvent = new EventType<MouseWheelEventInfoType>();

    m_onClickEvent.addHandler(e -> onMouseClick());
    m_onMouseMovedEvent.addHandler(e -> onMouseMoved());
    m_onMouseDraggedEvent.addHandler(e -> onMouseDragged());
    m_onKeyPressedEvent.addHandler(e -> onKeyPressed(e));
    m_mouseWheelEvent.addHandler(e -> onMouseWheel(e));
  }

  public void draw() {
    background(m_backgroundColor);

    for (Widget child : m_children)
      if (child.getRenderingEnabled() && child.getActive())
        child.draw();

    for (WidgetGroupType group : m_groups) {
      for (Widget child : group.getMembers())
        if (child.getRenderingEnabled() && child.getActive())
          child.draw();
    }
  }

  public void addWidget(Widget widget) {
    if (widget != null)
      m_children.add(widget);
  }

  public ArrayList<Widget> getChildren() {
    return m_children;
  }

  public EventType<MouseMovedEventInfoType> getOnMouseMovedEvent() {
    return m_onMouseMovedEvent;
  }

  public EventType<MouseDraggedEventInfoType> getOnMouseDraggedEvent() {
    return m_onMouseDraggedEvent;
  }

  public EventType<EventInfoType> getOnClickEvent() {
    return m_onClickEvent;
  }

  public EventType<KeyPressedEventInfoType> getOnKeyPressedEvent() {
    return m_onKeyPressedEvent;
  }

  public EventType<MouseWheelEventInfoType> getOnMouseWheelEvent() {
    return m_mouseWheelEvent;
  }

  private void doMouseMoved(Widget widget) {
    if (widget.getActive()) {
      boolean mouseInsideWidget = widget.isPositionInside(mouseX, mouseY);
      boolean previousMouseInsideWidget = widget.isPositionInside(pmouseX, pmouseY);

      if (mouseInsideWidget && !previousMouseInsideWidget) {
        widget.getOnMouseEnterEvent().raise(new EventInfoType(mouseX, mouseY, widget));
      }

      if (!mouseInsideWidget && previousMouseInsideWidget) {
        widget.getOnMouseExitEvent().raise(new EventInfoType(mouseX, mouseY, widget));
      }
    }

    for (Widget child : widget.getChildren())
      doMouseMoved(child);
  }

  private void onMouseMoved() {
    for (Widget widget : m_children)
      doMouseMoved(widget);

    for (WidgetGroupType group : m_groups)
      for (Widget widget : group.getMembers())
        doMouseMoved(widget);
  }

  private void doMouseClick(Widget widget) {
    if (widget.getActive()) {
      if (widget instanceof IClickable) {
        if (widget.isPositionInside(mouseX, mouseY)) {
          ((IClickable)widget).getOnClickEvent().raise(new EventInfoType(mouseX, mouseY, widget));
          widget.setFocused(true);
        } else {
          widget.setFocused(false);
        }
      }
    }
    for (Widget w : widget.getChildren())
      doMouseClick(w);
  }

  private void onMouseClick() {
    for (Widget child : m_children)
      doMouseClick(child);

    for (WidgetGroupType group : this.m_groups)
      for (Widget child : group.getMembers())
        doMouseClick(child);
  }

  private void doMouseDragged(Widget widget) {
    if (widget.getActive()) {
      if (widget instanceof IDraggable && widget.isPositionInside(pmouseX, pmouseY))
        ((IDraggable)widget).getOnDraggedEvent().raise(new MouseDraggedEventInfoType(mouseX, mouseY, pmouseX, pmouseY, widget));
    }
    for (Widget w : widget.getChildren())
      doMouseDragged(w);
  }

  private void onMouseDragged() {
    for (Widget child : m_children)
      doMouseDragged(child);

    for (WidgetGroupType group : this.m_groups)
      for (Widget child : group.getMembers())
        doMouseDragged(child);
  }

  private void doMouseWheel(Widget widget, MouseWheelEventInfoType e) {
    if (widget.getActive()) {
      if (widget instanceof IWheelInput && (widget.isFocused() || widget.isPositionInside(mouseX, mouseY)))
        ((IWheelInput)widget).getOnMouseWheelEvent().raise(new MouseWheelEventInfoType(mouseX, mouseY, e.wheelCount, widget));
    }
    for (Widget w : widget.getChildren())
      doMouseWheel(w, e);
  }

  private void onMouseWheel(MouseWheelEventInfoType e) {
    for (Widget child : m_children)
      doMouseWheel(child, e);

    for (WidgetGroupType group : this.m_groups)
      for (Widget child : group.getMembers())
        doMouseWheel(child, e);
  }

  private void doKeyPressed(Widget widget, KeyPressedEventInfoType e) {
    if (widget.getActive()) {
      if (widget instanceof IKeyInput && widget.isFocused())
        ((IKeyInput)widget).getOnKeyPressedEvent().raise(new KeyPressedEventInfoType(e.X, e.Y, e.pressedKey, e.pressedKeyCode, widget));
    }
    for (Widget w : widget.getChildren())
      doKeyPressed(w, e);
  }

  private void onKeyPressed(KeyPressedEventInfoType e) {
    for (Widget child : m_children)
      doKeyPressed(child, e);


    for (WidgetGroupType group : this.m_groups)
      for (Widget child : group.getMembers())
        doKeyPressed(child, e);
  }


  public String getScreenId() {
    return m_screenId;
  }

  public void addWidgetGroup(WidgetGroupType group) {
    m_groups.add(group);
  }

  public ButtonUI createButton(int posX, int posY, int scaleX, int scaleY) {
    ButtonUI bttn = new ButtonUI(posX, posY, scaleX, scaleY);
    addWidget(bttn);
    return bttn;
  }

  public CheckboxUI createCheckbox(int posX, int posY, int scaleX, int scaleY, String label) {
    CheckboxUI chk = new CheckboxUI(posX, posY, scaleX, scaleY, label);
    addWidget(chk);
    return chk;
  }

  public LabelUI createLabel(int posX, int posY, int scaleX, int scaleY, String text) {
    LabelUI label = new LabelUI(posX, posY, scaleX, scaleY, text);
    addWidget(label);
    return label;
  }

  public RadioButtonUI createRadioButton(int posX, int posY, int scaleX, int scaleY, String label) {
    RadioButtonUI radio = new RadioButtonUI(posX, posY, scaleX, scaleY, label);
    addWidget(radio);
    return radio;
  }

  public SliderUI createSlider(int posX, int posY, int scaleX, int scaleY, double min, double max, double interval) {
    SliderUI slider = new SliderUI(posX, posY, scaleX, scaleY, min, max, interval);
    addWidget(slider);
    return slider;
  }

  public void switchScreen(EventInfoType e, String screenId) {
    s_ApplicationClass.getOnSwitchEvent().raise(new SwitchScreenEventInfoType(e.X, e.Y, screenId, e.Widget));
  }
}

// Descending code authorship changes:
// A. Robertson, Created screen class to represent an individual screen 12pm 04/03/24
// F. Wright, Modified and simplified code to fit coding standard, 6pm 04/03/24
// M. Poole, Created onMouseWheel method 1pm 12/03/24
// A. Robertson, Updated to send events to child widgets, 21/03/24
