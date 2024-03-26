class ButtonUI extends Widget implements IClickable {
  private EventType<EventInfoType> m_onClickEvent;
  private LabelUI m_label;
  private boolean m_highlightOutlineOnEnter;
  private int m_highlightedColour = DEFAULT_HIGHLIGHT_COLOR;
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

  // Draws the buttons outline
  @ Override
    protected void drawOutline() {
    if (m_drawOutlineEnabled) {
      strokeWeight(DEFAULT_WIDGET_STROKE);
      if (m_highlightOutlineOnEnter && m_highlighted)
        stroke(color(m_highlightedColour));
      else
        stroke(color(m_outlineColour));
    } else
      noStroke();
  }

  // Draws the button and its text
  @ Override
    public void draw() {
    super.draw();

    fill(m_backgroundColour);
    rect(m_pos.x, m_pos.y, m_scale.x, m_scale.y, DEFAULT_WIDGET_ROUNDNESS_1);

    m_label.draw();
  }

  // Returns click event
  public EventType<EventInfoType> getOnClickEvent() {
    return m_onClickEvent;
  }

  // Sets the button text
  public void setText(String text) {
    m_label.setText(text);
  }

  // Highlights buttons outline when mouse is hovering over it
  public void setHighlightOutlineOnEnter(boolean highlightOutlineOnEnter) {
    if (!highlightOutlineOnEnter)
      setOutlineColour(color(m_outlineColour));
    m_highlightOutlineOnEnter = highlightOutlineOnEnter;
  }

  // Sets the text size
  public void setTextSize(int textSize) {
    m_label.setTextSize(textSize);
  }

  // Sets text X offset
  public void setTextXOffset(int textXOffset) {
    m_label.setTextXOffset(textXOffset);
  }

  // Sets text Y offset
  public void setTextYOffset(int textYOffset) {
    m_label.setTextYOffset(textYOffset);
  }

  // Returns the buttons label
  public LabelUI getLabel() {
    return m_label;
  }
}

// Code authorship:
// A. Robertson, Created button widget, 12pm 04/04/24
