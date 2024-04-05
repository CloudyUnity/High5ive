/**
 * A. Robertson
 *
 * Abstract class representing a screen in the application.
 *
 * @extends Widget
 * @implements IClickable, IWheelInput
 */
abstract class Screen extends Widget implements IClickable, IWheelInput {
  private ArrayList<Widget> m_children;
  private ArrayList<WidgetGroupType> m_groups;

  private String m_screenId;
  private color m_backgroundColor;
  private boolean m_initialised;

  private EventType<EventInfoType> m_onClickEvent;
  private EventType<MouseMovedEventInfoType> m_onMouseMovedEvent;
  private EventType<MouseDraggedEventInfoType> m_onMouseDraggedEvent;
  private EventType<KeyPressedEventInfoType> m_onKeyPressedEvent;
  private EventType<MouseWheelEventInfoType> m_mouseWheelEvent;

  /**
   * A. Robertson
   *
   * Constructs a new screen with the given screen ID and background color.
   *
   * @param screenId       The unique identifier for the screen.
   * @param backgroundColor The background color of the screen.
   */
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

  /**
   * A. Robertson
   *
   * Draws the screen with its background color and renders its child widgets.
   */
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

  /**
   * A. Robertson
   *
   * Initializes the screen.
   */
  public void init() {
    m_initialised = true;
  }

  /**
   * A. Robertson
   *
   * Adds a widget to the screen's list of children.
   *
   * @param widget The widget to add.
   */
  public void addWidget(Widget widget) {
    addWidget(widget, widget.getLayer());
  }
  
  public void addWidget(Widget widget, int layer) {
    if (widget == null)
      return;
      
    widget.setLayer(layer);
    for (int i = 0; i < m_children.size(); i++){
      if (m_children.get(i).getLayer() < layer){
        m_children.add(i, widget);
        return;
      }
    }
    
    m_children.add(widget);
  }

  /**
   * A. Robertson
   *
   * Retrieves the list of children widgets belonging to this screen.
   *
   * @return The list of children widgets.
   */
  public ArrayList<Widget> getChildren() {
    return m_children;
  }

  /**
   * A. Robertson
   *
   * Retrieves the event type for mouse moved events.
   *
   * @return The event type for mouse moved events.
   */
  public EventType<MouseMovedEventInfoType> getOnMouseMovedEvent() {
    return m_onMouseMovedEvent;
  }

  /**
   * A. Robertson
   *
   * Retrieves the event type for mouse dragged events.
   *
   * @return The event type for mouse dragged events.
   */
  public EventType<MouseDraggedEventInfoType> getOnMouseDraggedEvent() {
    return m_onMouseDraggedEvent;
  }

  /**
   * A. Robertson
   *
   * Retrieves the event type for mouse click events.
   *
   * @return The event type for mouse click events.
   */
  public EventType<EventInfoType> getOnClickEvent() {
    return m_onClickEvent;
  }

  /**
   * A. Robertson
   *
   * Retrieves the event type for key pressed events.
   *
   * @return The event type for key pressed events.
   */
  public EventType<KeyPressedEventInfoType> getOnKeyPressedEvent() {
    return m_onKeyPressedEvent;
  }

  /**
   * A. Robertson
   *
   * Retrieves the event type for mouse wheel events.
   *
   * @return The event type for mouse wheel events.
   */
  public EventType<MouseWheelEventInfoType> getOnMouseWheelEvent() {
    return m_mouseWheelEvent;
  }

  /**
   * A. Robertson
   *
   * Recursively checks for mouse movement within widgets and raises appropriate events.
   *
   * @param widget The widget to check for mouse movement.
   */
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

  /**
   * A. Robertson
   *
   * Handles the mouse moved event.
   */
  private void onMouseMoved() {
    for (Widget widget : m_children)
      doMouseMoved(widget);

    for (WidgetGroupType group : m_groups)
      for (Widget widget : group.getMembers())
        doMouseMoved(widget);
  }

  /**
   * A. Robertson
   *
   * Recursively checks for mouse clicks within widgets and raises appropriate events.
   *
   * @param widget The widget to check for mouse clicks.
   */
  private boolean doMouseClick(Widget widget) {
    boolean handled = false;
    if (widget.getActive()) {
      if (widget instanceof IClickable) {
        if (widget.isPositionInside(mouseX, mouseY)) {
          ((IClickable)widget).getOnClickEvent().raise(new EventInfoType(mouseX, mouseY, widget));
          widget.setFocused(true);
          handled = true;
        } else {
          widget.setFocused(false);
        }
      }
    }

    for (Widget w : widget.getChildren())
      handled |= doMouseClick(w);

    return handled;
  }

