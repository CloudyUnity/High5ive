/**
 * A. Robertson
 *
 * Dropdown widget which can be used to display and select from a list of options.
 *
 * @extends Widget
 * @implements IClickable
 * @implements IWheelInpput
 */
class DropdownUI<T> extends Widget implements IClickable, IWheelInput {
  private EventType<EventInfoType> m_onClickEvent;
  private EventType<MouseWheelEventInfoType> m_onMouseWheelMoved;
  private EventType<ListboxSelectedEntryChangedEventInfoType> m_onSelectionChanged;

  private Function<T, String> m_getDisplayString;

  private ListboxUI<T> m_listbox;
  private TextboxUI m_textbox;
  private ButtonUI m_dropdownButton;

  /**
   * A. Robertson
   *
   * Creates a dropdown widget.
   *
   * @param posX The x position of the widget.
   * @param posY The y position of the widget.
   * @param width The width of the widget.
   * @param height The height of the widget.
   * @param entryHeight The height of each individual entry in the drop down menu.
   * @param getDisplayString A lambda to convert each individual menu item into a string to be displayed.
   */
  public DropdownUI(int posX, int posY, int scaleX, int scaleY, int entryHeight, Function<T, String> getDisplayString) {
    super(posX, posY, scaleX, scaleY);

    m_getDisplayString = getDisplayString;

    m_onClickEvent = new EventType<EventInfoType>();
    m_onMouseWheelMoved = new EventType<MouseWheelEventInfoType>();
    m_onSelectionChanged = new EventType<ListboxSelectedEntryChangedEventInfoType>();

    m_onMouseWheelMoved.addHandler(e -> onMouseWheelMoved(e));

    int tbHeight = Math.max((int)(m_scale.y * 0.1), 40);

    m_textbox = new TextboxUI(posX, posY, (int)(m_scale.x - tbHeight), tbHeight);    
    m_dropdownButton = new ButtonUI((int)(posX + m_textbox.getScale().x), posY, (int)m_textbox.getScale().y, (int)m_textbox.getScale().y);    
    m_listbox = new ListboxUI<T>((int)m_pos.x, (int)m_pos.y + (int)m_textbox.getScale().y, (int)m_scale.x, (int)(m_scale.y - m_textbox.getScale().y), entryHeight, getDisplayString);
    m_listbox.setOnlyUseNeededHeight(true);

    m_textbox.setUserModifiable(false);

    m_dropdownButton.setText("+");

    m_dropdownButton.getOnClickEvent().addHandler(e -> onDropdownButtonClicked(e));
    m_listbox.getOnClickEvent().addHandler(e -> onListboxClick(e));
    m_listbox.getOnSelectedEntryChangedEvent().addHandler(e -> onListboxSelectionChanged(e));
    m_onFocusLostEvent.addHandler(e -> onFocusLost(e));
    m_textbox.getOnKeyPressedEvent().addHandler(e -> textboxChanged(e));
    m_textbox.getOnStringEnteredEvent().addHandler(e -> textboxTextEntered(e));
    m_textbox.getOnClickEvent().addHandler(e -> openList());

    m_children.add(m_listbox);
    m_children.add(m_textbox);
    m_children.add(m_dropdownButton);
  }

  /**
   * A. Robertson
   *
   * Draws the dropdown widget.
   */
  @ Override
    public void draw() {
    super.draw();
    m_textbox.draw();
    m_dropdownButton.draw();
    if (m_listbox.getActive())
      m_listbox.draw();
  }

  /**
   * A. Robertson
   *
   * Adds a menu item to the dropdown.
   *
   * @param data The menu item to be added.
   */
  public void add(T data) {
    m_listbox.add(data);
  }

  /**
   * A. Robertson
   *
   * Removes an item from the dropdown menu.
   * @param data The item to be removed.
   */
  public void remove(T data) {
    m_listbox.remove(data);
  }

  /**
   * A. Robertson
   *
   * Gets the selected entry in the menu box.
   *
   * @returns The selected item in the menu.
   */
  public T getSelected() {
    return m_listbox.getSelectedEntry();
  }

  /**
   * A. Robertson
   *
   * Gets the index of the selected entry in the menu box.
   *
   * @returns The index of the selected item. -1 if no item is selected.
   */
  public int getSelectedIndex() {
    return m_listbox.getSelectedIndex();
  }

