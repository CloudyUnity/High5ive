/**
 * A. Robertson
 *
 * Interface for a widget that is able to be clicked.
 */
interface IClickable {
  /**
   * A. Robertson
   *
   * Gets the class's onClickEvent so that handlers can be added and it can be raised.
   *
   * @returns The onClickEvent of the class.
   */
  public EventType<EventInfoType> getOnClickEvent();
}

/**
 * A. Robertson
 *
 * Interface for a widget that is able to be dragged.
 */
interface IDraggable {
  /**
   * A. Robertson
   *
   * Gets the class's onDraggedEvent so that handlers can be added and it can be raised.
   *
   * @returns The onDraggedEvent of the class.
   */
  public EventType<MouseDraggedEventInfoType> getOnDraggedEvent();
}

/**
 * A. Robertson
 *
 * Interface for a widget that is able to handle key presses.
 */
interface IKeyInput {
  /**
   * A. Robertson
   *
   * Gets the class's onKeyPressedEvent so that handlers can be added and it can be raised.
   *
   * @returns The onKeyPressedEvent of the class.
   */
  public EventType<KeyPressedEventInfoType> getOnKeyPressedEvent();
}

/**
 * A. Robertson
 *
 * Interface for a widget that is able to handle mouse wheel events.
 */
interface IWheelInput {
  /**
   * A. Robertson
   *
   * Gets the class's onMouseWheelEvent so that handlers can be added and it can be raised.
   *
   * @returns The onMouseWheelEvent of the class.
   */
  public EventType<MouseWheelEventInfoType> getOnMouseWheelEvent();
}

/**
 * A. Robertson
 *
 * Interface for a chart widget able to display data.
 */
interface IChart<T, U> {
  /**
   * A. Robertson
   *
   * Add data to the chart. Does *not* overwrite existing data. Exists as arrays are not Iteratable.
   *
   * @param data The data to be added
   * @param getKey A lambda to get the key to be group the data by.
   */
  public void addData(T[] data, Function<T, U> getKey);

  /**
   * A. Robertson
   *
   * Add data to the chart. Does *not* overwrite existing data.
   *
   * @param data The data to be added
   * @param getKey A lambda to get the key to be group the data by.
   */
  public <I extends Iterable<T>> void addData(I data, Function<T, U> getKey);

  /**
   * A. Robertson
   *
   * Removes data
   */
  public void removeData();
}

/**
 * F. Wright
 *
 * Interface for a chart widget with 2 axis. Such as a scatter plot.
 */
interface IChart2Axis<T, U> {
  /**
   * F. Wright
   *
   * Add data to the chart. Does *not* overwrite existing data. Exists as arrays are not Iteratable.
   *
   * @param data The data to be added
   * @param getKeyX A lambda to get the key to be group the X-axis data by.
   * @param getKeyY A lambda to get the key to be group the Y-axis data by.
   */
  public void addData(T[] data, Function<T, U> getKeyX, Function<T, U> getKeyY);

  /**
   * F. Wright
   *
   * Add data to the chart. Does *not* overwrite existing data.
   *
   * @param data The data to be added
   * @param getKeyX A lambda to get the key to be group the X-axis data by.
   * @param getKeyY A lambda to get the key to be group the Y-axis data by.
   */
  public <I extends Iterable<T>> void addData(I data, Function<T, U> getKeyX, Function<T, U> getKeyY);

  /**
   * F. Wright
   *
   * Removes data
   */
  public void removeData();
}

// Descending code authorship changes:
// A. Robertson, 12pm 04/03/24
// F. Wright, Moved code into Interfaces tab from seperate tabs, 6pm 04/03/24
// A. Robertson, Added IChart<T> interface for charts, 12am 08/03/2024
// A. Robertson, Added IKeyInput for widgets accepting key presses, 11:00 11/03/2024
// F. Wright, Added IChart2Axis<T, U> for the scatter plots, 5pm 20/03/24
