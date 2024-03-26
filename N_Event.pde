// Data type for event info 
class EventInfoType {
  public Widget Widget;
  public int X, Y;

  public EventInfoType(int x, int y, Widget widget) {
    X = x;
    Y = y;
    Widget = widget;
  }
}

// ...
class EventType<T extends EventInfoType> {
  ArrayList<Consumer<T>> EventHandlers = new ArrayList<Consumer<T>>();

  public void addHandler(Consumer<T> handler) {
    if (handler != null)
      EventHandlers.add(handler);
  }

  public void raise(T e) {
    for (Consumer<T> handler : EventHandlers)
      handler.accept(e);
  }
}

// ...
class StringEnteredEventInfoType extends EventInfoType {
  public String Data;
  
  public StringEnteredEventInfoType(int x, int y, String data, Widget widget) {
    super(x, y, widget);
    Data = data;
  }
}

// ...
class KeyPressedEventInfoType extends EventInfoType {
  public char PressedKey;
  public int PressedKeyCode;
  
  public KeyPressedEventInfoType(int x, int y, char k, int kc, Widget widget) {
    super(x, y, widget);
    PressedKey = k;
    PressedKeyCode = kc;
  }
}

// ...
class MouseDraggedEventInfoType extends EventInfoType {
  public PVector PreviousPos;

  public MouseDraggedEventInfoType(int x, int y, int px, int py, Widget widget) {
    super(x, y, widget);
    PreviousPos = new PVector(px, py);
  }
}

// ...
class MouseMovedEventInfoType extends EventInfoType {
  public PVector PreviousPos;

  public MouseMovedEventInfoType(int x, int y, int px, int py, Widget widget) {
    super(x, y, widget);
    PreviousPos = new PVector(px, py);
  }
}

// ...
class SwitchScreenEventInfoType extends EventInfoType {
  public String NewScreenId;

  public SwitchScreenEventInfoType(int x, int y, String newScreenId, Widget widget) {
    super(x, y, widget);
    NewScreenId = newScreenId;
  }
}

// ...
class MouseWheelEventInfoType extends EventInfoType {
  public int WheelCount;

  public MouseWheelEventInfoType(int x, int y, int wheelCount, Widget widget) {
    super(x, y, widget);
    WheelCount = wheelCount;
  }
}

// ...
class ListboxSelectedEntryChangedEventInfoType<T> extends EventInfoType {
  public T Data;
  public ListboxSelectedEntryChangedEventInfoType(int x, int y, T data, Widget widget) {
    super(x, y, widget);
    Data = data;
  }
}

// Descending code authorship changes:
// A. Robertson, Created an event system including all required classes, 12pm 04/03/24
// F. Wright, Modified code to fit coding standard, 6pm 04/03/24
// M. Poole, implemented MouseWheelEventInfoType class 1pm 12/03/24
