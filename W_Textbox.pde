public class TextboxUI extends Widget implements IKeyInput, IClickable {
  private int fontSize = 24;
  private StringBuilder m_text;
  private int m_cursorPosition;

  private Event<KeyPressedEventInfoType> m_onKeyPressedEvent;
  private Event<EventInfoType> m_onClickEvent;
  private Event<StringEnteredEventInfoType> m_onStringEnteredEvent;

  private int m_timer;
  private boolean m_drawBar;
  private boolean m_userModifiable = true;

  public TextboxUI(int x, int y, int width, int height) {
    super(x, y, width, height);
    m_backgroundColour = #FFFFFF;
    m_foregroundColour = 0;
    m_text = new StringBuilder();
    m_onKeyPressedEvent = new Event<KeyPressedEventInfoType>();
    m_onClickEvent = new Event<EventInfoType>();
    m_onStringEnteredEvent = new Event<StringEnteredEventInfoType>();
    m_timer = 30;
    m_drawBar = true;
    m_cursorPosition = 0;

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
    if (!isFocused())
      text(m_text.toString(), m_pos.x, m_pos.y, m_scale.x, m_scale.y);
    else {
      m_timer -= 1;
      if (m_timer == 0) {
        m_timer = 30;
        m_drawBar = !m_drawBar;
      }
      StringBuilder output = new StringBuilder();
      output.append(m_text.toString());
      output.insert(m_cursorPosition, m_drawBar ? "|" : " ");
      text(output.toString(), m_pos.x, m_pos.y, m_scale.x, m_scale.y);
    }
  }

  public void setText(String text) {
    m_text.setLength(0);
    m_text.append(text);
    m_cursorPosition = text.length() - 1;
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

  public Event<EventInfoType> getOnClickEvent() {
    return m_onClickEvent;
  }

  public Event<StringEnteredEventInfoType> getOnStringEnteredEvent() {
    return m_onStringEnteredEvent;
  }

  public Event<KeyPressedEventInfoType> getOnKeyPressedEvent() {
    return m_onKeyPressedEvent;
  }
}

// Code authorship:
// M.Poole, Created textbox widget, 4:15pm 09/03/24
// A. Robertson, adapted textbox to use the event system and added features, 16:00 12/03/2024
