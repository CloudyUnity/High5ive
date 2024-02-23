class InputClass {
  private boolean[] m_currentFrameKeyboardState = new boolean[INPUT_ARRAY_LENGTH];
  private boolean[] m_lastFrameKeyboardState = new boolean[INPUT_ARRAY_LENGTH];
  private int[] m_millisSinceKeyPresses = new int[INPUT_ARRAY_LENGTH];

  public boolean getKey(char c) {
    char lower = Character.toLowerCase(c);
    return m_currentFrameKeyboardState[lower];
  }

  public boolean getKeyDown(char c) {
    if (m_lastFrameKeyboardState == null)
      return false;

    m_millisSinceKeyPresses[c] = millis();

    char lower = Character.toLowerCase(c);
    return m_currentFrameKeyboardState[lower] && !m_lastFrameKeyboardState[lower];
  }

  public boolean getKeyUp(char c) {
    if (m_lastFrameKeyboardState == null)
      return false;

    char lower = Character.toLowerCase(c);
    return !m_currentFrameKeyboardState[lower] && m_lastFrameKeyboardState[lower];
  }

  public int getMillisSincePressed(char c) {
    return millis() - m_millisSinceKeyPresses[c];
  }

  public void setKeyState(char c, boolean value) {
    char lower = Character.toLowerCase(c);
    m_currentFrameKeyboardState[lower] = value;
  }

  public void frame() {
    arrayCopy(m_currentFrameKeyboardState, 0, m_lastFrameKeyboardState, 0, m_currentFrameKeyboardState.length);
  }
}
