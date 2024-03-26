class DropdownUI<T> extends Widget implements IClickable, IWheelInput {
  private EventType<EventInfoType> m_onClickEvent;
  private EventType<MouseWheelEventInfoType> m_onMouseWheelMoved;
  private EventType<ListboxSelectedEntryChangedEventInfoType> m_onSelectionChanged;

  private Function<T, String> m_getDisplayString;

  private ListboxUI<T> m_listbox;
  private TextboxUI m_textbox;
  private ButtonUI m_dropdownButton;

  public DropdownUI(int posX, int posY, int width, int height, int entryHeight, Function<T, String> getDisplayString) {
    super(posX, posY, width, height);

    m_getDisplayString = getDisplayString;

    m_onClickEvent = new EventType<EventInfoType>();
    m_onMouseWheelMoved = new EventType<MouseWheelEventInfoType>();
    m_onSelectionChanged = new EventType<ListboxSelectedEntryChangedEventInfoType>();

    m_onMouseWheelMoved.addHandler(e -> onMouseWheelMoved(e));

    int tbHeight = Math.min((int)(m_scale.y * 0.1), 40);

    m_textbox = new TextboxUI(posX, posY, (int)(m_scale.x - tbHeight), tbHeight);
    m_dropdownButton = new ButtonUI((int)(posX + m_textbox.getScale().x), posY, (int)m_textbox.getScale().y, (int)m_textbox.getScale().y);
    m_listbox = new ListboxUI<T>((int)m_pos.x, (int)m_pos.y + (int)m_textbox.getScale().y, (int)m_scale.x, (int)(m_scale.y - m_textbox.getScale().y), entryHeight, getDisplayString);

    m_listbox.setOnlyUseNeededHeight(true);
    m_listbox.setActive(false);

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

  // Draws the dropdown
  @ Override
    public void draw() {
    super.draw();
    m_textbox.draw();
    m_dropdownButton.draw();
    if (m_listbox.getActive())
      m_listbox.draw();
  }

  // Add an item to the data
  public void add(T data) {
    m_listbox.add(data);
  }

  // Removes an item from the data
  public void remove(T data) {
    m_listbox.remove(data);
  }

  // Gets the currently selected item in the dropdown
  public T getSelected() {
    return m_listbox.getSelectedEntry();
  }

  // Gets the index of the currently selected item in the dropdown
  public int getSelectedIndex() {
    return m_listbox.getSelectedIndex();
  }

  // Returns if the point is within the bounds of
  @ Override
    public boolean isPositionInside(int mx, int my) {
    if (m_listbox.getActive()) {
      return  mx >= m_pos.x && mx <= (m_pos.x + m_scale.x) &&
        my >= m_pos.y && my <= (m_pos.y + m_textbox.getScale().y + m_listbox.shownHeight());
    } 
    
    return mx >= m_pos.x && mx <= (m_pos.x + m_scale.x) &&
        my >= m_pos.y && my <= (m_pos.y + m_textbox.getScale().y);
  }

  // Returns the click event
  public EventType<EventInfoType> getOnClickEvent() {
    return m_onClickEvent;
  }

  // Returns the mouse wheel event
  public EventType<MouseWheelEventInfoType> getOnMouseWheelEvent() {
    return m_onMouseWheelMoved;
  }

  // Returns the selection changed event
  public EventType<ListboxSelectedEntryChangedEventInfoType> getOnSelectionChanged() {
    return m_onSelectionChanged;
  }
  
  // Sets whether the dropdown is searchable
  public void setSearchable(boolean searchable) {
    if (!searchable)  
      m_listbox.removeFilter();
    m_textbox.setUserModifiable(searchable);
  }

  // Called when the dropdown button is clicked. Opens the listbox
  private void onDropdownButtonClicked(EventInfoType e) {
    if (m_listbox.getActive()) {
      closeList();
      return;
    }
    
    openList();
  }

  // Called when the listbox selection is changed
  private void onListboxSelectionChanged(ListboxSelectedEntryChangedEventInfoType<T> e) {
    m_textbox.setText(m_getDisplayString.apply(e.Data));
    closeList();
    m_onSelectionChanged.raise(e);
  }

  // Called when the listbox is clicked. Closes the listbox
  private void onListboxClick(EventInfoType e) {
    closeList();
  }

  // Called when the mouse wheel is scrolled. Scrolls the listbox
  private void onMouseWheelMoved(MouseWheelEventInfoType e) {
    if (m_listbox.isFocused() || m_listbox.isPositionInside(e.X, e.Y)) {
      e.Widget = m_listbox;
      m_listbox.getOnMouseWheelEvent().raise(e);
    }
  }
  
  // Called when the textbox text is changed. Filters the listbox
  private void textboxChanged(KeyPressedEventInfoType e) {
    TextboxUI tb = ((TextboxUI)e.Widget);
    
    if (tb.getText() == "") {
      m_listbox.removeFilter();
      return;
    } 
    
    m_listbox.filterEntries(o -> m_getDisplayString.apply(o).startsWith(tb.getText()));
  }
  
  // Called when the textbox text is entered in with the "Enter" key
  private void textboxTextEntered(StringEnteredEventInfoType e) {
    m_listbox.selectFirstShown();
  }

  // Called when the focus is lost for the dropdown. Closes the listbox
  private void onFocusLost(EventInfoType e) {
    closeList();
  }

  // Opens the listbox
  private void openList() {
    m_listbox.setActive(true);
    m_dropdownButton.setText("-");
  }

  // Closes the listbox
  private void closeList() {
    m_listbox.setActive(false);
    m_dropdownButton.setText("+");
  }
}

// A. Robertson, Dropdown widget created, 20:30 13/03/2024
