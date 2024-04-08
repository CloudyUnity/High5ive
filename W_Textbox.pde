public class TextboxUI extends Widget implements IKeyInput, IClickable {
  private int fontSize = 20;
  private StringBuilder m_text;
  private int m_cursorPosition = 0;

  private EventType<KeyPressedEventInfoType> m_onKeyPressedEvent;
  private EventType<EventInfoType> m_onClickEvent;
  private EventType<StringEnteredEventInfoType> m_onStringEnteredEvent;

  private int m_timer = 30;
  private boolean m_drawBar = true;
  private boolean m_userModifiable = true;
  private String m_placeholderText = "";

  /**
   * M.Poole & A.Robertson:
   * Constructs an ImageUI object with the specified dimensions and position.
   *
   * @param scaleX The width of the textbox.
   * @param scaleY The height of the textbox.
   * @param posX   The x-coordinate of the textbox's position.
   * @param posY   The y-coordinate of the textbox's position.
   */
  public TextboxUI(int x, int y, int scaleX, int scaleY) {
    super(x, y, scaleX, scaleY);
    m_backgroundColour = #FFFFFF;
    m_foregroundColour = 0;
    m_text = new StringBuilder();
    m_onKeyPressedEvent = new EventType<KeyPressedEventInfoType>();
    m_onClickEvent = new EventType<EventInfoType>();
    m_onStringEnteredEvent = new EventType<StringEnteredEventInfoType>();

    m_onKeyPressedEvent.addHandler(e -> onKeyPressed(e));
  }

  /**
   * A. Robertson & F. Wright & M. Poole
   *
   * Draws the textbox
   */
  void draw() {
    super.draw();

    image(s_roundedRectImage8, m_pos.x, m_pos.y, m_scale.x, m_scale.y);

    String curText = m_text.toString();

    if (isFocused() && m_drawBar && m_userModifiable)
      curText += "|";

    fill(m_foregroundColour);
    textAlign(LEFT, CENTER);
    textSize(fontSize);

    if (!isFocused() && curText.isEmpty()) {
      fill(120);
      curText = m_placeholderText;
    }

    text(" " + curText, m_pos.x, m_pos.y, m_scale.x, m_scale.y);

    if (!isFocused())
      return;

    m_timer -= 1;
    if (m_timer <= 0) {
      m_timer = 30;
      m_drawBar = !m_drawBar;
    }
  }

  /**
   * M.Poole & A.Robertson:
   *
   * Sets the placeholder text for the text input.
   *
   * @param txt The placeholder text to set.
   */
  public void setPlaceholderText(String txt) {
    m_placeholderText = txt;
  }

  /**
   * M.Poole & A.Robertson:
   *
   * Sets the text content of the text input.
   *
   * @param text The text to set.
   */
  public void setText(String text) {
    m_text.setLength(0);
    m_text.append(text);
    m_cursorPosition = text.length();
  }

  /**
   * M.Poole & A.Robertson:
   *
   * Retrieves the text content of the text input.
   *
   * @return The text content.
   */
  public String getText() {
    return m_text.toString();
  }

  /**
   * M.Poole & A.Robertson:
   *
   * Retrieves the length of the text content of the text input.
   *
   * @return The length of the text content.
   */
  public int getTextLength() {
    return m_text.length();
  }

  /**
   * M.Poole & A.Robertson:
   *
   * Checks if a character is printable.
   *
   * @param c The character to check.
   * @return True if the character is printable, false otherwise.
   */
  private boolean isPrintable(char c) {
    Character.UnicodeBlock block = Character.UnicodeBlock.of( c );
    return (!Character.isISOControl(c)) &&
      c != java.awt.event.KeyEvent.CHAR_UNDEFINED &&
      block != null &&
      block != Character.UnicodeBlock.SPECIALS;
  }

  /**
   * M.Poole & A.Robertson:
   *
   * Handles the key pressed event.
   *
   * @param e The key pressed event information.
   */
  private void onKeyPressed(KeyPressedEventInfoType e) {
    if (m_userModifiable) {
      if (e.PressedKey == BACKSPACE) {
        if (m_cursorPosition > 0) {
          m_text.deleteCharAt(m_cursorPosition - 1);
          m_cursorPosition--;
        }
      } else if (e.PressedKey == DELETE) {
        if (m_cursorPosition < m_text.length()) {
          m_text.deleteCharAt(m_cursorPosition);
        }
      } else if (e.PressedKeyCode == LEFT && m_cursorPosition > 0) {
        m_cursorPosition--;
      } else if (e.PressedKeyCode == RIGHT && m_cursorPosition < m_text.length()) {
        m_cursorPosition++;
      } else if (e.PressedKey == RETURN || e.PressedKey == ENTER) {
        m_onStringEnteredEvent.raise(new StringEnteredEventInfoType((int)m_pos.x, (int)m_pos.y, m_text.toString(), this));
        setFocused(false);
      } else if (isPrintable(e.PressedKey)) {
        m_text.append(e.PressedKey);
        m_cursorPosition++;
      }
    }
  }

  /**
   * M.Poole & A.Robertson:
   *
   * Sets whether the text input is user modifiable or not.
   *
   * @param userModifiable True if the text input is user modifiable, false otherwise.
   */
  public void setUserModifiable(boolean userModifiable) {
    m_userModifiable = userModifiable;
  }

  /**
   * M.Poole & A.Robertson:
   *
   * Retrieves whether the text input is user modifiable or not.
   *
   * @return True if the text input is user modifiable, false otherwise.
   */
  public boolean getUserModifiable() {
    return m_userModifiable;
  }

  /**
   * M.Poole & A.Robertson:
   *
   * Retrieves the onClick event associated with the text input.
   *
   * @return The onClick event.
   */
  public EventType<EventInfoType> getOnClickEvent() {
    return m_onClickEvent;
  }

  /**
   * M.Poole & A.Robertson:
   *
   * Retrieves the onStringEntered event associated with the text input.
   *
   * @return The onStringEntered event.
   */
  public EventType<StringEnteredEventInfoType> getOnStringEnteredEvent() {
    return m_onStringEnteredEvent;
  }

  /**
   * M.Poole & A.Robertson:
   *
   * Retrieves the onKeyPressed event associated with the text input.
   *
   * @return The onKeyPressed event.
   */
  public EventType<KeyPressedEventInfoType> getOnKeyPressedEvent() {
    return m_onKeyPressedEvent;
  }
}

// Code authorship:
// M.Poole, Created textbox widget, 4:15pm 09/03/24
// A. Robertson, adapted textbox to use the event system and added features, 16:00 12/03/2024
