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

  PGraphics m_rectGraphic;

  public TextboxUI(int x, int y, int scaleX, int scaleY) {
    super(x, y, scaleX, scaleY);
    m_backgroundColour = #FFFFFF;
    m_foregroundColour = 0;
    m_text = new StringBuilder();
    m_onKeyPressedEvent = new EventType<KeyPressedEventInfoType>();
    m_onClickEvent = new EventType<EventInfoType>();
    m_onStringEnteredEvent = new EventType<StringEnteredEventInfoType>();

    m_onKeyPressedEvent.addHandler(e -> onKeyPressed(e));

    m_rectGraphic = createGraphics(160, 40, P2D);
    m_rectGraphic.beginDraw();
    m_rectGraphic.fill(m_backgroundColour);
    m_rectGraphic.rect(0, 0, 160, 40, DEFAULT_WIDGET_ROUNDNESS_3);
    m_rectGraphic.endDraw();
  }

  void draw() {
    super.draw();

    image(m_rectGraphic, m_pos.x, m_pos.y, m_scale.x, m_scale.y);

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

    text(curText, m_pos.x, m_pos.y, m_scale.x, m_scale.y);

    if (!isFocused())
      return;

    m_timer -= 1;
    if (m_timer <= 0) {
      m_timer = 30;
      m_drawBar = !m_drawBar;
    }
  }

  public void setPlaceholderText(String txt) {
    m_placeholderText = txt;
  }

  public void setText(String text) {
    m_text.setLength(0);
    m_text.append(text);
    m_cursorPosition = text.length() /* - 1 */;  // -TO ALEX: Changed this from -1 since it broke when i tried to reset Search boxes, if this was necessary you can change it back
  }

  public String getText() {
    return m_text.toString();
  }

  public int getTextLength() {
    return m_text.length();
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
