/**
 * A. Robertson
 *
 * A label widget to show a string of text.
 *
 * @extends Widget
 */
class LabelUI extends Widget {
  private boolean m_centreAligned;
  private String m_text = "";
  private int m_textSize, m_textXOffset, m_textYOffset;

  /**
   * A. Robertson
   *
   * Constructs a new label widget.
   *
   * @param posX The x position of the widget.
   * @param posY The y position of the widget.
   * @param scaleX The width of the widget.
   * @param scaleY The height of the widget.
   * @param text The text to be displayed.
   */
  public LabelUI(int posX, int posY, int scaleX, int scaleY, String text) {
    super(posX, posY, scaleX, scaleY);
    m_text = text;
    m_textSize = 12;
    m_textYOffset = 0;
    m_textXOffset = 5;
    m_centreAligned = false;
    m_foregroundColour = DEFAULT_TEXT_COLOUR_INSIDE;
  }

  /**
   * A. Robertson
   *
   * Draws the label widget.
   */
  @ Override
    public void draw() {
    super.draw();

    textSize(m_textSize);

    fill(color(m_foregroundColour));
    textAlign(m_centreAligned ? CENTER : LEFT, CENTER);
    text(m_text, m_pos.x + m_textXOffset, m_pos.y + m_textYOffset, m_scale.x - m_textXOffset, m_scale.y - m_textYOffset);
  }

  /**
   * A. Robertson
   *
   * Sets if the text of the label should be centre or left aligned.
   *
   * @param centreAligned If the text should be centre or left aligned.
   */
  public void setCentreAligned(boolean centreAligned) {
    m_centreAligned = centreAligned;
  }

  /**
   * A. Robertson
   *
   * Sets the text of the label.
   *
   * @param text The new text of the label
   */
  public void setText(String text) {
    m_text = text;
  }

  /**
   * A. Robertson
   *
   * Sets the size of the text.
   *
   * @param textSize Sets the size of the text in pixels.
   * @throws IllegaArgumentException when the provided text size is less than 0.
   */
  public void setTextSize(int textSize) {
    if (textSize < 0)
      throw new IllegalArgumentException("Text size cannot be less than 0.");

    m_textSize = textSize;
  }

  /**
   * A. Robertson
   *
   * Sets the offset of the text from the left hand side of the label.
   *
   * @param textXOffset The number of pixels from the left hand side for the text to be offset.
   * @throws IllegalargumentException when the provided offset is less than 0.
   */
  public void setTextXOffset(int textXOffset) {
    if (textXOffset < 0)
      throw new IllegalArgumentException("Text X offset cannot be less than 0.");

    m_textXOffset = textXOffset;
  }

  /**
   * A. Robertson
   *
   * Sets the offset of the text from the top side of the label.
   *
   * @param textXOffset The number of pixels from the top side for the text to be offset.
   * @throws IllegalargumentException when the provided offset is less than 0.
   */
  public void setTextYOffset(int textYOffset) {
    if (textYOffset < 0)
      throw new IllegalArgumentException("Text Y offset cannot be less than 0.");

    m_textYOffset = textYOffset;
  }
}

// Code authorship:
// A. Robertson, Created a label widget, 12pm 04/03/24
