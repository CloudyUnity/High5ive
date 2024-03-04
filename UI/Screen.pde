abstract class Screen extends Widget implements IClickable {
  Screen(int width, int height, String screenId) {
    super(0, 0, width, height);
    this.children = new ArrayList<Widget>();
    this.groups = new ArrayList<WidgetGroup>();
    this.onClickEvent = new Event<EventInfo>();
    this.onMouseMovedEvent = new Event<MouseMovedEventInfo>();
    this.onMouseDraggedEvent = new Event<MouseDraggedEventInfo>();
    this.screenId = screenId;

    this.onClickEvent.addHandler(e -> onMouseClick(e));
    this.onMouseMovedEvent.addHandler(e -> onMouseMoved(e));
    this.onMouseDraggedEvent.addHandler(e -> onMouseDragged(e));
  }

  public void draw() {
    for (Widget child : this.children)
      child.draw();

    for (WidgetGroup group : this.groups) {
      for (Widget child : group.getMembers())
        child.draw();
    }
  }

  public Event<EventInfo> getOnClickEvent() {
    return this.onClickEvent;
  }

  public void addWidget(Widget widget) {
    if (widget != null)
      children.add(widget);
  }

  public ArrayList<Widget> getChildren() {
    return children;
  }

  public Event<MouseMovedEventInfo> getOnMouseMovedEvent() {
    return this.onMouseMovedEvent;
  }

  public Event<MouseDraggedEventInfo> getOnMouseDraggedEvent() {
    return this.onMouseDraggedEvent;
  }

  private void onMouseMoved(MouseMovedEventInfo e) {
    for (Widget widget : this.children) {
      if (widget.isPositionInside(e.x, e.y) && !widget.isPositionInside(e.px, e.py)) {
        widget.getOnMouseEnterEvent().raise(new EventInfo(e.x, e.y, widget));
      }
      if (!widget.isPositionInside(e.x, e.y) && widget.isPositionInside(e.px, e.py)) {
        widget.getOnMouseExitEvent().raise(new EventInfo(e.x, e.y, widget));
      }
    }

    for (WidgetGroup group : this.groups) {
      for (Widget widget : group.getMembers()) {
        if (widget.isPositionInside(e.x, e.y) && !widget.isPositionInside(e.px, e.py)) {
          widget.getOnMouseEnterEvent().raise(new EventInfo(e.x, e.y, widget));
        }
        if (!widget.isPositionInside(e.x, e.y) && widget.isPositionInside(e.px, e.py)) {
          widget.getOnMouseExitEvent().raise(new EventInfo(e.x, e.y, widget));
        }
      }
    }
  }

  private void onMouseClick(EventInfo e) {
    for (Widget child : ((Screen)e.widget).getChildren()) {
      if (child instanceof IClickable && child.isPositionInside(e.x, e.y))
        ((IClickable)child).getOnClickEvent().raise(new EventInfo(e.x, e.y, child));
    }

    for (WidgetGroup group : this.groups) {
      for (Widget child : group.getMembers()) {
        if (child instanceof IClickable && child.isPositionInside(e.x, e.y)) {
          ((IClickable)child).getOnClickEvent().raise(new EventInfo(e.x, e.y, child));
        }
      }
    }
  }

  private void onMouseDragged(MouseDraggedEventInfo e) {
    for (Widget child : ((Screen)e.widget).getChildren()) {
      if (child instanceof IDraggable && child.isPositionInside(e.px, e.py))
        ((IDraggable)child).getOnDraggedEvent().raise(new MouseDraggedEventInfo(e.x, e.y, e.px, e.py, child));
    }


    for (WidgetGroup group : this.groups) {
      for (Widget child : group.getMembers()) {
        if (child instanceof IDraggable && child.isPositionInside(e.px, e.py))
          ((IDraggable)child).getOnDraggedEvent().raise(new MouseDraggedEventInfo(e.x, e.y, e.px, e.py, child));
      }
    }
  }

  public String getScreenId() {
    return screenId;
  }

  public void addWidgetGroup(WidgetGroup group) {
    this.groups.add(group);
  }

  private ArrayList<Widget> children;
  private ArrayList<WidgetGroup> groups;
  private Event<EventInfo> onClickEvent;
  private Event<MouseMovedEventInfo> onMouseMovedEvent;
  private Event<MouseDraggedEventInfo> onMouseDraggedEvent;
  private int width, height;
  private String screenId;
}
