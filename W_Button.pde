class ButtonUI extends Widget implements IClickable {
  private EventType<EventInfoType> m_onClickEvent;
  private LabelUI m_label;
  private boolean m_highlightOutlineOnEnter;
  private int m_highlightedColour = #FFFFFF;
  private boolean m_highlighted = false;

  public ButtonUI(int posX, int posY, int scaleX, int scaleY) {
    super(posX, posY, scaleX, scaleY);
    m_onClickEvent = new EventType<EventInfoType>();
    m_label = new LabelUI(0, 0, 1, 1, null);
    m_label.setCentreAligned(true);
    m_label.setParent(this);
    
    m_highlightOutlineOnEnter = true;
    getOnMouseEnterEvent().addHandler(e -> m_highlighted = true);
    getOnMouseExitEvent().addHandler(e -> m_highlighted = false);
  }

  @ Override
    protected void drawOutline() {
    if (m_drawOutlineEnabled) {
      if (m_highlightOutlineOnEnter && m_highlighted)
        stroke(color(m_highlightedColour));
      else
        stroke(color(m_outlineColour));
    } else
      noStroke();
  }

  @ Override
    public void draw() {
    super.draw();

    fill(m_backgroundColour);
    rect(m_pos.x, m_pos.y, m_scale.x, m_scale.y);

    m_label.draw();
  }

  public EventType<EventInfoType> getOnClickEvent() {
    return m_onClickEvent;
  }

  public void setText(String text) {
    m_label.setText(text);
  }

  public void setHighlightOutlineOnEnter(boolean highlightOutlineOnEnter) {
    if (!highlightOutlineOnEnter)
      setOutlineColour(color(m_outlineColour));
    m_highlightOutlineOnEnter = highlightOutlineOnEnter;
  }

  public void setTextSize(int textSize) {
    m_label.setTextSize(textSize);
  }

  public void setTextXOffset(int textXOffset) {
    m_label.setTextXOffset(textXOffset);
  }

  public void setTextYOffset(int textYOffset) {
    m_label.setTextYOffset(textYOffset);
  }

  public LabelUI getLabel() {
    return m_label;
  }
}

// Code authorship:
// A. Robertson, Created button widget, 12pm 04/04/24
