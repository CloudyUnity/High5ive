import java.util.concurrent.TimeUnit;

class ApplicationClass {
  private int m_timeLastFrame = 0;
  private int m_fixedFrameCounter = 0;

  private ArrayList<Screen> m_screens = new ArrayList<Screen>();
  private Screen m_currentScreen;

  private FlightsManagerClass m_flightsManager = new FlightsManagerClass();
  private DebugFPSClass m_fpsClass = new DebugFPSClass();

  private Event<SwitchScreenEventInfoType> m_onSwitchEvent = new Event<SwitchScreenEventInfoType>();

  void init() {
    if (DEBUG_DATA_LOADING) {
      String dataDirectory = "data/Preprocessed Data";
      m_flightsManager.init(dataDirectory, 4, list -> {
        println("I'm done! Here's the first flights day: " + list[0].Day + "\n\n");

        s_DebugProfiler.startProfileTimer();

        m_flightsManager.print(m_flightsManager.sort(m_flightsManager.queryFlightsWithinRange(
          m_flightsManager.getFlightsList(), FlightQueryType.MILES_DISTANCE, 100, 105),
          FlightQueryType.DEPARTURE_TIME, FlightQuerySortDirection.ASCENDING), 10
          );

        s_DebugProfiler.printTimeTakenMillis("Flight query-ing");
      }
      );
    }

    m_onSwitchEvent.addHandler(e -> switchScreen(e));

    Screen1 s1 = new Screen1(600, 600, SCREEN_1_ID);
    m_screens.add(s1);

    Screen2 s2 = new Screen2(700, 700, SCREEN_2_ID);
    m_screens.add(s2);

    Screen barchartDemo = new FlightCodesBarchartDemo(700, 700, SWITCH_TO_DEMO_ID);
    m_screens.add(barchartDemo);

    ScreenFlightMap sfm = new ScreenFlightMap(600, 600, SCREEN_FLIGHT_MAP_ID);
    m_screens.add(sfm);

    m_currentScreen = m_screens.get(3);

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

    if (DEBUG_MODE) {
      m_fpsClass.addToFrameTimes();
      fill(0);
      text("FPS: " + m_fpsClass.calculateFPS(), 10, 10, 100, 100);
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
