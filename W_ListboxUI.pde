/**
 * A. Robertson
 *
 * Represents a UI element for displaying a list of selectable entries.
 *
 * @param <T> The type of data stored in the listbox entries.
 */


class ListboxUI<T> extends Widget implements IClickable, IWheelInput {
  private EventType<EventInfoType> m_onClickEvent;
  private EventType<ListboxSelectedEntryChangedEventInfoType<T>> m_onSelectedEntryChangedEvent;
  private EventType<MouseWheelEventInfoType> m_mouseWheelMovedEvent;
  private ArrayList<ListboxEntry<T>> m_entries;
  private Function<T, String> m_getDisplayString;
  private int m_entryHeight;
  private int m_entryWidth;
  private boolean m_onlyUseNeededHeight = false;
  private ScrollbarUI m_scrollbar;


  /**
   * A. Robertson
   *
   * Constructs a new ListboxUI instance.
   *
   * @param x              The x-coordinate of the top-left corner of the listbox.
   * @param y              The y-coordinate of the top-left corner of the listbox.
   * @param scaleX         The horizontal scale of the listbox.
   * @param maxHeight      The maximum height of the listbox.
   * @param entryHeight    The height of each entry in the listbox.
   * @param getDisplayString A function to retrieve the display string for each entry.
   */


  public ListboxUI(int x, int y, int scaleX, int maxHeight, int entryHeight, Function<T, String> getDisplayString) {
    super(x, y, scaleX, maxHeight);
    m_getDisplayString = getDisplayString;
    m_onClickEvent = new EventType<EventInfoType>();
    m_onSelectedEntryChangedEvent = new EventType<ListboxSelectedEntryChangedEventInfoType<T>>();
    m_mouseWheelMovedEvent = new EventType<MouseWheelEventInfoType>();
    m_entries = new ArrayList<ListboxEntry<T>>();
    m_entryHeight = entryHeight;
    m_entryWidth = (int)m_scale.x;
    m_scrollbar = new ScrollbarUI((int)m_pos.x + m_entryWidth - 10, (int)m_pos.y, 10, (int)m_scale.y, 0, (int)m_scale.y / entryHeight);
    m_scrollbar.setActive(false);

    m_onClickEvent.addHandler(e -> onClick(e));
    m_mouseWheelMovedEvent.addHandler(e -> onMouseWheelMoved(e));

    m_children.add(m_scrollbar);
  }

  @ Override
  /**
   * A. Robertson
   *
   * Draws the listbox and its entries.
   */

    public void draw() {
    super.draw();

    if (!(m_onlyUseNeededHeight && neededHeight() == 0)) {
      fill(m_backgroundColour);
      rect(m_pos.x, m_pos.y, m_scale.x, shownHeight());

      int drawIndex = 0;
      textAlign(LEFT, CENTER);
      textSize(15);

      for (int i = 0; i < m_entries.size() && ((drawIndex + 1) * m_entryHeight) <= m_scale.y; i++) {
        int entry = i + m_scrollbar.getCurrentTop();
        if (m_entries.get(entry).getShown()) {

          fill(m_entries.get(entry).getSelected() ? m_entries.get(entry).getSelectedColour() : m_entries.get(entry).getBackgroundColour());
          rect(m_pos.x, m_pos.y + drawIndex * m_entryHeight, m_entryWidth, m_entryHeight);

          fill(m_entries.get(entry).getTextColour());
          text(m_getDisplayString.apply(m_entries.get(entry).getData()), m_pos.x, m_pos.y + drawIndex * m_entryHeight, m_entryWidth, m_entryHeight);

          drawIndex++;
        }
      }

      if (m_scrollbar.getActive())
        m_scrollbar.draw();
    }
  }
  /**
   * A. Robertson
   *
   * Gets the event type for click events on the listbox.
   *
   * @return The event type for click events.
   */

