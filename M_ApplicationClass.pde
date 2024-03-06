class ApplicationClass {
  private int m_timeLastFrame = 0;
  private int m_fixedFrameCounter = 0;

  private ArrayList<Screen> m_screens;
  private Screen m_currentScreen;
  
  private FlightsManagerClass m_flightsManager = new FlightsManagerClass();

  void init() {
    
    // DEBUG
    s_DebugProfiler.startProfileTimer();    
    String filepath = "data/Preprocessed Data/all_lines_random.bin";
    m_flightsManager.convertFileToRawFlightType(filepath);    
    s_DebugProfiler.printTimeTakenMillis("Raw file pre-processing");
    // ===

    m_screens = new ArrayList<Screen>();

    Screen1 s1 = new Screen1(600, 600, SCREEN_1_ID);
    Screen2 s2 = new Screen2(700, 700, SCREEN_2_ID);

    m_screens.add(s1);
    m_screens.add(s2);
    m_currentScreen = m_screens.get(0);
    
    PVector windowSize = m_currentScreen.getScale();
    resizeWindow((int)windowSize.x, (int)windowSize.y);   
  }

  void frame() {
    s_deltaTime = millis() - m_timeLastFrame;
    m_timeLastFrame = millis();

    if (m_fixedFrameCounter < millis()) {
      fixedFrame();
      m_fixedFrameCounter += FIXED_FRAME_INCREMENT;
    }
    
    m_currentScreen.draw();
  }

  void fixedFrame() {
  }

  void onMouseMoved() {
    if (m_currentScreen != null)
      m_currentScreen.onMouseMoved();
  }

  void onMouseDragged() {
    if (m_currentScreen != null)
      m_currentScreen.onMouseDragged();
  }

  void onMouseClick() {
    if (m_currentScreen != null)
      m_currentScreen.onMouseClick();
  }

  void switchScreen(SwitchScreenEventInfoType e) {
    e.Widget.getOnMouseExitEvent().raise((EventInfoType)e);

    for (Screen screen : m_screens) {
      if (e.NewScreenId.compareTo(screen.getScreenId()) == 0) {
        m_currentScreen = screen;        
        resizeWindow((int)screen.getScale().x, (int)screen.getScale().y);
        return;
      }
    }      
  } 
}

// Descending code authorship changes:
// F. Wright, Made ApplicationClass and set up init(), frame() and fixedFrame(), 8pm 23/02/24
// F. Wright, Modified onMouse() functions and merged functions from the old UI main into ApplicationClass, 6pm 04/03/24
// F. Wright, Changed manual profiling to use DebugProfilingClass instead, 2pm 06/03/24
