import java.util.concurrent.TimeUnit;

class ApplicationClass {
  private int m_timeLastFrame = 0;
  private int m_fixedFrameCounter = 0;

  private ArrayList<Screen> m_screens = new ArrayList<Screen>();
  private Screen m_currentScreen;

  private FlightsManagerClass m_flightsManager = new FlightsManagerClass();
  private QueryManagerClass m_queryManager = new QueryManagerClass();
  private DataPreprocessor m_dataPreprocessor = new DataPreprocessor();
  private DebugFPSClass m_fpsClass = new DebugFPSClass();

  private Event<SwitchScreenEventInfoType> m_onSwitchEvent = new Event<SwitchScreenEventInfoType>();

  void init() {
    m_queryManager.init();

    m_onSwitchEvent.addHandler(e -> switchScreen(e));

    Screen1 screen1 = new Screen1(displayWidth, displayHeight, SCREEN_1_ID);
    m_screens.add(screen1);

    Screen2 screen2 = new Screen2(displayWidth, displayHeight, SCREEN_2_ID);
    m_screens.add(screen2);

    Screen screenDemo = new FlightCodesBarchartDemo(displayWidth, displayHeight, SWITCH_TO_DEMO_ID);
    m_screens.add(screenDemo);

    ScreenFlightMap screenFlightMap3D = new ScreenFlightMap(displayWidth, displayHeight, SCREEN_FLIGHT_MAP_ID, m_queryManager);
    m_screens.add(screenFlightMap3D);

    TextBoxDemoScreen d = new TextBoxDemoScreen(700, 700, TB_DEMO_ID);
    m_screens.add(d);

    m_currentScreen = m_screens.get(0);

    PVector windowSize = m_currentScreen.getScale();
    if (!FULLSCREEN_ENABLED)
      resizeWindow((int)windowSize.x, (int)windowSize.y);    

    if (DEBUG_DATA_LOADING) {
      m_flightsManager.init(4, list -> {        
        m_queryManager.queryFlights(list, FlightQueryType.AIRPORT_ORIGIN_INDEX, FlightQueryOperator.EQUAL, m_queryManager.getIndex("SFO"), 4, queriedList -> {
          s_DebugProfiler.startProfileTimer();
          screenFlightMap3D.startLoadingData(queriedList);
          s_DebugProfiler.printTimeTakenMillis("Loading flight data into 3D flight map");
        }
        );
      }
      );
    }
  }

  void frame() {
    s_deltaTime = millis() - m_timeLastFrame;
    m_timeLastFrame = millis();

    if (m_fixedFrameCounter < millis()) {
      fixedFrame();
      m_fixedFrameCounter += FIXED_FRAME_INCREMENT;
    }

    m_currentScreen.draw();

    if (DEBUG_MODE && DEBUG_FPS_ENABLED) {
      m_fpsClass.addToFrameTimes();
      fill(255, 0, 0, 255);
      textSize(15);
      text("FPS: " + m_fpsClass.calculateFPS(), width - 100, 10, 100, 100);
    }
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
  
  void onMouseWheel(MouseEvent event){
    if (m_currentScreen != null){
      m_currentScreen.onMouseWheel(event);
    }
  
  }

  public void onKeyPressed(char k, int kc) {
    if (m_currentScreen != null)
      m_currentScreen.getOnKeyPressedEvent().raise(new KeyPressedEventInfoType(mouseX, mouseY, k, kc, m_currentScreen));
  }

  public Event<SwitchScreenEventInfoType> getOnSwitchEvent() {
    return m_onSwitchEvent;
  }

  private void switchScreen(SwitchScreenEventInfoType e) {
    e.Widget.getOnMouseExitEvent().raise((EventInfoType)e);

    for (Screen screen : m_screens) {
      if (e.NewScreenId.compareTo(screen.getScreenId()) != 0)
        continue;

      m_currentScreen = screen;
      resizeWindow((int)screen.getScale().x, (int)screen.getScale().y);
      return;
    }
  }
}

// Descending code authorship changes:
// F. Wright, Made ApplicationClass and set up init(), frame() and fixedFrame(), 8pm 23/02/24
// F. Wright, Modified onMouse() functions and merged functions from the old UI main into ApplicationClass, 6pm 04/03/24
// F. Wright, Changed manual profiling to use DebugProfilingClass instead, 2pm 06/03/24
// F. Wright, Fixed UI errors, 12pm 07/03/24
// CKM, bought code to working levels 14:00 12/03
