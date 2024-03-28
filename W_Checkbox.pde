/**
 * A. Robertson
 *
 * A checkbox widget which can display a label and either be checked or unchecked.
 *
 * @extends Widget
 * @implements IClickable
 */
class CheckboxUI extends Widget implements IClickable {
  private LabelUI m_label;
  private int m_textPadding;
  private EventType<EventInfoType> m_onClickEvent;
  private boolean m_checked;
  private color m_checkedColour = DEFAULT_CHECKBOX_CHECKED_COLOUR;

  /**
   * A. Robertson
   *
   * Creates a new checkbox widget.
   *
   * @param posX The x position of the checkbox.
   * @param posY The y position of the checkbox.
   * @param scaleX The width of the checkbox.
   * @param scaleY The height of the checkbox.
   * @param label The label to be displayed beside the checkbox.
   */
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

  /**
   * A. Robertson
   *
   * Draws the checkbox widget.
   */
  @ Override
  public void draw() {
    super.draw();

    fill(color(m_checked ? m_checkedColour : m_backgroundColour));
    rect(m_pos.x, m_pos.y, m_scale.y, m_scale.y);

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
   * Sets the checked colour, the colour to fill the box with when it's checked.
   *
   * @param checkedColour The new checked colour.
   */
  public void setCheckedColour(color checkedColour) {
    m_checkedColour = checkedColour;
  }

  /**
   * A. Robertson
   *
   * Gets if the box is checked.
   *
   * @returns If the box is checked.
   */
  public boolean getChecked() {
    return m_checked;
  }

  /**
   * A. Robertson
   *
   * Sets if the box is checked or not.
   *
   * @param checked If the box is to be checked or unchecked.
   */
  public void setChecked(boolean checked) {
    m_checked = checked;
  }

  /**
   * A. Robertson
   *
   * Sets the text size of the label beside the box.
   *
   * @param textSize The new textsize of the label.
   */
  public void setTextSize(int textSize) {
    m_label.setTextSize(textSize);
  }

  /**
   * A. Robertson
   *
   * Sets the text to be displayed beside the box.
   *
   * @param text The new text to be displayed beside the box.
   */
  public void setText(String text) {
    m_label.setText(text);
  }

  /**
   * A. Robertson
   *
   * Gets the label widget used to show text beside the box.
   *
   * @returns The label widget used to show text beside the box.
   */
  public LabelUI getLabel() {
    return m_label;
  }
}

// Code authorship:
// A. Robertson, Created a checkbox widget, 12pm 04/03/24
