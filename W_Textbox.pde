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
  private String m_emptyText = "";

  public TextboxUI(int x, int y, int width, int height) {
    super(x, y, width, height);
    m_backgroundColour = #FFFFFF;
    m_foregroundColour = 0;
    m_text = new StringBuilder();
    m_onKeyPressedEvent = new EventType<KeyPressedEventInfoType>();
    m_onClickEvent = new EventType<EventInfoType>();
    m_onStringEnteredEvent = new EventType<StringEnteredEventInfoType>();

    m_onKeyPressedEvent.addHandler(e -> onKeyPressed(e));
  }



  void draw() {
    super.draw();
    fill(m_backgroundColour);
    rect(m_pos.x, m_pos.y, m_scale.x, m_scale.y);
    // DRAWING THE TEXT ITSELF
    textAlign(LEFT, CENTER);
    fill(m_foregroundColour);
    textSize(fontSize);
    if (!isFocused() && m_text.toString() != "") {
      m_foregroundColour = 0;
      text(m_text.toString(), m_pos.x, m_pos.y, m_scale.x, m_scale.y);
    } else if (!isFocused() && m_text.toString() == "") {
      m_foregroundColour = 120;
      text(m_emptyText, m_pos.x, m_pos.y, m_scale.x, m_scale.y);
    } else {
      m_timer -= 1;
      if (m_timer == 0) {
        m_timer = 30;
        m_drawBar = !m_drawBar;
      }
      StringBuilder output = new StringBuilder();
      output.append(m_text.toString());
      if (m_userModifiable)
        output.insert(m_cursorPosition, m_drawBar ? "|" : " ");
      text(output.toString(), m_pos.x, m_pos.y, m_scale.x, m_scale.y);
    }
  }

  public void setPlaceholderText(String EmptyText) {

    m_emptyText = EmptyText;
  }

  public void setText(String text) {
    m_text.setLength(0);
    m_text.append(text);
    m_cursorPosition = text.length() /* - 1 */;  // -TO ALEX: Changed this from -1 since it broke when i tried to reset Search boxes, if this was necessary you can change it back
  }

  public String getText() {
    return m_text.toString();
  }

  private boolean isPrintable(char c) {
    Character.UnicodeBlock block = Character.UnicodeBlock.of( c );
    return (!Character.isISOControl(c)) &&
      c != java.awt.event.KeyEvent.CHAR_UNDEFINED &&
      block != null &&
      block != Character.UnicodeBlock.SPECIALS;
  }

  private void onKeyPressed(KeyPressedEventInfoType e) {
    println("Key pressed textbox event");
    if (m_userModifiable) {
      if (e.pressedKey == BACKSPACE) {
        if (m_cursorPosition > 0) {
          m_text.deleteCharAt(m_cursorPosition - 1);
          m_cursorPosition--;
        }
      } else if (e.pressedKey == DELETE) {
        if (m_cursorPosition < m_text.length()) {
          m_text.deleteCharAt(m_cursorPosition);
        }
      } else if (e.pressedKeyCode == LEFT && m_cursorPosition > 0) {
        m_cursorPosition--;
      } else if (e.pressedKeyCode == RIGHT && m_cursorPosition < m_text.length()) {
        m_cursorPosition++;
      } else if (e.pressedKey == RETURN || e.pressedKey == ENTER) {
        m_onStringEnteredEvent.raise(new StringEnteredEventInfoType((int)m_pos.x, (int)m_pos.y, m_text.toString(), this));
      } else if (isPrintable(e.pressedKey)) {
        m_text.append(e.pressedKey);
        m_cursorPosition++;
      }
    }
  }

  public void setUserModifiable(boolean userModifiable) {
    m_userModifiable = userModifiable;
  }

  public boolean getUserModifiable() {
    return m_userModifiable;
  }

  public EventType<EventInfoType> getOnClickEvent() {
    return m_onClickEvent;
  }

  public EventType<StringEnteredEventInfoType> getOnStringEnteredEvent() {
    return m_onStringEnteredEvent;
  }

  public EventType<KeyPressedEventInfoType> getOnKeyPressedEvent() {
    return m_onKeyPressedEvent;
  }
}

// Code authorship:
// M.Poole, Created textbox widget, 4:15pm 09/03/24
// A. Robertson, adapted textbox to use the event system and added features, 16:00 12/03/2024
