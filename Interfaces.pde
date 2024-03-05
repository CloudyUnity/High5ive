interface IClickable {
  public Event<EventInfoType> getOnClickEvent();
}

interface IDraggable {
  public Event<MouseDraggedEventInfoType> getOnDraggedEvent();
}

// Descending code authorship changes:
// A. Robertson, ___
// F. Wright, Moved code into Interfaces tab from seperate tabs, 6pm 04/03/24
