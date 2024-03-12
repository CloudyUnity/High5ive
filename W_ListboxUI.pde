class ListboxUI<T> extends Widget implements IClickable {
  private Event<EventInfoType> m_onClickEvent;
  private ArrayList<ListboxEntry<T>> m_entries;
  public ListboxUI(int x, int y, int width, int height) {
    super(x, y, width, height);
    m_onClickEvent = new Event<EventInfoType>();
    m_entries = new ArrayList<ListboxEntry<T>>();
  }
  
  @ Override
  public void draw() {
    super.draw();
  }
  
  public Event<EventInfoType> getOnClickEvent() {
    return m_onClickEvent;
  }
  
  public void add(T entry) {
     
  }
  
  public void remove(T entry) {
    
  }
  
  public void clear() {
    m_entries = new ArrayList<ListboxEntry<T>>();
  }
}

class ListboxEntry<T> extends Widget implements IClickable {
  private Event<EventInfoType> m_onClickEvent;
  private T m_data;
  public ListboxEntry(int x, int y, int width, int height, T data) {
    super(x, y, width, height);
    m_onClickEvent = new Event<EventInfoType>();
    m_data = data;
  }
  
  public Event<EventInfoType> getOnClickEvent() {
    return m_onClickEvent;
  }
}
