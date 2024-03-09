import java.util.function.Function;

interface IClickable {
  public Event<EventInfoType> getOnClickEvent();
}

interface IDraggable {
  public Event<MouseDraggedEventInfoType> getOnDraggedEvent();
}

interface IChart<T> {
  public void addData(T[] data, Function<T, String> getKey);
  public <I extends Iterable<T>> void addData(I data, Function<T, String> getKey);
  public void removeData();
}

// Descending code authorship changes:
// A. Robertson, 12pm 04/03/24
// F. Wright, Moved code into Interfaces tab from seperate tabs, 6pm 04/03/24
// A. Robertson, Added IChart<T> interface for charts, 12am 08/03/2024