  /**
   * A. Robertson
   *
   * Handles the mouse click event.
   */
  private void onMouseClick() {
    boolean handled = false;

    for (int i = m_children.size() - 1; i >= 0; i--) {
      if (!handled)
        handled |= doMouseClick(m_children.get(i));
      else
        m_children.get(i).setFocused(false);
    }

    for (WidgetGroupType group : m_groups) {
      for (int i = group.getMembers().size() - 1; i >= 0; i--) {
        if (!handled)
          handled |= doMouseClick(group.getMembers().get(i));
        else
          group.getMembers().get(i).setFocused(false);
      }
    }
  }

  /**
   * A. Robertson
   *
   * Recursively checks for mouse dragging within widgets and raises appropriate events.
   *
   * @param widget The widget to check for mouse dragging.
   */
  private void doMouseDragged(Widget widget) {
    if (widget.getActive()) {
      if (widget instanceof IDraggable && widget.isPositionInside(pmouseX, pmouseY))
        ((IDraggable)widget).getOnDraggedEvent().raise(new MouseDraggedEventInfoType(mouseX, mouseY, pmouseX, pmouseY, widget));
    }
    for (Widget w : widget.getChildren())
      doMouseDragged(w);
  }

  /**
   * A. Robertson
   *
   * Recursively handles mouse dragged events within widgets.
   */
  private void onMouseDragged() {
    for (Widget child : m_children)
      doMouseDragged(child);

    for (WidgetGroupType group : this.m_groups)
      for (Widget child : group.getMembers())
        doMouseDragged(child);
  }

  /**
   * A. Robertson
   *
   * Recursively checks for mouse wheel events within widgets and raises appropriate events.
   *
   * @param widget The widget to check for mouse wheel events.
   * @param e      The mouse wheel event information.
   */
  private void doMouseWheel(Widget widget, MouseWheelEventInfoType e) {
    if (widget.getActive()) {
      if (widget instanceof IWheelInput && (widget.isFocused() || widget.isPositionInside(mouseX, mouseY)))
        ((IWheelInput)widget).getOnMouseWheelEvent().raise(new MouseWheelEventInfoType(mouseX, mouseY, e.WheelCount, widget));
    }
    for (Widget w : widget.getChildren())
      doMouseWheel(w, e);
  }

  /**
   * A. Robertson
   *
   * Handles the mouse wheel event.
   *
   * @param e The mouse wheel event information.
   */
  private void onMouseWheel(MouseWheelEventInfoType e) {
    for (Widget child : m_children)
      doMouseWheel(child, e);

    for (WidgetGroupType group : this.m_groups)
      for (Widget child : group.getMembers())
        doMouseWheel(child, e);
  }

  /**
   * A. Robertson
   *
   * Recursively checks for key pressed events within widgets and raises appropriate events.
   *
   * @param widget The widget to check for key pressed events.
   * @param e      The key pressed event information.
   */
  private boolean doKeyPressed(Widget widget, KeyPressedEventInfoType e) {
    boolean handled = false;
    if (widget.getActive()) {
      if (widget instanceof IKeyInput && widget.isFocused()) {
        ((IKeyInput)widget).getOnKeyPressedEvent().raise(new KeyPressedEventInfoType(e.X, e.Y, e.PressedKey, e.PressedKeyCode, widget));
        handled = true;
      }
    }

    if (widget.getChildren().size() > 0) {
      for (int i = 0; i < widget.getChildren().size(); i++) {
        handled |= doKeyPressed(widget.getChildren().get(i), e);
      }
    }
    return handled;
  }

  /**
   * A. Robertson
   *
   * Handles the key pressed event, allowing it to only be handled by 1 widget and its children.
   *
   * @param e The key pressed event information.
   */
  private void onKeyPressed(KeyPressedEventInfoType e) {
    boolean handled = false;
    for (int i = m_children.size() - 1; i >= 0 && !handled; i--) {
      handled |= doKeyPressed(m_children.get(i), e);
    }


    for (WidgetGroupType group : this.m_groups) {
      for (int i = group.getMembers().size() - 1; i >= 0 && !handled; i--) {
        handled |= doKeyPressed(group.getMembers().get(i), e);
      }
    }
  }

