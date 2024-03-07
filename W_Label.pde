import java.util.function.Function;
import java.util.TreeMap;
import java.util.Map;
import java.util.function.Consumer;

class LabelUI extends Widget {
  private boolean m_centreAligned;
  private String m_text; // Can be null
  private int m_textSize, m_textXOffset, m_textYOffset;

  public LabelUI(int posX, int posY, int scaleX, int scaleY, String text) {
    super(posX, posY, scaleX, scaleY);
    m_text = text;
    m_textSize = 12;
    m_textYOffset = 0;
    m_textXOffset = 5;
    m_centreAligned = false;
  }

  @ Override
    public void draw() {
    super.draw();

    if (m_text == null)
      return;

    textSize(m_textSize);

    fill(color(m_foregroundColour));
    textAlign(m_centreAligned ? CENTER : LEFT, CENTER);
    text(m_text, m_pos.x + m_textXOffset, m_pos.y + m_textYOffset, m_scale.x - m_textXOffset, m_scale.y - m_textYOffset);
  }

  public void setCentreAligned(boolean centreAligned) {
    m_centreAligned = centreAligned;
  }

  public void setText(String text) {
    m_text = text;
  }

  /**
   * Sets the button text size.
   *
   * @param  textSize The size of the text.
   * @throws IllegalArgumentException when the size argument is negative.
   **/
  public void setTextSize(int textSize) {
    if (textSize < 0)
      throw new IllegalArgumentException("Text size cannot be less than 0.");

    m_textSize = textSize;
  }

  /**
   * Sets the button text offset from the left edge if not centred.
   *
   * @param  textXOffset The offset from the left edge of the button.
   * @throws IllegalArgumentException when the textXOffset argument is negative.
   **/
  public void setTextXOffset(int textXOffset) {
    if (textXOffset < 0)
      throw new IllegalArgumentException("Text X offset cannot be less than 0.");

    m_textXOffset = textXOffset;
  }

  /**
   * Sets the button text offset from the top edge if not centred.
   *
   * @param  textXOffset The offset from the left edge of the button.
   * @throws IllegalArgumentException when the textXOffset argument is negative.
   **/
  public void setTextYOffset(int textYOffset) {
    if (textYOffset < 0)
      throw new IllegalArgumentException("Text Y offset cannot be less than 0.");

    m_textYOffset = textYOffset;
  }
}

// Code authorship:
// A. Robertson, Created a label widget, 12pm 04/03/24
