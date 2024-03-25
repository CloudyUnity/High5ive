class CheckboxUI extends Widget implements IClickable {
  private LabelUI m_label;
  private int m_textPadding;
  private EventType<EventInfoType> m_onClickEvent;
  private boolean m_checked;
  private color m_checkedColour = DEFAULT_CHECKBOX_CHECKED_COLOUR;

  public CheckboxUI(int posX, int posY, int scaleX, int scaleY, String label) {
    super(posX, posY, scaleX, scaleY);
    m_label = new LabelUI(posX + scaleY + m_textPadding, posY, scaleX - scaleY - m_textPadding, scaleY, label);
    m_label.setForegroundColour(DEFAULT_TEXT_COLOUR_OUTSIDE);
    m_textPadding = 5;

    m_onClickEvent = new EventType<EventInfoType>();
    m_onClickEvent.addHandler(e -> {
      m_checked = !m_checked;
    }
    );
  }

  @ Override
    public void draw() {
    super.draw();

    fill(color(m_checked ? m_checkedColour : m_backgroundColour));
    rect(m_pos.x, m_pos.y, m_scale.y, m_scale.y);

    m_label.draw();
  }

  public EventType<EventInfoType> getOnClickEvent() {
    return m_onClickEvent;
  }

  public void setCheckedColour(color checkedColour) {
    m_checkedColour = checkedColour;
  }

  public boolean getChecked() {
    return m_checked;
  }

  public void setChecked(boolean checked) {
    m_checked = checked;
  }

  public void setTextSize(int textSize) {
    m_label.setTextSize(textSize);
  }

  public void setText(String text) {
    m_label.setText(text);
  }

  public LabelUI getLabel() {
    return m_label;
  }
}

// Code authorship:
// A. Robertson, Created a checkbox widget, 12pm 04/03/24