  public EventType<EventInfoType> getOnClickEvent() {
    return m_onClickEvent;
  }
  /**
   * A. Robertson
   *
   * Gets the event type for selected entry changed events on the listbox.
   *
   * @return The event type for selected entry changed events.
   */

  public EventType<ListboxSelectedEntryChangedEventInfoType<T>> getOnSelectedEntryChangedEvent() {
    return m_onSelectedEntryChangedEvent;
  }
  /**
   * A. Robertson
   *
   * Gets the event type for mouse wheel events on the listbox.
   *
   * @return The event type for mouse wheel events.
   */

  public EventType<MouseWheelEventInfoType> getOnMouseWheelEvent() {
    return m_mouseWheelMovedEvent;
  }
  /**
   * A. Robertson
   *
   * Sets whether to use only the needed height for the listbox.
   *
   * @param onlyUseNeededHeight True to use only the needed height, false otherwise.
   */
  public void setOnlyUseNeededHeight(boolean onlyUseNeededHeight) {
    m_onlyUseNeededHeight = onlyUseNeededHeight;
  }

  // Returns true if one could be selected, false otherwise
  public boolean selectFirstShown() {
    for (int i = 0; i < m_entries.size(); i++) {
      if (m_entries.get(i).getShown()) {
        selectEntry(i);
        return true;
      }
    }
    return false;
  }

  /**
   * A. Robertson
   *
   * Filters the entries in the listbox based on the provided function.
   *
   * @param f The function used for filtering entries.
   */

  public void filterEntries(Function<T, Boolean> f) {
    for (ListboxEntry<T> entry : m_entries)
      entry.setShown(f.apply(entry.getData()));
    m_scrollbar.setNumberOfElements(getNumberOfShown());
  }

  /**
   * A. Robertson
   *
   * Removes any filters applied to the listbox entries.
   */

  public void removeFilter() {
    for (ListboxEntry<T> entry : m_entries)
      entry.setShown(true);
    m_scrollbar.setNumberOfElements(getNumberOfShown());
  }

  /**
   * A. Robertson
   *
   * Adds a new entry to the listbox.
   *
   * @param entry The entry to add.
   */
  public void add(T entry) {
    m_entries.add(new ListboxEntry<T>(entry));
    m_scrollbar.setNumberOfElements(getNumberOfShown());
    if (!m_scrollbar.getActive() && (getNumberOfShown() * m_entryHeight) > m_scale.y) {
      m_scrollbar.setActive(true);
      m_scrollbar.setCurrentTop(0);
      m_entryWidth = (int)m_scale.x - 10;
    }
  }

  /**
   * A. Robertson
   *
   * Removes the specified entry from the listbox.
   *
   * @param entry The entry to remove.
   */

  public void remove(T entry) {
    m_entries.remove(entry);
    m_scrollbar.setNumberOfElements(getNumberOfShown());
    if (m_scrollbar.getActive() && (getNumberOfShown() * m_entryHeight) <= m_scale.y) {
      m_scrollbar.setActive(false);
      m_entryWidth = (int)m_scale.x;
      m_scrollbar.setCurrentTop(0);
    }
  }
  /**
   
   * A. Robertson
   *
   * Removes the entry at the specified index from the listbox.
   *
   * @param index The index of the entry to remove.
   */


  public void removeAt(int index) {
    m_entries.remove(index);
    m_scrollbar.setNumberOfElements(getNumberOfShown());
    if (m_scrollbar.getActive() && (getNumberOfShown() * m_entryHeight) <= m_scale.y) {
      m_scrollbar.setActive(false);
      m_entryWidth = (int)m_scale.x;
      m_scrollbar.setCurrentTop(0);
    }
  }

  /**
   * A. Robertson
   *
   * Clears all selected entries from the listbox.
   */

  private void clearSelected() {
    for (var entry : m_entries) {
      entry.setSelected(false);
    }
  }

