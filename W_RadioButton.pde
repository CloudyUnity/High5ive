class RadioButtonGroupTypeUI extends WidgetGroupType {
  public RadioButtonGroupTypeUI() {
    super();
  }

  public void addMember(RadioButtonUI rb) {
    Members.add(rb);
    rb.getOnClickEvent().addHandler(e -> memberClicked(e));
  }

  private void memberClicked(EventInfoType e) {
    for (Widget member : Members) {
      RadioButtonUI rb = (RadioButtonUI)member;

      if (rb != e.Widget) {
        rb.setChecked(false);
      }
    }
  }
}

class RadioButtonUI extends Widget implements IClickable {
  private EventType<EventInfoType> m_onClickEvent;
  private EventType<EventInfoType> m_onCheckedEvent;
  private LabelUI m_label;
  private boolean m_checked;
  private boolean m_uncheckable;
  private color m_checkedColour = DEFAULT_RADIOBUTTON_CHECKED_COLOUR;

  public RadioButtonUI(int posX, int posY, int scaleX, int scaleY, String label) {
    super(posX, posY, scaleX, scaleY);
    m_label = new LabelUI(posX + scaleY, posY, scaleX - scaleY, scaleY, label);
    m_label.setForegroundColour(DEFAULT_TEXT_COLOUR_OUTSIDE);

    m_onCheckedEvent = new EventType<EventInfoType>();
    m_onClickEvent = new EventType<EventInfoType>();

    m_onClickEvent.addHandler(e -> {
      RadioButtonUI box = (RadioButtonUI)e.Widget;
      if (!box.getChecked()) {
        m_onCheckedEvent.raise(e);
        box.setChecked(true);
      } else if (m_uncheckable) {
         box.setChecked(false);
      } else {
        box.setChecked(true);
      }
    }
    );
  }

  @ Override
    public void draw() {
    super.draw();

    ellipseMode(RADIUS);
    fill(color(m_checked ? m_checkedColour : m_backgroundColour));
    circle(m_pos.x + m_scale.y / 2, m_pos.y + m_scale.y / 2, m_scale.y / 2);

    m_label.draw();
  }

  public EventType<EventInfoType> getOnClickEvent() {
    return m_onClickEvent;
  }

  public EventType<EventInfoType> getOnCheckedEvent() {
    return m_onCheckedEvent;
  }
  
  public void setUncheckable(boolean uncheckable) {
    m_uncheckable = uncheckable;
  }

  public void check() {
    m_onClickEvent.raise(new EventInfoType((int)m_pos.x, (int)m_pos.y, this));
  }

  public void setChecked(boolean checked) {
    m_checked = checked;
  }

  public boolean getChecked() {
    return m_checked;
  }

  public void setText(String text) {
    m_label.setText(text);
  }

  /**
   * Sets the button text size.
   *
   * @param  textSize The size of the text.
   * @throws IllegalArgumentException when the size argument is negative.
   **/
  public void setTextSize(int textSize) {
    m_label.setTextSize(textSize);
  }

  public LabelUI getLabel() {
    return m_label;
  }
}

// Code authorship
// A. Robertson, Created a radiobutton widget, 12pm 04/03/24
