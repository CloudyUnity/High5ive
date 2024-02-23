class InputClass {
  private boolean[] m_currentFrameKeyboardState = new boolean[255];
  private boolean[] m_lastFrameKeyboardState = new boolean[255];
  private int[] m_millisSinceKeyPresses = new int[255];

  // When key is being pressed down
  public boolean getKey(char c) {
    char lower = Character.toLowerCase(c);
    return m_currentFrameKeyboardState[lower];
  }

  // When key was pressed this frame
  public boolean getKeyDown(char c) {
    if (m_lastFrameKeyboardState == null)
      return false;

    m_millisSinceKeyPresses[c] = millis();

    char lower = Character.toLowerCase(c);
    return m_currentFrameKeyboardState[lower] && !m_lastFrameKeyboardState[lower];
  }

  // When key was released this frame
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