  /**
   * A. Robertson
   *
   * An override of the Widget.isPositionInside method to ensure that it adapts to the box
   * being hidden or shown.
   *
   * @param mx The x component of the position to be checked.
   * @param my The y component of the position to be checked.
   * @returns Whether the given position is inside the widget.
   */
  @ Override
    public boolean isPositionInside(int mx, int my) {
    if (m_listbox.getActive()) {
      return  mx >= m_pos.x && mx <= (m_pos.x + m_scale.x) &&
        my >= m_pos.y && my <= (m_pos.y + m_textbox.getScale().y + m_listbox.shownHeight());
    }

    return mx >= m_pos.x && mx <= (m_pos.x + m_scale.x) &&
      my >= m_pos.y && my <= (m_pos.y + m_textbox.getScale().y);
  }

  /**
   * A. Robertson
   *
   * Gets the class's onClickEvent so that handlers can be added and it can be raised.
   *
   * @returns The onClickEvent of the class.
   */
  public EventType<EventInfoType> getOnClickEvent() {
    return m_onClickEvent;
  }

  /**
   * A. Robertson
   *
   * Gets the class's onMouseWheelEvent so that handlers can be added and it can be raised.
   *
   * @returns The onMouseWheelEvent of the class.
   */
  public EventType<MouseWheelEventInfoType> getOnMouseWheelEvent() {
    return m_onMouseWheelMoved;
  }

  /**
   * A. Robertson
   *
   * Gets the onSelectionChangedEvent, which is raised when the selected item is changed.
   *
   * @returns The onSelectionChangedEvent.
   */
  public EventType<ListboxSelectedEntryChangedEventInfoType> getOnSelectionChanged() {
    return m_onSelectionChanged;
  }

  /**
   * A. Robertson
   *
   * Sets if the textbox of the dropdown menu is searchable.
   *
   * @param searchable Whether the dropdown is searchable.
   */
  public void setSearchable(boolean searchable) {
    if (!searchable)
      m_listbox.removeFilter();
    m_textbox.setUserModifiable(searchable);
  }

  /**
   * A. Robertson
   *
   * An event handler for the dropdown button clicked event.
   *
   * @param e The event info from the button click event.
   */
  private void onDropdownButtonClicked(EventInfoType e) {
    if (m_listbox.getActive()) {
      closeList();
      return;
    }

    openList();
  }

  /**
   * A. Robertson
   *
   * An event handler for the listbox selection changed.
   *
   * @param e The event info from the selection changed event.
   */
  private void onListboxSelectionChanged(ListboxSelectedEntryChangedEventInfoType<T> e) {
    m_textbox.setText(m_getDisplayString.apply(e.Data));
    closeList();
    m_onSelectionChanged.raise(e);
  }

  /**
   * A. Robertson
   *
   * An event handler for when the menu is clicked.
   *
   * @param e The event info from the click event.
   */
  private void onListboxClick(EventInfoType e) {
    closeList();
  }

  /**
   * A. Robertson
   *
   * An event handler for when the mouse wheel is moved.
   *
   * @param e The event info from the mouse wheel moved event.
   */
  private void onMouseWheelMoved(MouseWheelEventInfoType e) {
    if (m_listbox.isFocused() || m_listbox.isPositionInside(e.X, e.Y)) {
      e.Widget = m_listbox;
      m_listbox.getOnMouseWheelEvent().raise(e);
    }
  }

  /**
   * A. Robertson
   *
   * An event handler for the textbox text changing.
   *
   * @param e The event info from the textbox text changing.
   */
  private void textboxChanged(KeyPressedEventInfoType e) {
    TextboxUI tb = ((TextboxUI)e.Widget);

    if (tb.getText() == "") {
      m_listbox.removeFilter();
      return;
    }

    m_listbox.filterEntries(o -> m_getDisplayString.apply(o).startsWith(tb.getText()));
  }

  /**
   * A. Robertson
   *
   * An event handler for when the text box text is entered.
   *
   * @param e The event info from the string being entered.
   */
  private void textboxTextEntered(StringEnteredEventInfoType e) {
    m_listbox.selectFirstShown();
  }

  /**
   * A. Robertson
   *
   * An event handler for when the focus is lost. Closes the list of items.
   *
   * @param e The event info from the on focus lost event.
   */
  private void onFocusLost(EventInfoType e) {
    closeList();
  }

  /**
   * A. Robertson
   *
   * Opens the list of items for the dropdown.
   */
  private void openList() {
    m_listbox.setActive(true);
    m_dropdownButton.setText("-");
  }

  /**
   * A. Robertson
   *
   * Closes the list of items for the dropdown.
   */
  private void closeList() {
    m_listbox.setActive(false);
    m_dropdownButton.setText("+");
  } 
  
   @Override
  public void setParent(Widget parent){
    super.setParent(parent);
    m_textbox.setParent(parent);
    m_dropdownButton.setParent(parent);
    m_listbox.setParent(parent);
  }
  
  public void setTextboxText(String text){
    m_textbox.setText(text);
  }
}

// A. Robertson, Dropdown widget created, 20:30 13/03/2024
