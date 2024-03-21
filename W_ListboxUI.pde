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

  public ListboxUI(int x, int y, int width, int maxHeight, int entryHeight, Function<T, String> getDisplayString) {
    super(x, y, width, maxHeight);
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
    public void draw() {
    super.draw();

    if (!(m_onlyUseNeededHeight && neededHeight() == 0)) {
      fill(m_backgroundColour);
      rect(m_pos.x, m_pos.y, m_scale.x, shownHeight());
      int drawIndex = 0;

      textAlign(LEFT, CENTER);
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
      /*
      if (m_scrollBar) {
       fill(m_scrollBarColour);
       double startPercent = (double)m_topItem / (double)m_entries.size();
       int startY = (int)(startPercent * (double)m_scale.y);
       int barHeight = (int)(((double)maxNumberOfFittingEntries()/(double)m_entries.size()) * m_scale.y) - 2; // -2 to give a little space at the top.
       rect(m_pos.x + m_entryWidth + 1, m_pos.y + startY + 1, 8, barHeight, 4);
       }*/
    }
  }

  public EventType<EventInfoType> getOnClickEvent() {
    return m_onClickEvent;
  }

  public EventType<ListboxSelectedEntryChangedEventInfoType<T>> getOnSelectedEntryChangedEvent() {
    return m_onSelectedEntryChangedEvent;
  }

  public EventType<MouseWheelEventInfoType> getOnMouseWheelEvent() {
    return m_mouseWheelMovedEvent;
  }

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

  public void filterEntries(Function<T, Boolean> f) {
    for (ListboxEntry<T> entry : m_entries)
      entry.setShown(f.apply(entry.getData()));
    m_scrollbar.setNumberOfElements(getNumberOfShown());
  }

  public void removeFilter() {
    for (ListboxEntry<T> entry : m_entries)
      entry.setShown(true);
    m_scrollbar.setNumberOfElements(getNumberOfShown());
  }

  public void add(T entry) {
    m_entries.add(new ListboxEntry<T>(entry));
    m_scrollbar.setNumberOfElements(getNumberOfShown());
    if (!m_scrollbar.getActive() && (getNumberOfShown() * m_entryHeight) > m_scale.y) {
      m_scrollbar.setActive(true);
      m_scrollbar.setCurrentTop(0);
      m_entryWidth = (int)m_scale.x - 10;
    }
  }

  public void remove(T entry) {
    m_entries.remove(entry);
    m_scrollbar.setNumberOfElements(getNumberOfShown());
    if (m_scrollbar.getActive() && (getNumberOfShown() * m_entryHeight) <= m_scale.y) {
      m_scrollbar.setActive(false);
      m_entryWidth = (int)m_scale.x;
      m_scrollbar.setCurrentTop(0);
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
    m_scrollbar.setNumberOfElements(getNumberOfShown());
    if (m_scrollbar.getActive() && (getNumberOfShown() * m_entryHeight) <= m_scale.y) {
      m_scrollbar.setActive(false);
      m_entryWidth = (int)m_scale.x;
      m_scrollbar.setCurrentTop(0);
    }
  }

  public void clear() {
    m_entries = new ArrayList<ListboxEntry<T>>();
    m_scrollbar.setActive(false);
    m_scrollbar.setCurrentTop(0);
    m_scrollbar.setNumberOfElements(0);
    m_entryWidth = (int)m_scale.x;
    m_scrollbar.setCurrentTop(0);
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

  public int getSelectedIndex() {
    for (int i = 0; i < m_entries.size(); i++) {
      if (m_entries.get(i).getSelected())
        return i;
    }
    return -1;
  }

  public void setEntryHeight(int h) {
    m_entryHeight = h;
  }

  public void setDisplayFunction(Function<T, String> getDisplayString) {
    m_getDisplayString = getDisplayString;
  }

  @ Override
  public boolean isPositionInside(int mx, int my) {
    return
      mx >= m_pos.x && mx <= (m_pos.x + m_entryWidth) &&
      my >= m_pos.y && my <= (m_pos.y + shownHeight());
  }

  private void onClick(EventInfoType e) {
    int i = (e.Y - (int)m_pos.y) / m_entryHeight + m_scrollbar.getCurrentTop();
    selectEntry(i);
  }

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

  private void onMouseWheelMoved(MouseWheelEventInfoType e) {
    m_scrollbar.getOnMouseWheelEvent().raise(e);
  }
  
  private int neededHeight() {
    return m_entryHeight * m_entries.size();
  }

  public int shownHeight() {
    return m_onlyUseNeededHeight ? Math.min(neededHeight(), (int)m_scale.y) : (int)m_scale.y;
  }
  
  private int getNumberOfShown() {
    int sum = 0;
    for (var entry : m_entries)
      if (entry.getShown())
        sum++;
    return sum;
  }
}

class ListboxEntry<T> {
  private T m_data;
  private int m_textColour = 0;
  private int m_backgroundColour = #FFFFFF;
  private int m_selectedColour = #ADD8E6;
  private boolean m_selected = false;
  private boolean m_shown = true;

  public ListboxEntry(T data) {
    m_data = data;
  }

  public T getData() { //<>//
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

  public void setShown(boolean shown) {
    m_shown = shown;
  }

  public boolean getShown() {
    return m_shown;
  }
}

// A. Robertson, Created listbox widget, 13:00 13/03/2024
