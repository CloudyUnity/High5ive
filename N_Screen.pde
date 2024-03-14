abstract class Screen extends Widget implements IClickable, IWheelInput {

  private ArrayList<Widget> m_children;
  private ArrayList<WidgetGroupType> m_groups;
  private String m_screenId;
  private Event<EventInfoType> m_onClickEvent;
  private Event<MouseMovedEventInfoType> m_onMouseMovedEvent;
  private Event<MouseDraggedEventInfoType> m_onMouseDraggedEvent;
  private Event<KeyPressedEventInfoType> m_onKeyPressedEvent;
  private Event<MouseWheelEventInfoType> m_mouseWheelEvent;
  private color m_backgroundColor;

  Screen(int scaleX, int scaleY, String screenId, int backgroundColor) {
    super(0, 0, scaleX, scaleY);
    m_children = new ArrayList<Widget>();
    m_groups = new ArrayList<WidgetGroupType>();
    m_screenId = screenId;
    m_backgroundColor = backgroundColor;

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
  }

  public void draw() {
    background(m_backgroundColor);

    for (Widget child : m_children)
      child.draw();

    for (WidgetGroupType group : m_groups) {
      for (Widget child : group.getMembers())
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
    for (Widget widget : m_children) {
      boolean mouseInsideWidget = widget.isPositionInside(mouseX, mouseY);
      boolean previousMouseInsideWidget = widget.isPositionInside(pmouseX, pmouseY);

      if (mouseInsideWidget && !previousMouseInsideWidget) {
        widget.getOnMouseEnterEvent().raise(new EventInfoType(mouseX, mouseY, widget));
      }

      if (!mouseInsideWidget && previousMouseInsideWidget) {
        widget.getOnMouseExitEvent().raise(new EventInfoType(mouseX, mouseY, widget));
      }
    }

    for (WidgetGroupType group : m_groups) {
      for (Widget widget : group.getMembers()) {

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
  }

  private void onMouseClick() {
    for (Widget child : m_children) {
      if (child instanceof IClickable) {
        if (child.isPositionInside(mouseX, mouseY)) {
          ((IClickable)child).getOnClickEvent().raise(new EventInfoType(mouseX, mouseY, child));
          child.setFocused(true);
        } else {
          child.setFocused(false);
        }
      }
    }

    for (WidgetGroupType group : this.m_groups) {
      for (Widget child : group.getMembers()) {
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
  }

  private void onMouseDragged() {
    for (Widget child : m_children) {
      if (child instanceof IDraggable && child.isPositionInside(pmouseX, pmouseY))
        ((IDraggable)child).getOnDraggedEvent().raise(new MouseDraggedEventInfoType(mouseX, mouseY, pmouseX, pmouseY, child));
    }


    for (WidgetGroupType group : this.m_groups) {
      for (Widget child : group.getMembers()) {
        if (child instanceof IDraggable && child.isPositionInside(pmouseX, pmouseY))
          ((IDraggable)child).getOnDraggedEvent().raise(new MouseDraggedEventInfoType(mouseX, mouseY, pmouseX, pmouseY, child));
      }
    }
  }

  private void onMouseWheel(MouseWheelEventInfoType e) {
    for (Widget child : m_children) {
        if (child instanceof IWheelInput && (child.isFocused() || child.isPositionInside(mouseX, mouseY)))
          ((IWheelInput)child).getOnMouseWheelEvent().raise(new MouseWheelEventInfoType(mouseX, mouseY, e.wheelCount, child));
    }

    for (WidgetGroupType group : this.m_groups) {
      for (Widget child : group.getMembers()) {
        if (child instanceof IWheelInput && (child.isFocused() || child.isPositionInside(mouseX, mouseY))) {
          ((IWheelInput)child).getOnMouseWheelEvent().raise(new MouseWheelEventInfoType(mouseX, mouseY, e.wheelCount, child));
        }
      }
    }
  }

  private void onKeyPressed(KeyPressedEventInfoType e) {
    for (Widget child : m_children) {
      if (child instanceof IKeyInput && child.isFocused())
        ((IKeyInput)child).getOnKeyPressedEvent().raise(new KeyPressedEventInfoType(e.X, e.Y, e.pressedKey, e.pressedKeyCode, child));
    }



    for (WidgetGroupType group : this.m_groups) {
      for (Widget child : group.getMembers()) {
        if (child instanceof IKeyInput && child.isFocused())
          ((IKeyInput)child).getOnKeyPressedEvent().raise(new KeyPressedEventInfoType(e.X, e.Y, e.pressedKey, e.pressedKeyCode, child));
      }
    }
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
