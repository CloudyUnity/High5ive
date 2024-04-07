/**
 * A. Robertson
 *
 * Represents the information associated with an event.
 */
class EventInfoType {
  public Widget Widget;
  public int X, Y;

  /**
   * A. Robertson
   *
   * Constructs an EventInfoType object with the specified coordinates and widget.
   *
   * @param x The x-coordinate of the event.
   * @param y The y-coordinate of the event.
   * @param widget The widget associated with the event.
   */
  public EventInfoType(int x, int y, Widget widget) {
    X = x;
    Y = y;
    Widget = widget;
  }
}

/**
 * A. Robertson
 *
 * Represents an event type with event handlers.
 *
 * @param <T> The type of event information associated with this event type.
 */
class EventType<T extends EventInfoType> {
  ArrayList<Consumer<T>> EventHandlers = new ArrayList<Consumer<T>>();

  /**
   * A. Robertson
   *
   * Adds an event handler to this event type.
   *
   * @param handler The event handler to add.
   */
  public void addHandler(Consumer<T> handler) {
    if (handler != null)
      EventHandlers.add(handler);
  }

  /**
   * A. Robertson
   *
   * Raises an event by invoking all registered event handlers with the provided event information.
   *
   * @param e The event information associated with the event.
   */
  public void raise(T e) {
    for (Consumer<T> handler : EventHandlers)
      handler.accept(e);
  }
}

/**
 * A. Robertson
 *
 * Represents the information associated with a string entered event, extending EventInfoType.
 */
class StringEnteredEventInfoType extends EventInfoType {
  public String Data;

  /**
   * A. Robertson
   *
   * Constructs a StringEnteredEventInfoType object with the specified coordinates, data, and widget.
   *
   * @param x The x-coordinate of the event.
   * @param y The y-coordinate of the event.
   * @param data The string data entered.
   * @param widget The widget associated with the event.
   */
  public StringEnteredEventInfoType(int x, int y, String data, Widget widget) {
    super(x, y, widget);
    Data = data;
  }
}

/**
 * A. Robertson
 *
 * Represents the information associated with a key pressed event, extending EventInfoType.
 */
class KeyPressedEventInfoType extends EventInfoType {
  public char PressedKey;
  public int PressedKeyCode;

  /**
   * A. Robertson
   *
   * Constructs a KeyPressedEventInfoType object with the specified coordinates, pressed key, pressed key code, and widget.
   *
   * @param x The x-coordinate of the event.
   * @param y The y-coordinate of the event.
   * @param k The key that was pressed.
   * @param kc The keycode of the pressed key.
   * @param widget The widget associated with the event.
   */
  public KeyPressedEventInfoType(int x, int y, char k, int kc, Widget widget) {
    super(x, y, widget);
    PressedKey = k;
    PressedKeyCode = kc;
  }
}

/**
 * A. Robertson
 *
 * Represents the information associated with a mouse dragged event, extending EventInfoType.
 */
class MouseDraggedEventInfoType extends EventInfoType {
  public PVector PreviousPos;

  /**
   * A. Robertson
   *
   * Constructs a MouseDraggedEventInfoType object with the specified coordinates, previous position, and widget.
   *
   * @param x The x-coordinate of the event.
   * @param y The y-coordinate of the event.
   * @param px The previous x-coordinate of the mouse.
   * @param py The previous y-coordinate of the mouse.
   * @param widget The widget associated with the event.
   */
  public MouseDraggedEventInfoType(int x, int y, int px, int py, Widget widget) {
    super(x, y, widget);
    PreviousPos = new PVector(px, py);
  }
}

/**
 * A. Robertson
 *
 * Represents the information associated with a mouse moved event, extending EventInfoType.
 */
class MouseMovedEventInfoType extends EventInfoType {
  public PVector PreviousPos;

  /**
   * A. Robertson
   *
   * Constructs a MouseMovedEventInfoType object with the specified coordinates, previous position, and widget.
   *
   * @param x The x-coordinate of the event.
   * @param y The y-coordinate of the event.
   * @param px The previous x-coordinate of the mouse.
   * @param py The previous y-coordinate of the mouse.
   * @param widget The widget associated with the event.
   */
  public MouseMovedEventInfoType(int x, int y, int px, int py, Widget widget) {
    super(x, y, widget);
    PreviousPos = new PVector(px, py);
  }
}

/**
 * A. Robertson
 *
 * Represents the information associated with a screen switch event, extending EventInfoType.
 */
class SwitchScreenEventInfoType extends EventInfoType {
  public String NewScreenId;

  /**
   * A. Robertson
   *
   * Constructs a SwitchScreenEventInfoType object with the specified coordinates, new screen ID, and widget.
   *
   * @param x The x-coordinate of the event.
   * @param y The y-coordinate of the event.
   * @param newScreenId The ID of the new screen.
   * @param widget The widget associated with the event.
   */
  public SwitchScreenEventInfoType(int x, int y, String newScreenId, Widget widget) {
    super(x, y, widget);
    NewScreenId = newScreenId;
  }
}

/**
 * A. Robertson
 *
 * Represents the information associated with a mouse wheel event, extending EventInfoType.
 */
class MouseWheelEventInfoType extends EventInfoType {
  public int WheelCount;

  /**
   * A. Robertson
   *
   * Constructs a MouseWheelEventInfoType object with the specified coordinates, wheel count, and widget.
   *
   * @param x The x-coordinate of the event.
   * @param y The y-coordinate of the event.
   * @param wheelCount The amount of wheel movement.
   * @param widget The widget associated with the event.
   */
  public MouseWheelEventInfoType(int x, int y, int wheelCount, Widget widget) {
    super(x, y, widget);
    WheelCount = wheelCount;
  }
}

/**
 * A. Robertson
 *
 * Represents the information associated with a listbox selected entry changed event, extending EventInfoType.
 *
 * @param <T> The type of data associated with the selected entry.
 */
class ListboxSelectedEntryChangedEventInfoType<T> extends EventInfoType {
  public T Data;

  /**
   * A. Robertson
   *
   * Constructs a ListboxSelectedEntryChangedEventInfoType object with the specified coordinates, data, and widget.
   *
   * @param x The x-coordinate of the event.
   * @param y The y-coordinate of the event.
   * @param data The data associated with the selected entry.
   * @param widget The widget associated with the event.
   */
  public ListboxSelectedEntryChangedEventInfoType(int x, int y, T data, Widget widget) {
    super(x, y, widget);
    Data = data;
  }
}

// Descending code authorship changes:
// A. Robertson, Created an event system including all required classes, 12pm 04/03/24
// F. Wright, Modified code to fit coding standard, 6pm 04/03/24
// M. Poole, implemented MouseWheelEventInfoType class 1pm 12/03/24