  /**
   * A. Robertson
   *
   * Removes all selected entries from the listbox.
   */
  public void removeSelected() {
    for (Iterator<ListboxEntry<T>> it = m_entries.iterator(); it.hasNext(); ) {
      ListboxEntry<T> e = it.next();
      if (e.getSelected())
        it.remove();
    }
    m_scrollbar.setNumberOfElements(getNumberOfShown());
    if (m_scrollbar.getActive() && (getNumberOfShown() * m_entryHeight) <= m_scale.y) {
      m_scrollbar.setActive(false);
      m_entryWidth = (int)m_scale.x;
      m_scrollbar.setCurrentTop(0);
    }
  }

  /**
   * A. Robertson
   *
   * Removes all selected entries from the listbox.
   */

  public void clear() {
    m_entries = new ArrayList<ListboxEntry<T>>();
    m_scrollbar.setActive(false);
    m_scrollbar.setCurrentTop(0);
    m_scrollbar.setNumberOfElements(0);
    m_entryWidth = (int)m_scale.x;
    m_scrollbar.setCurrentTop(0);
  }

  /**
   * A. Robertson
   *
   * Gets the data of the entry at the specified index in the listbox.
   *
   * @param index The index of the entry.
   * @return The data of the entry.
   */

  public T getEntry(int index) {
    ListboxEntry<T> entry = m_entries.get(index);
    if (entry == null) return null;
    return entry.getData();
  }
  /**
   * A. Robertson
   *
   * Gets the data of the currently selected entry in the listbox.
   *
   * @return The data of the selected entry.
   */

  public T getSelectedEntry() {
    for (var entry : m_entries) {
      if (entry.getSelected())
        return entry.getData();
    }
    return null;
  }
  /**
   * A. Robertson
   *
   * Gets the index of the currently selected entry in the listbox.
   *
   * @return The index of the selected entry.
   */

  public int getSelectedIndex() {
    for (int i = 0; i < m_entries.size(); i++) {
      if (m_entries.get(i).getSelected())
        return i;
    }
    return -1;
  }
  /**
   * A. Robertson
   *
   * Sets the height of each entry in the listbox.
   *
   * @param h The height of each entry.
   */

  public void setEntryHeight(int h) {
    m_entryHeight = h;
  }
  /**
   * A. Robertson
   *
   * Sets the function used to retrieve the display string for entries in the listbox.
   *
   * @param getDisplayString The function to retrieve display strings.
   */

  public void setDisplayFunction(Function<T, String> getDisplayString) {
    m_getDisplayString = getDisplayString;
  }

  @ Override
  /**
   * A. Robertson
   *
   * Checks if the specified position is inside the listbox.
   *
   * @param mx The x-coordinate.
   * @param my The y-coordinate.
   * @return True if the position is inside the listbox, false otherwise.
   */

    public boolean isPositionInside(int mx, int my) {
    return
      mx >= m_pos.x && mx <= (m_pos.x + m_entryWidth) &&
      my >= m_pos.y && my <= (m_pos.y + shownHeight());
  }
/**
 * A. Robertson
 * 
 * Handles the click event on the listbox.
 *
 * @param e The event information.
 */

  private void onClick(EventInfoType e) {
    int i = (e.Y - (int)m_pos.y) / m_entryHeight + m_scrollbar.getCurrentTop();
    selectEntry(i);
  }
/**
 * A. Robertson
 * 
 * Selects the entry at the specified index.
 *
 * @param index The index of the entry to select.
 */

  private void selectEntry(int index) {
    if (index < m_entries.size()) {
      clearSelected();
      ListboxEntry<T> entry = m_entries.get(index);
      if (!entry.getSelected()) {
        m_onSelectedEntryChangedEvent.raise(new ListboxSelectedEntryChangedEventInfoType<T>(0, 0, entry.getData(), this));
        entry.setSelected(true);
      }
    }
  }
/**
 * A. Robertson
 * 
 * Handles the mouse wheel movement event.
 *
 * @param e The mouse wheel event information.
 */

