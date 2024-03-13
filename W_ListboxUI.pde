class ListboxUI<T> extends Widget implements IClickable, IWheelInput {
  private Event<EventInfoType> m_onClickEvent;
  private Event<ListboxSelectedEntryChangedEventInfoType<T>> m_onSelectedEntryChangedEvent;
  private Event<MouseWheelEventInfoType> m_mouseWheelMovedEvent;
  private ArrayList<ListboxEntry<T>> m_entries;
  private Function<T, String> m_getDisplayString;
  private int m_entryHeight;
  private int m_entryWidth;
  private boolean m_scrollBar = false;
  private int m_topItem = 0;
  private int m_scrollBarColour = #ADADAD;

  public ListboxUI(int x, int y, int width, int height, int entryHeight, Function<T, String> getDisplayString) {
    super(x, y, width, height);
    m_getDisplayString = getDisplayString;
    m_onClickEvent = new Event<EventInfoType>();
    m_onSelectedEntryChangedEvent = new Event<ListboxSelectedEntryChangedEventInfoType<T>>();
    m_mouseWheelMovedEvent = new Event<MouseWheelEventInfoType>();
    m_entries = new ArrayList<ListboxEntry<T>>();
    m_entryHeight = entryHeight;
    m_entryWidth = (int)m_scale.x;
    m_onClickEvent.addHandler(e -> onClick(e));
    m_mouseWheelMovedEvent.addHandler(e -> onMouseWheelMoved(e));
  }

  @ Override
    public void draw() {
    super.draw();
    fill(m_backgroundColour);
    rect(m_pos.x, m_pos.y, m_scale.x, m_scale.y);

    textAlign(LEFT, CENTER);
    for (int i = 0; i < m_entries.size() && ((i + 1) * m_entryHeight) <= m_scale.y; i++) {
      int entry = i + m_topItem;
      fill(m_entries.get(entry).getSelected() ? m_entries.get(entry).getSelectedColour() : m_entries.get(entry).getBackgroundColour());
      rect(m_pos.x, m_pos.y + i * m_entryHeight, m_entryWidth, m_entryHeight);
      fill(m_entries.get(entry).getTextColour());
      text(m_getDisplayString.apply(m_entries.get(entry).getData()), m_pos.x, m_pos.y + i * m_entryHeight, m_entryWidth, m_entryHeight);
    }
    
    if (m_scrollBar) {
      fill(m_scrollBarColour);
      double startPercent = (double)m_topItem / (double)m_entries.size();
      int startY = (int)(startPercent * (double)m_scale.y);
      int barHeight = (int)(((double)maxNumberOfFittingEntries()/(double)m_entries.size()) * m_scale.y) - 2; // -2 to give a little space at the top.
      rect(m_pos.x + m_entryWidth + 1, m_pos.y + startY + 1, 8, barHeight, 4);
    }
  }

  public Event<EventInfoType> getOnClickEvent() {
    return m_onClickEvent;
  }

  public Event<ListboxSelectedEntryChangedEventInfoType<T>> getOnSelectedEntryChangedEvent() {
    return m_onSelectedEntryChangedEvent;
  }

  public Event<MouseWheelEventInfoType> getOnMouseWheelEvent() {
    return m_mouseWheelMovedEvent;
  }

  public void add(T entry) {
    m_entries.add(new ListboxEntry<T>(entry));
    if (!m_scrollBar && (m_entries.size() * m_entryHeight) > m_scale.y) {
      m_scrollBar = true;
      m_entryWidth = (int)m_scale.x - 10;
    }
  }

  public void remove(T entry) {
    m_entries.remove(entry);
    if (m_scrollBar && (m_entries.size() * m_entryHeight) <= m_scale.y) {
      m_scrollBar = false;
      m_entryWidth = (int)m_scale.x;
      m_topItem = 0;
    }
  }

  private void clearSelected() {
    for (var entry : m_entries) {
      entry.setSelected(false);
    }
  }

  public void removeSelected() {
    for (Iterator<ListboxEntry<T>> it = m_entries.iterator(); it.hasNext(); ) {
      ListboxEntry<T> e = it.next();
      if (e.getSelected())
        it.remove();
    }
    if (m_scrollBar && (m_entries.size() * m_entryHeight) <= m_scale.y) {
      m_scrollBar = false;
      m_entryWidth = (int)m_scale.x;
      m_topItem = 0;
    }
  }

  public void clear() {
    m_entries = new ArrayList<ListboxEntry<T>>();
    m_scrollBar = false;
    m_entryWidth = (int)m_scale.x;
    m_topItem = 0;
  }

  public T getEntry(int index) {
    ListboxEntry<T> entry = m_entries.get(index);
    if (entry == null) return null;
    return entry.getData();
  }

  public T getSelectedEntry() {
    for (var entry : m_entries) {
      if (entry.getSelected())
        return entry.getData();
    }
    return null;
  }

  public void setEntryHeight(int h) {
    m_entryHeight = h;
  }

  public void setDisplayFunction(Function<T, String> getDisplayString) {
    m_getDisplayString = getDisplayString;
  }

  private void onClick(EventInfoType e) {
    int i = (e.Y - (int)m_pos.y) / m_entryHeight + m_topItem;
    if (i < m_entries.size()) {
      clearSelected();
      ListboxEntry<T> entry = m_entries.get(i);
      if (!entry.getSelected()) {
        m_onSelectedEntryChangedEvent.raise(new ListboxSelectedEntryChangedEventInfoType<T>(e.X, e.Y, entry.getData(), this));
        entry.setSelected(true);
      }
    }
  }

  private void onMouseWheelMoved(MouseWheelEventInfoType e) {
    if (m_scrollBar) {
      if (e.wheelCount < 0 && m_topItem > 0)
        m_topItem--;
      else if (e.wheelCount > 0 && m_topItem < m_entries.size() - maxNumberOfFittingEntries())
        m_topItem++;
    }
  }
  
  private int maxNumberOfFittingEntries() {
    return (int)m_scale.y / m_entryHeight;
  }
}

class ListboxEntry<T> {
  private T m_data;
  private int m_textColour = 0;
  private int m_backgroundColour = #FFFFFF;
  private int m_selectedColour = #ADD8E6;
  private boolean m_selected = false;
  public ListboxEntry(T data) {
    m_data = data;
  }

  public T getData() {
    return m_data;
  }

  public void setTextColour(int textColour) {
    m_textColour = textColour;
  }

  public int getTextColour() {
    return m_textColour;
  }

  public void setBackgroundColour(int backgroundColour) {
    m_backgroundColour = backgroundColour;
  }

  public int getBackgroundColour() {
    return m_backgroundColour;
  }

  public void setSelected(boolean selected) {
    m_selected = selected;
  }

  public boolean getSelected() {
    return m_selected;
  }

  public void setSelectedColour(int selectedColour) {
    m_selectedColour = selectedColour;
  }

  public int getSelectedColour() {
    return m_selectedColour;
  }
}

// A. Robertson, Created listbox widget, 13:00 13/03/2024
