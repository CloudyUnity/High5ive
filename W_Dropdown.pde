class DropdownUI<T> extends Widget implements IClickable, IWheelInput {  
  private Event<EventInfoType> m_onClickEvent;
  private Event<MouseWheelEventInfoType> m_onMouseWheelMoved;
  
  private ListboxUI<T> m_listbox;
  private TextboxUI m_textbox;
  private ButtonUI m_dropdownButton;
  private boolean m_showList = false;
  
  public DropdownUI(int posX, int posY, int width, int height) {
    super(posX, posY, width, height);
    m_onClickEvent = new Event<EventInfoType>();
    m_onMouseWheelMoved = new Event<MouseWheelEventInfoType>();
    
    m_onClickEvent.addHandler(e -> onClick(e));
    
    //m_listbox = new ListboxUI<T>();
    m_textbox = new TextboxUI(posX, posY, (int)(m_scale.x - m_scale.y * 0.1), (int)(m_scale.y * 0.1));
    m_dropdownButton = new ButtonUI((int)(posX + m_textbox.getScale().x), posY, (int)m_textbox.getScale().y, (int)m_textbox.getScale().y);
    
    m_textbox.setUserModifiable(false);
    
    m_dropdownButton.setText("+");
    
    m_textbox.getOnClickEvent().addHandler(e -> onTextboxClicked(e));
    m_dropdownButton.getOnClickEvent().addHandler(e -> onDropdownButtonClicked(e));
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
  
  @ Override
  public boolean isPositionInside(int mx, int my) {
    if (m_showList) {
      return super.isPositionInside(mx, my);
    } else {
      return mx >= m_pos.x && mx <= (m_pos.x + m_scale.x) &&
             my >= m_pos.y && my <= (m_pos.y + m_textbox.getScale().y);
    }
  }
  
  public Event<EventInfoType> getOnClickEvent() {
    return m_onClickEvent;
  }
  
  public Event<MouseWheelEventInfoType> getOnMouseWheelEvent() {
    return m_onMouseWheelMoved;
  }
  
  private void onClick(EventInfoType e) {
    if (m_textbox.isPositionInside(e.X, e.Y))
      m_textbox.getOnClickEvent().raise(new EventInfoType(e.X, e.Y, m_textbox));
    
    if (m_dropdownButton.isPositionInside(e.X, e.Y))
      m_dropdownButton.getOnClickEvent().raise(new EventInfoType(e.X, e.Y, m_dropdownButton));
  }
  
  private void onTextboxClicked(EventInfoType e) {
    if (!m_showList) {
      m_showList = true; 
    }
  }
  
  private void onDropdownButtonClicked(EventInfoType e) {
    if (m_showList) {
      m_showList = false;
      ((ButtonUI)e.Widget).setText("+");
    } else {
      m_showList = true;
      ((ButtonUI)e.Widget).setText("-");
    }
  }
}