  private void onMouseWheelMoved(MouseWheelEventInfoType e) {
    m_scrollbar.getOnMouseWheelEvent().raise(e);
  }
/**
 * A. Robertson
 * 
 * Calculates the total height needed to display all entries.
 *
 * @return The total height needed.
 */

  private int neededHeight() {
    return m_entryHeight * m_entries.size();
  }
/**
 * A. Robertson
 * 
 * Calculates the height of the listbox that should be shown.
 *
 * @return The height of the listbox to be shown.
 */

  public int shownHeight() {
    return m_onlyUseNeededHeight ? Math.min(neededHeight(), (int)m_scale.y) : (int)m_scale.y;
  }
/**
 * A. Robertson
 * 
 * Gets the number of entries that are currently shown.
 *
 * @return The number of shown entries.
 */

  private int getNumberOfShown() {
    int sum = 0;
    for (var entry : m_entries)
      if (entry.getShown())
        sum++;
    return sum;
  }
}

/**
 * A. Robertson
 *
 * Represents an entry in the listbox.
 *
 * @param <T> The type of data stored in the entry.
 */

class ListboxEntry<T> {
  private T m_data;
  private int m_textColour = 0;
  private int m_backgroundColour = #FFFFFF;
  private int m_selectedColour = #ADD8E6;
  private boolean m_selected = false;
  private boolean m_shown = true;

  /**
   * A. Robertson
   *
   * Constructs a new ListboxEntry instance with the specified data.
   *
   * @param data The data of the entry.
   */

  public ListboxEntry(T data) {
    m_data = data;
  }

  /**
   * A. Robertson
   *
   * Gets the data of the entry.
   *
   * @return The data of the entry.
   */

  public T getData() {
    return m_data;
  }
  /**
   * A. Robertson
   *
   * Sets the text color of the entry.
   *
   * @param textColour The text color to set.
   */

  public void setTextColour(int textColour) {
    m_textColour = textColour;
  }
  /**
   * A. Robertson
   *
   * Gets the text color of the entry.
   *
   * @return The text color of the entry.
   */

  public int getTextColour() {
    return m_textColour;
  }
  /**
   * A. Robertson
   *
   * Sets the background color of the entry.
   *
   * @param backgroundColour The background color to set.
   */

  public void setBackgroundColour(int backgroundColour) {
    m_backgroundColour = backgroundColour;
  }
  /**
   * A. Robertson
   *
   * Gets the background color of the entry.
   *
   * @return The background color of the entry.
   */

  public int getBackgroundColour() {
    return m_backgroundColour;
  }
  /**
   * A. Robertson
   *
   * Gets the background color of the entry.
   *
   * @return The background color of the entry.
   */

  public void setSelected(boolean selected) {
    m_selected = selected;
  }
  /**
   * A. Robertson
   *
   * Sets whether the entry is selected.
   *
   * @param selected True to set the entry as selected, false otherwise.
   */

  public boolean getSelected() {
    return m_selected;
  }
  /**
   * A. Robertson
   *
   * Sets the selected color of the entry.
   *
   * @param selectedColour The selected color to set.
   */


  public void setSelectedColour(int selectedColour) {
    m_selectedColour = selectedColour;
  }
  /**
   * A. Robertson
   *
   * Gets the selected color of the entry.
   *
   * @return The selected color of the entry.
   */

  public int getSelectedColour() {
    return m_selectedColour;
  }
  /**
   * A. Robertson
   *
   * Sets whether the entry is shown.
   *
   * @param shown True to show the entry, false to hide it.
   */

  public void setShown(boolean shown) {
    m_shown = shown;
  }
  /**
   * A. Robertson
   *
   * Checks if the entry is shown.
   *
   * @return True if the entry is shown, false otherwise.
   */

  public boolean getShown() {
    return m_shown;
  }
}

// A. Robertson, Created listbox widget, 13:00 13/03/2024