  /**
   * A. Robertson
   *
   * Gets the screen ID.
   *
   * @return The screen ID.
   */
  public String getScreenId() {
    return m_screenId;
  }

  /**
   * A. Robertson
   * Adds a widget group to the screen.
   *
   * @param group The widget group to add.
   */
  public void addWidgetGroup(WidgetGroupType group) {
    m_groups.add(group);
  }

  /**
   * F. Wright
   *
   * Creates a button UI widget at the specified position with the given dimensions.
   *
   * @param posX   The x-coordinate of the button's position.
   * @param posY   The y-coordinate of the button's position.
   * @param scaleX The width of the button.
   * @param scaleY The height of the button.
   * @return The created ButtonUI instance.
   */
  public ButtonUI createButton(int posX, int posY, int scaleX, int scaleY) {
    ButtonUI bttn = new ButtonUI(posX, posY, scaleX, scaleY);
    addWidget(bttn);
    return bttn;
  }

  /**
   * F. Wright
   *
   * Creates a checkbox UI widget at the specified position with the given dimensions and label.
   *
   * @param posX   The x-coordinate of the checkbox's position.
   * @param posY   The y-coordinate of the checkbox's position.
   * @param scaleX The width of the checkbox.
   * @param scaleY The height of the checkbox.
   * @param label  The label text of the checkbox.
   * @return The created CheckboxUI instance.
   */
  public CheckboxUI createCheckbox(int posX, int posY, int scaleX, int scaleY, String label) {
    CheckboxUI chk = new CheckboxUI(posX, posY, scaleX, scaleY, label);
    addWidget(chk);
    return chk;
  }

  /**
   * F. Wright
   *
   * Creates a label UI widget at the specified position with the given dimensions and text.
   *
   * @param posX   The x-coordinate of the label's position.
   * @param posY   The y-coordinate of the label's position.
   * @param scaleX The width of the label.
   * @param scaleY The height of the label.
   * @param text   The text content of the label.
   * @return The created LabelUI instance.
   */
  public LabelUI createLabel(int posX, int posY, int scaleX, int scaleY, String text) {
    LabelUI label = new LabelUI(posX, posY, scaleX, scaleY, text);
    addWidget(label);
    return label;
  }

  /**
   * F. Wright
   *
   * Creates a radio button UI widget at the specified position with the given dimensions and label.
   *
   * @param posX   The x-coordinate of the radio button's position.
   * @param posY   The y-coordinate of the radio button's position.
   * @param scaleX The width of the radio button.
   * @param scaleY The height of the radio button.
   * @param label  The label text of the radio button.
   * @return The created RadioButtonUI instance.
   */
  public RadioButtonUI createRadioButton(int posX, int posY, int scaleX, int scaleY, String label) {
    RadioButtonUI radio = new RadioButtonUI(posX, posY, scaleX, scaleY, label);
    addWidget(radio);
    return radio;
  }

  /**
   * F. Wright
   *
   * Creates a slider UI widget at the specified position with the given dimensions and parameters.
   *
   * @param posX     The x-coordinate of the slider's position.
   * @param posY     The y-coordinate of the slider's position.
   * @param scaleX   The width of the slider.
   * @param scaleY   The height of the slider.
   * @param min      The minimum value of the slider.
   * @param max      The maximum value of the slider.
   * @param interval The interval between slider values.
   * @return The created SliderUI instance.
   */
  public SliderUI createSlider(int posX, int posY, int scaleX, int scaleY, double min, double max, double interval) {
    SliderUI slider = new SliderUI(posX, posY, scaleX, scaleY, min, max, interval);
    addWidget(slider);
    return slider;
  }

  /**
   * F. Wright
   *
   * Raises an event to switch to the specified screen.
   *
   * @param e        The event information.
   * @param screenId The ID of the screen to switch to.
   */
  public void switchScreen(EventInfoType e, String screenId) {
    s_ApplicationClass.getOnSwitchEvent().raise(new SwitchScreenEventInfoType(e.X, e.Y, screenId, e.Widget));
  }
}

// Descending code authorship changes:
// A. Robertson, Created screen class to represent an individual screen 12pm 04/03/24
// F. Wright, Modified and simplified code to fit coding standard, 6pm 04/03/24
// M. Poole, Created onMouseWheel method 1pm 12/03/24
// A. Robertson, Updated to send events to child widgets, 21/03/24
