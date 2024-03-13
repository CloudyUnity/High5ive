class ListboxUI<T> extends Widget implements IClickable {
  private Event<EventInfoType> m_onClickEvent;
  private ArrayList<ListboxEntry<T>> m_entries;
  private Function<T, String> m_getDisplayString;
  private int m_entryHeight;

  public ListboxUI(int x, int y, int width, int height, int entryHeight, Function<T, String> getDisplayString) {
    super(x, y, width, height);
    m_getDisplayString = getDisplayString;
    m_onClickEvent = new Event<EventInfoType>();
    m_entries = new ArrayList<ListboxEntry<T>>();
    m_entryHeight = entryHeight;
    m_onClickEvent.addHandler(e -> onClick(e));
  }

  @ Override
    public void draw() {
    super.draw();
    fill(m_backgroundColour);
    rect(m_pos.x, m_pos.y, m_scale.x, m_scale.y);

    // Handle scrolling and out of bounds
    textAlign(LEFT, CENTER);
    for (int i = 0; i < m_entries.size(); i++) {
      fill(m_entries.get(i).getSelected() ? m_entries.get(i).getSelectedColour() : m_entries.get(i).getBackgroundColour());
      rect(m_pos.x, m_pos.y + i * m_entryHeight, m_scale.x, m_entryHeight);
      fill(m_entries.get(i).getTextColour());
      text(m_getDisplayString.apply(m_entries.get(i).getData()), m_pos.x, m_pos.y + i * m_entryHeight, m_scale.x, m_entryHeight);
    }
  }

  public Event<EventInfoType> getOnClickEvent() {
    return m_onClickEvent;
  }

  public void add(T entry) {
    m_entries.add(new ListboxEntry<T>(entry));
  }

  public void remove(T entry) {
    m_entries.remove(entry);
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

  public void clear() {
    m_entries = new ArrayList<ListboxEntry<T>>();
  }

  private void onClick(EventInfoType e) {
    int i = (e.Y - (int)m_pos.y) / m_entryHeight;
    if (i < m_entries.size()) {
      clearSelected();
      ListboxEntry entry = m_entries.get(i);
      entry.setSelected(true);
    }
  }
  
  private void clearSelected() {
    for (var entry : m_entries) {
      entry.setSelected(false);
    }
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
