class DropdownUI<T> extends Widget implements IClickable, IWheelInput {
  private EventType<EventInfoType> m_onClickEvent;
  private EventType<MouseWheelEventInfoType> m_onMouseWheelMoved;
  private EventType<ListboxSelectedEntryChangedEventInfoType> m_onSelectionChanged;

  private Function<T, String> m_getDisplayString;

  private ListboxUI<T> m_listbox;
  private TextboxUI m_textbox;
  private ButtonUI m_dropdownButton;
  private boolean m_showList = false;

  public DropdownUI(int posX, int posY, int width, int height, int entryHeight, Function<T, String> getDisplayString) {
    super(posX, posY, width, height);

    m_getDisplayString = getDisplayString;

    m_onClickEvent = new EventType<EventInfoType>();
    m_onMouseWheelMoved = new EventType<MouseWheelEventInfoType>();
    m_onSelectionChanged = new EventType<ListboxSelectedEntryChangedEventInfoType>();

    m_onClickEvent.addHandler(e -> onClick(e));
    m_onMouseWheelMoved.addHandler(e -> onMouseWheelMoved(e));

    int tbHeight = Math.min((int)(m_scale.y * 0.1), 40);

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
    
    m_children.add(m_listbox);
    m_children.add(m_textbox);
    m_children.add(m_dropdownButton);
  }

  @ Override
    public void draw() {
    super.draw();
    m_textbox.draw();
    m_dropdownButton.draw();
    if (m_showList)
      m_listbox.draw();
  }

  public void add(T data) {
    m_listbox.add(data);
  }

  public void remove(T data) {
    m_listbox.remove(data);
  }

  public T getSelected() {
    return m_listbox.getSelectedEntry();
  }

  public int getSelectedIndex() {
    return m_listbox.getSelectedIndex();
  }

  @ Override
    public boolean isPositionInside(int mx, int my) {
    if (m_showList) {
      return  mx >= m_pos.x && mx <= (m_pos.x + m_scale.x) &&
        my >= m_pos.y && my <= (m_pos.y + m_textbox.getScale().y + m_listbox.shownHeight());
    } else {
      return mx >= m_pos.x && mx <= (m_pos.x + m_scale.x) &&
        my >= m_pos.y && my <= (m_pos.y + m_textbox.getScale().y);
    }
  }

  public EventType<EventInfoType> getOnClickEvent() {
    return m_onClickEvent;
  }

  public EventType<MouseWheelEventInfoType> getOnMouseWheelEvent() {
    return m_onMouseWheelMoved;
  }

  public EventType<ListboxSelectedEntryChangedEventInfoType> getOnSelectionChanged() {
    return m_onSelectionChanged;
  }

  private void onClick(EventInfoType e) {
    /*
    if (m_textbox.isPositionInside(e.X, e.Y))
      m_textbox.getOnClickEvent().raise(new EventInfoType(e.X, e.Y, m_textbox));

    if (m_dropdownButton.isPositionInside(e.X, e.Y))
      m_dropdownButton.getOnClickEvent().raise(new EventInfoType(e.X, e.Y, m_dropdownButton));

    if (m_listbox.isPositionInside(e.X, e.Y))
      m_listbox.getOnClickEvent().raise(new EventInfoType(e.X, e.Y, m_listbox));*/
  }

  private void onDropdownButtonClicked(EventInfoType e) {
    if (m_showList) {
      closeList();
    } else {
      openList();
    }
  }

  private void onListboxSelectionChanged(ListboxSelectedEntryChangedEventInfoType<T> e) {
    m_textbox.setText(m_getDisplayString.apply(e.data));
    closeList();
    m_onSelectionChanged.raise(e);
  }

  private void onListboxClick(EventInfoType e) {
    closeList();
  }

  private void onMouseWheelMoved(MouseWheelEventInfoType e) {
    if (m_listbox.isFocused() || m_listbox.isPositionInside(e.X, e.Y)) {
      e.Widget = m_listbox;
      m_listbox.getOnMouseWheelEvent().raise(e);
    }
  }

  private void onFocusLost(EventInfoType e) {
    closeList();
  }

  private void openList() {
    m_showList = true;
    m_dropdownButton.setText("-");
  }

  private void closeList() {
    m_showList = false;
    m_dropdownButton.setText("+");
  }
}

// A. Robertson, Dropdown widget created, 20:30 13/03/2024
