abstract class Screen extends Widget implements IClickable {

  private ArrayList<Widget> m_children;
  private ArrayList<WidgetGroupType> m_groups;
  private String m_screenId;
  private Event<EventInfoType> m_onClickEvent;
  private Event<MouseMovedEventInfoType> m_onMouseMovedEvent;
  private Event<MouseDraggedEventInfoType> m_onMouseDraggedEvent;
  private color m_backgroundColor;

  Screen(int scaleX, int scaleY, String screenId, color backgroundColor) {
    super(0, 0, scaleX, scaleY);
    m_children = new ArrayList<Widget>();
    m_groups = new ArrayList<WidgetGroupType>();
    m_screenId = screenId;
    m_backgroundColor = backgroundColor;

    m_onClickEvent = new Event<EventInfoType>();
    m_onMouseMovedEvent = new Event<MouseMovedEventInfoType>();
    m_onMouseDraggedEvent = new Event<MouseDraggedEventInfoType>();

    m_onClickEvent.addHandler(e -> onMouseClick());
    m_onMouseMovedEvent.addHandler(e -> onMouseMoved());
    m_onMouseDraggedEvent.addHandler(e -> onMouseDragged());
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
      if (child instanceof IClickable && child.isPositionInside(mouseX, mouseY))
        ((IClickable)child).getOnClickEvent().raise(new EventInfoType(mouseX, mouseY, child));
    }

    for (WidgetGroupType group : this.m_groups) {
      for (Widget child : group.getMembers()) {
        if (child instanceof IClickable && child.isPositionInside(mouseX, mouseY)) {
          ((IClickable)child).getOnClickEvent().raise(new EventInfoType(mouseX, mouseY, child));
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

  public String getScreenId() {
    return m_screenId;
  }

  public void addWidgetGroup(WidgetGroupType group) {
    m_groups.add(group);
  }
}

// Descending code authorship changes:
// A. Robertson, ___
// F. Wright, Modified and simplified code to fit coding standard, 6pm 04/03/24
