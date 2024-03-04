interface IClickable {
  public Event<EventInfoType> getOnClickEvent();
}

interface IDraggable {
  public Event<MouseDraggedEventInfoType> getOnDraggedEvent();
}
