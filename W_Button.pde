/**
 * A. Robertson
 *
 * A button widget.
 *
 * @extends Widget
 * @implements IClickable
 */
class ButtonUI extends Widget implements IClickable {
  private EventType<EventInfoType> m_onClickEvent;
  private LabelUI m_label;
  private boolean m_highlightOutlineOnEnter;
  private int m_highlightedColour = DEFAULT_HIGHLIGHT_COLOR;
  private boolean m_highlighted = false;

  /**
   * A. Robertson
   *
   * Constructs a new Button widget.
   *
   * @param posX The x position of the button.
   * @param posY The y position of the button.
   * @param scaleX The width of the button.
   * @param scaleY The height of the button.
   */
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

  /**
   * A. Robertson
   *
   * Draws the outline of the button.
   */
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

  /**
   * A. Robertson
   *
   * Draws the button.
   */
  @ Override
    public void draw() {
    super.draw();

    fill(m_backgroundColour);
    rect(m_pos.x, m_pos.y, m_scale.x, m_scale.y, DEFAULT_WIDGET_ROUNDNESS_1);

    m_label.draw();
  }

  /**
   * A. Robertson
   *
   * Gets the class's onClickEvent so that handlers can be added and it can be raised.
   *
   * @returns The onClickEvent of the class.
   */
  public EventType<EventInfoType> getOnClickEvent() {
    return m_onClickEvent;
  }

  /**
   * A. Robertson
   *
   * Sets the text inside the button.
   *
   * @param text The new text to be displayed inside the button.
   */
  public void setText(String text) {
    m_label.setText(text);
  }

  /**
   * A. Robertson
   *
   * Sets whether the button's outline will be highlighted when the mouse is inside it.
   *
   * @param highlightOutlineOnEnter Whether the button's outline will be highlighted with the mouse inside.
   */
  public void setHighlightOutlineOnEnter(boolean highlightOutlineOnEnter) {
    if (!highlightOutlineOnEnter)
      setOutlineColour(color(m_outlineColour));
    m_highlightOutlineOnEnter = highlightOutlineOnEnter;
  }

  /**
   * A. Robertson
   *
   * Sets the text size of the button.
   *
   * @param textSize The new text size of the button.
   */
  public void setTextSize(int textSize) {
    m_label.setTextSize(textSize);
  }

  /**
   * A. Robertson
   *
   * Sets the number of pixels from the left side of the button that text will be drawn from.
   *
   * @param textXOffset The number of pixels from the left side blank before the text.
   */
  public void setTextXOffset(int textXOffset) {
    m_label.setTextXOffset(textXOffset);
  }

  /**
   * A. Robertson
   *
   * Sets the number of pixels from the top side of the button that text will be drawn from.
   *
   * @param textYOffset The number of pixels from the top side blank before the text.
   */
  public void setTextYOffset(int textYOffset) {
    m_label.setTextYOffset(textYOffset);
  }

  /**
   * A. Robertson
   *
   * Gets the label holding the text in the button.
   *
   * @returns The label widget the button uses for text.
   */
  public LabelUI getLabel() {
    return m_label;
  }
}

// Code authorship:
// A. Robertson, Created button widget, 12pm 04/04/24
