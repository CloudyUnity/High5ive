/**
 * F. Wright
 * 
 * Represents a group of radio buttons in the user interface.
 */
class RadioButtonGroupTypeUI extends WidgetGroupType {
  public RadioButtonGroupTypeUI() {
    super();
  }
/**
 * F. Wright
 * 
 * Adds a radio button as a member to the group and sets up event handling for it.
 *
 * @param rb The radio button to add to the group.
 */

  public void addMember(RadioButtonUI rb) {
    Members.add(rb);
    rb.getOnClickEvent().addHandler(e -> memberClicked(e));
  }
/**
 * F. Wright
 * 
 * Handles the click event of a radio button by unchecking all other members of the group.
 *
 * @param e The event information associated with the click event.
 */

  private void memberClicked(EventInfoType e) {
    for (Widget member : Members) {
      RadioButtonUI rb = (RadioButtonUI)member;

      if (rb != e.Widget) {
        rb.setChecked(false);
      }
    }
  }
}
/**
 * A. Robertson
 *
 * Represents a radio button user interface element that can be clicked to toggle its state.
 *
 */

class RadioButtonUI extends Widget implements IClickable {
  private EventType<EventInfoType> m_onClickEvent;
  private EventType<EventInfoType> m_onCheckedEvent;
  private LabelUI m_label;
  protected boolean m_checked;
  private boolean m_uncheckable;
  private color m_checkedColour = DEFAULT_RADIOBUTTON_CHECKED_COLOUR;
  private boolean m_drawCircle = true;


  /**
   * A. Robertson
   *
   * Initialises a radio button element.
   *
   * @param posX The x-coordinate of the top-left corner of the radio button.
   * @param posY The y-coordinate of the top-left corner of the radio button.
   * @param scaleX The horizontal scale of the radio button.
   * @param scaleY The vertical scale of the radio button.
   * @param label The label text to display next to the radio button.
   */

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
  /**
   * A. Robertson
   *
   * Draws the radio button on the screen.
   */

    public void draw() {
    super.draw();

    if (m_drawCircle) {
      ellipseMode(RADIUS);
      fill(color(m_checked ? m_checkedColour : m_backgroundColour));
      circle(m_pos.x + m_scale.y / 2, m_pos.y + m_scale.y / 2, m_scale.y / 2);
    }

    m_label.draw();
  }
  /**
   * A. Robertson
   *
   * Returns the event type for click events.
   *
   * @return The event type for click events.
   */

  public EventType<EventInfoType> getOnClickEvent() {
    return m_onClickEvent;
  }
  /**
   * A. Robertson
   *
   * Sets whether the radio button can be unchecked.
   *
   * @param uncheckable True if the radio button can be unchecked, false otherwise.
   */

  public EventType<EventInfoType> getOnCheckedEvent() {
    return m_onCheckedEvent;
  }
  /**
   * A. Robertson
   *
   * Sets whether the radio button can be checked.
   *
   * @param uncheckable True if the radio button cant be checked, false otherwise.
   */

  public void setUncheckable(boolean uncheckable) {
    m_uncheckable = uncheckable;
  }
  /**
   * A. Robertson
   *
   * Checks the radio button, triggering any associated events.
   */

  public void check() {
    m_onClickEvent.raise(new EventInfoType((int)m_pos.x, (int)m_pos.y, this));
  }
  /**
   * A. Robertson
   *
   * Sets the checked state of the radio button.
   *
   * @param checked True to check the radio button, false to uncheck it.
   */

  public void setChecked(boolean checked) {
    m_checked = checked;
  }

  /**
   * A. Robertson
   *
   * Returns whether the radio button is checked.
   *
   * @return True if the radio button is checked, false otherwise.
   */

  public boolean getChecked() {
    return m_checked;
  }
  /**
   * A. Robertson
   *
   * Sets the text of the label displayed next to the radio button.
   *
   * @param text The text to set.
   */

  public void setText(String text) {
    m_label.setText(text);
  }

  /**
   * A.Robertson
   *
   * Sets the button text size.
   *
   * @param  textSize The size of the text.
   * @throws IllegalArgumentException when the size argument is negative.
   **/
  public void setTextSize(int textSize) {
    m_label.setTextSize(textSize);
  }
  /**
   * A. Robertson
   *
   * Gets the label component displayed next to the radio button.
   *
   * @return The label component.
   */

  public LabelUI getLabel() {
    return m_label;
  }
  /**
   * A. Robertson
   *
   * Sets whether to draw the radio button.
   *
   * @param enabled True to draw, false otherwise.
   */

  public void setDrawCircle(boolean enabled) {
    m_drawCircle = enabled;
  }
}

/**
 * F. Wright
 *
 * Extends the radio button element with an image changes depending on its state.
 *
 */
class RadioImageButtonUI extends RadioButtonUI {
  public PImage m_enabledImage;
  public PImage m_disabledImage;

  /**
   * F. Wright
   *
   * Initialises a radio button element with an image.
   *
   * @param posX The x-coordinate of the top-left corner of the radio button.
   * @param posY The y-coordinate of the top-left corner of the radio button.
   * @param scaleX The horizontal scale of the radio button.
   * @param scaleY The vertical scale of the radio button.
   * @param label The label text to display next to the radio button.
   * @param enImg The image to display when the radio button is enabled.
   * @param disenImg The image to display when the radio button is disabled.
   */

  public RadioImageButtonUI(int posX, int posY, int scaleX, int scaleY, String label, PImage enImg, PImage disenImg) {
    super(posX, posY, scaleX, scaleY, label);
    m_enabledImage = enImg;
    m_disabledImage = disenImg;
    setDrawCircle(false);
  }
  /**
   * F. Wright
   *
   * Initialises a radio button element with an image, using the image's file path.
   * as opposed to a PImage variable
   *
   * @param posX The x-coordinate of the top-left corner of the radio button.
   * @param posY The y-coordinate of the top-left corner of the radio button.
   * @param scaleX The horizontal scale of the radio button.
   * @param scaleY The vertical scale of the radio button.
   * @param label The label text to display next to the radio button.
   * @param enImgPath The path to image to display when the radio button is enabled.
   * @param disenImgPath The path to the image to display when the radio button is disabled.
   */

  public RadioImageButtonUI(int posX, int posY, int scaleX, int scaleY, String label, String enImgPath, String disenImgPath) {
    super(posX, posY, scaleX, scaleY, label);
    m_enabledImage = loadImage(enImgPath);
    m_disabledImage = loadImage(disenImgPath);
    setDrawCircle(false);
  }

  @Override
  /**
   * F. Wright
   *
   * Draws the radio button with images on the screen.
   */
    public void draw() {
    super.draw();

    fill(m_backgroundColour);
    int scaleOffset = (int)((m_scale.x * 1.1f - m_scale.x) * 0.5f);
    rect(m_pos.x - scaleOffset, m_pos.y - scaleOffset, m_scale.x * 1.1f, m_scale.y * 1.1f, DEFAULT_WIDGET_ROUNDNESS_1);

    if (m_checked)
      image(m_enabledImage, m_pos.x, m_pos.y, m_scale.x, m_scale.y);
    else
      image(m_disabledImage, m_pos.x, m_pos.y, m_scale.x, m_scale.y);
  }
}

// Code authorship
// A. Robertson, Created a radiobutton widget, 12pm 04/03/24
