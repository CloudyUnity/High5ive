/**
 * F. Wright
 *
 * Class representing the main application.
 */
class ApplicationClass {
  private int m_timeLastFrame = 0;

  private ArrayList<Screen> m_screens = new ArrayList<Screen>();
  private Screen m_currentScreen;

  private FlightsManagerClass m_flightsManager = new FlightsManagerClass();
  private QueryManagerClass m_queryManager = new QueryManagerClass();

  private EventType<SwitchScreenEventInfoType> m_onSwitchEvent = new EventType<SwitchScreenEventInfoType>();

  ScreenCharts m_screenCharts = null;
  Screen3DFM m_screen3DFM = null;
  TwoDMapScreen m_screen2DFM = null;

  /**
   * F. Wright
   *
   * Initializes the application by setting up screens and loading data.
   */
  public void init() {
    s_DebugProfiler.startProfileTimer();
    m_queryManager.init();
    s_DebugProfiler.printTimeTakenMillis("Query manager initialisation");

    m_onSwitchEvent.addHandler(e -> switchScreen(e));

    s_DebugProfiler.startProfileTimer();
    createScreens();
    s_DebugProfiler.printTimeTakenMillis("Creating screens");

    m_flightsManager.loadUSAndWorldFromFiles("hex_flight_data.bin", "hex_world_data.bin", 4, list -> {
      m_screen3DFM.insertFlightData(list);
      m_screen2DFM.insertFlightData(list);
      m_screenCharts.insertBaseData(list);
    }
    );
  }

  /**
   * F. Wright
   *
   * Initializes the screens of the application.
   */
  private void createScreens() {
    Consumer<FlightType[]> loadDataChartsTo3D = (flights -> {
      m_screen3DFM.loadFlights(flights);
      switchScreen(new SwitchScreenEventInfoType(0, 0, SCREEN_FLIGHT_MAP_ID, null));
    }
    );
    
    Consumer<FlightType[]> loadData3DToCharts = (flights -> {
      m_screenCharts.loadData(flights);
      switchScreen(new SwitchScreenEventInfoType(0, 0, SCREEN_CHARTS_ID, null));
    }
    );
    
    ScreenHome screenHome = new ScreenHome(SCREEN_1_ID);
    m_screens.add(screenHome);

    m_screen2DFM = new TwoDMapScreen(SCREEN_TWOD_MAP_ID, m_queryManager);
    m_screens.add(m_screen2DFM);

    m_screen3DFM = new Screen3DFM(SCREEN_FLIGHT_MAP_ID, m_queryManager, loadData3DToCharts);
    m_screens.add(m_screen3DFM);

    m_screenCharts = new ScreenCharts(SCREEN_CHARTS_ID, m_queryManager, loadDataChartsTo3D);
    m_screens.add(m_screenCharts);

    m_currentScreen = screenHome;
    screenHome.init();
  }

  /**
   * F. Wright
   *
   * Called every frame to update and render the current screen.
   */
  public void frame() {
    s_deltaTime = millis() - m_timeLastFrame;
    m_timeLastFrame = millis();

    m_currentScreen.draw();

    if (DEBUG_MODE && DEBUG_FPS_ENABLED) {
      fill(255, 0, 0, 255);
      textSize(15);
      float fps =  round(frameRate * 100.0) / 100.0;
      text("FPS: " + fps, width - 100, 10, 100, 100);
    }
  }

  /**
   * F. Wright
   *
   * Called when the mouse position is different from the last frame.
   */
  public void onMouseMoved() {
    if (m_currentScreen != null)
      m_currentScreen.onMouseMoved();
  }

  /**
   * F. Wright
   *
   * Called when the mouse position is different from the last frame while the mouse button is pressed.
   */
  public void onMouseDragged() {
    if (m_currentScreen != null)
      m_currentScreen.onMouseDragged();
  }

  /**
   * F. Wright
   *
   * Called when the mouse button is clicked.
   */
  public void onMouseClick() {
    if (m_currentScreen != null)
      m_currentScreen.onMouseClick();
  }

  /**
   * F. Wright
   *
   * Called when the mouse wheel is scrolled.
   *
   * @param wheelCount The amount the mouse wheel is scrolled.
   */
  public void onMouseWheel(int wheelCount) {
    if (m_currentScreen != null)
      m_currentScreen.getOnMouseWheelEvent().raise(new MouseWheelEventInfoType(mouseX, mouseY, wheelCount, m_currentScreen));
  }

  /**
   * F. Wright
   *
   * Called when a key is pressed.
   *
   * @param k The character representation of the key that was pressed.
   * @param kc The integer representation of the key that was pressed.
   */
  public void onKeyPressed(char k, int kc) {
    if (m_currentScreen != null)
      m_currentScreen.getOnKeyPressedEvent().raise(new KeyPressedEventInfoType(mouseX, mouseY, k, kc, m_currentScreen));
  }

  /**
   * F. Wright
   *
   * Returns the event for switching screens.
   *
   * @return The event for switching screens.
   */
  public EventType<SwitchScreenEventInfoType> getOnSwitchEvent() {
    return m_onSwitchEvent;
  }

  /**
   * F. Wright
   *
   * Switches the screen using a screen ID constant.
   *
   * @param e The event containing information about the switch screen event.
   */
  private void switchScreen(SwitchScreenEventInfoType e) {
    if (e.Widget != null)
      e.Widget.getOnMouseExitEvent().raise((EventInfoType)e);

    for (Screen screen : m_screens) {
      if (e.NewScreenId.compareTo(screen.getScreenId()) != 0)
        continue;

      m_currentScreen = screen;
      if (!m_currentScreen.m_initialised) {
        s_DebugProfiler.startProfileTimer();
        m_currentScreen.init();
        s_DebugProfiler.printTimeTakenMillis("Initialisation of: " + screen.getScreenId());
      }

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
// CKM, removed datapreprocessor references, 17:00 12/03
// M. Orlowski, added 2D screen, 11:00, 13/03
