/**
 * F. Wright
 *
 * FlightMap3D class represents a 3D flight map screen widget with OpenGL GLSL shaders and P3D features.
 *
 * @extends Widget
 * @implements IDraggable, IWheelInput
 */
class FlightMap3D extends Widget implements IDraggable, IWheelInput {

  private EventType<MouseDraggedEventInfoType> m_onDraggedEvent = new EventType<MouseDraggedEventInfoType>();
  private EventType<MouseWheelEventInfoType> m_onWheelEvent = new EventType<MouseWheelEventInfoType>();

  private PShape m_modelEarth, m_modelSun, m_modelSkySphere;
  private PImage m_texEarthDay, m_texEarthNight, m_texSun, m_texSkySphereStars;
  private PImage m_texEarthNormalMap, m_texEarthSpecularMap, m_texDitherNoise;
  private PShader m_shaderEarth, m_shaderSun, m_shaderPP, m_shaderSkySphere;

  private PVector m_earthRotation = new PVector(0, 0, 0);
  private PVector m_earthRotationalVelocity = new PVector(0, 0, 0);
  private float m_zoomLevel = 1.0f;
  private float m_dayCycleSpeed = 0.00005f;

  private float m_arcFraction = 1.0f;
  private float m_arcGrowMillis = 1.0f;
  private int m_arcStartGrowMillis = 0;
  private boolean m_connectionsEnabled = true;
  private boolean m_textEnabled = true;
  private boolean m_markersEnabled = true;
  private boolean m_lockTime = false;

  private boolean m_assetsLoaded = false;
  private boolean m_drawnLoadingScreen = false;
  private boolean m_flightDataLoaded = false;
  private boolean m_working = false;
  private boolean m_profiledFirstRender = false;

  private float m_rotationYModified = 0;
  private float m_totalTimeElapsed = 0;

  private HashMap<String, AirportPoint3DType> m_airportHashmap = new HashMap<String, AirportPoint3DType>();

  private PVector m_earthPos;
  private float m_earthRadius;

  //================================================
  // ASSET LOADING
  //================================================

  /**
   * F. Wright
   *
   * Constructor for FlightMap3D class.
   * Initializes the widget with given position and scale, loads initial assets asynchronously.
   *
   * @param posX The x-coordinate of the widget.
   * @param posY The y-coordinate of the widget.
   * @param scaleX The horizontal scale of the widget.
   * @param scaleY The vertical scale of the widget.
   */
  public FlightMap3D(int posX, int posY, int scaleX, int scaleY) {
    super(posX, posY, scaleX, scaleY);
    m_texSkySphereStars = loadImage("data/Images/Stars2k.jpg"); // Loaded early for loading screen image
    m_earthRadius = height * 0.38f;

    new Thread(() -> {
      s_DebugProfiler.startProfileTimer();
      initAssetsAsync();
      s_DebugProfiler.printTimeTakenMillis("3D asset initialisation");
    }
    ).start();

    m_earthPos = new PVector(width * 0.5f + posX, height * 0.5f + posY, EARTH_Z_3D);

    m_onDraggedEvent.addHandler(e -> onDraggedHandler(e));
    m_onWheelEvent.addHandler(e -> onWheelHandler(e));
  }

  /**
   * F. Wright
   *
   * Initializes assets asynchronously. This includes creating 3D shapes, loading textures, and loading shaders.
   * The assets loaded include the Earth model, the Sun model, the sky sphere model, various textures for Earth, Sun, and sky, and several shaders.
   */
  private void initAssetsAsync() {
    m_modelEarth = s_3D.createShape(SPHERE, m_earthRadius);
    m_modelSun = s_3D.createShape(SPHERE, 40);
    m_modelSkySphere = s_3D.createShape(SPHERE, 3840);

    m_modelSun.disableStyle();
    m_modelSkySphere.disableStyle();
    m_modelEarth.disableStyle();

    m_texEarthDay = loadImage("data/Images/EarthDay1024.jpg");
    m_texEarthNight = loadImage("data/Images/EarthNight1024.jpg");
    m_texEarthNormalMap = loadImage("data/Images/EarthNormal1024.jpg");    
    m_texEarthSpecularMap = loadImage("data/Images/EarthSpecular2k.jpg");
    m_texSun = loadImage("data/Images/Sun2k.jpg");
    m_texDitherNoise = loadImage("data/Images/noise.png");

    m_shaderEarth = loadShader("data/Shaders/EarthFrag.glsl", "data/Shaders/BaseVert.glsl");
    m_shaderSun = loadShader("data/Shaders/SunFrag.glsl", "data/Shaders/BaseVert.glsl");
    m_shaderPP = loadShader("data/Shaders/PostProcessing.glsl");
    m_shaderSkySphere = loadShader("data/Shaders/SkyboxFrag.glsl", "data/Shaders/SkyboxVert.glsl");

    m_shaderEarth.set("texDay", m_texEarthDay);
    m_shaderEarth.set("texNight", m_texEarthNight);
    m_shaderEarth.set("normalMap", m_texEarthNormalMap);
    m_shaderEarth.set("specularMap", m_texEarthSpecularMap);
    m_shaderSun.set("tex", m_texSun);
    m_shaderPP.set("noise", m_texDitherNoise);
    m_shaderSkySphere.set("tex", m_texSkySphereStars);

    setPermaDay(false);
    m_assetsLoaded = true;
  }

  /**
   * F. Wright
   *
   * Loads flight data into the 3D flight map. Stores data for all airport markers and connections.
   *
   * @param flights The array of FlightType containing flight data.
   * @param queries The QueryManagerClass object for querying airport data.
   */
  public void loadFlights(FlightType[] flights, QueryManagerClass queries) {
    if (m_working)
      return;
    m_working = true;

    new Thread(() -> {
      m_flightDataLoaded = false;

      s_DebugProfiler.startProfileTimer();

      loadFlightsAsync(flights, queries);

      s_DebugProfiler.printTimeTakenMillis("Converting flights to arc points");

      m_flightDataLoaded = true;
      m_working = false;
    }
    ).start();
  }

  /**
   * F. Wright
   *
   * Asynchrously loads flight data into the 3D flight map. Stores data for all airport markers and connections.
   *
   * @param flights The array of FlightType containing flight data.
   * @param queries The QueryManagerClass object for querying airport data.
   */
  public void loadFlightsAsync(FlightType[] flights, QueryManagerClass queries) {
    m_airportHashmap.clear();
    ExecutorService executor = Executors.newFixedThreadPool(4);
    CountDownLatch latch = new CountDownLatch(4);

    int count = flights.length;
    int chunkSize = count / 4;

    for (int i = 0; i < 4; i++) {
      int startPosition = i * chunkSize;
      int endPosition = (i == 3) ? count : (i + 1) * chunkSize;

      executor.submit(() -> {
        int arcSegments = 4;
        if (count <= 6_000)
        arcSegments = 15;
        else if (count <= 12_000)
        arcSegments = 10;

        loadFlightsAsyncChunk(flights, queries, arcSegments, startPosition, endPosition);
        latch.countDown();
      }
      );
    }

    try {
      latch.await();
    }
    catch (InterruptedException e) {
      e.printStackTrace();
    }

    executor.shutdown();
  }

  /**
   * F. Wright
   *
   * Converts flight data to cached points in chunks
   *
   * @param flights The array of FlightType containing flight data.
   * @param queries The QueryManagerClass object for querying airport data.
   * @param arcSegments Amount of lines to be drawn for each arc
   * @param startIndex Starting index of the array to convert
   * @param endIndex Ending index of the array to convert
   */
  private void loadFlightsAsyncChunk(FlightType[] flights, QueryManagerClass queries, int arcSegments, int startIndex, int endIndex) {
    for (int i = startIndex; i < endIndex; i++) {
      String originCode = queries.getCode(flights[i].AirportOriginIndex);
      String destCode = queries.getCode(flights[i].AirportDestIndex);
      AirportPoint3DType origin, dest;

      if (!m_airportHashmap.containsKey(originCode)) {
        float latitude = queries.getLatitudeFromIndex(flights[i].AirportOriginIndex);
        float longitude = -queries.getLongitudeFromIndex(flights[i].AirportOriginIndex);
        origin = manualAddPoint(latitude, longitude, originCode);
      } else
        origin = m_airportHashmap.get(originCode);

      if (!m_airportHashmap.containsKey(destCode)) {
        float latitude = queries.getLatitudeFromIndex(flights[i].AirportDestIndex);
        float longitude = -queries.getLongitudeFromIndex(flights[i].AirportDestIndex);
        dest = manualAddPoint(latitude, longitude, destCode);
      } else
        dest = m_airportHashmap.get(destCode);

      boolean originConnected = origin.Connections.contains(destCode);
      boolean destConnected = dest.Connections.contains(originCode);
      if (originConnected || destConnected)
        continue;

      origin.Connections.add(destCode);
      dest.Connections.add(originCode);

      ArrayList<PVector> cachedPoints = cacheArcPoints(origin.Pos, dest.Pos, arcSegments);
      origin.ConnectionArcPoints.add(cachedPoints);
    }
  }

  /**
   * F. Wright
   *
   * Adds an airport point manually with the given latitude, longitude, and airport code.
   *
   * @param latitude The latitude of the airport.
   * @param longitude The longitude of the airport.
   * @param code The code of the airport.
   * @return The AirportPoint3DType object representing the airport point.
   */
  private AirportPoint3DType manualAddPoint(double latitude, double longitude, String code) {
    PVector pos = coordsToPointOnSphere(latitude, longitude, m_earthRadius);
    AirportPoint3DType point = new AirportPoint3DType(pos, code);
    m_airportHashmap.put(code, point);
    return point;
  }

  /**
   * F. Wright
   *
   * Caches points along the great circle arc between two given points.
   *
   * @param p1 The starting point of the arc.
   * @param p2 The ending point of the arc.
   * @return An ArrayList containing points along the arc.
   */
  ArrayList<PVector> cacheArcPoints(PVector p1, PVector p2, int arcSegments) {
    ArrayList<PVector> cacheResult = new ArrayList<PVector>();
    cacheResult.ensureCapacity(arcSegments  + 1);
    cacheResult.add(p1);

    float distance = p1.dist(p2);
    float distMult = lerp(0.1f, 1.0f, distance / 700.0f);

    if (distance > 200)
      arcSegments += 5;

    for (int i = 1; i < arcSegments; i++) {
      float t = i / (float)arcSegments;
      float bonusHeight = distMult * ARC_HEIGHT_MULT_3D * t * (1-t) + 1;
      PVector pointOnArc = slerp(p1, p2, t).mult(m_earthRadius * bonusHeight);
      cacheResult.add(pointOnArc);
    }

    cacheResult.add(p2);
    return cacheResult;
  }

  //================================================
  // RENDERING
  //================================================

  /**
   * F. Wright
   *
   * Overrides the draw method to render the 3D flight map.
   */
  @ Override
    public void draw() {
    super.draw();

    m_earthRotation.add(m_earthRotationalVelocity);
    m_earthRotationalVelocity.mult(EARTH_FRICTION_3D);
    m_earthRotation.x = clamp(m_earthRotation.x, -VERTICAL_SCROLL_LIMIT_3D, VERTICAL_SCROLL_LIMIT_3D);
    m_arcFraction = (millis() - m_arcStartGrowMillis) / m_arcGrowMillis;
    m_arcFraction = clamp(m_arcFraction, 0.0f, 1.0f);

    if (!m_assetsLoaded || !m_drawnLoadingScreen || !m_flightDataLoaded) {
      drawLoadingScreen();
      m_drawnLoadingScreen = true;
      return;
    }

    if (!m_lockTime)
      m_totalTimeElapsed += s_deltaTime * m_dayCycleSpeed;

    PVector lightDir = new PVector(cos(m_totalTimeElapsed), 0, sin(m_totalTimeElapsed));
    m_shaderEarth.set("lightDir", lightDir);
    m_rotationYModified = m_earthRotation.y + m_totalTimeElapsed;
    m_earthPos.z = EARTH_Z_3D + m_zoomLevel;
    m_shaderSun.set("texTranslation", 0, m_totalTimeElapsed * 0.5f);
    
    s_3D.beginDraw();

    drawEarth();
    drawSun(lightDir);
    drawMarkersAndConnections();
    if (m_textEnabled)
      drawMarkerText();

    if (DEBUG_MODE && DITHER_MODE_3D)
      s_3D.filter(m_shaderPP);

    drawSkybox();

    s_3D.endDraw();

    image(s_3D, 0, 0);
  }

  /**
   * F. Wright
   *
   * Draws the loading screen and loading test
   */
  private void drawLoadingScreen() {
    image(m_texSkySphereStars, 0, 0, width, height);

    textAlign(CENTER);
    fill(255, 255, 255, 255);
    textSize(50);
    text("Loading...", width/2, height/2);
  }

  /**
   * F. Wright
   *
   * Draws the Earth on the 3D canvas.
   */
  void drawEarth() {    
    s_3D.clear();
    s_3D.noStroke();
    s_3D.fill(255);

    s_3D.pushMatrix();
    s_3D.shader(m_shaderEarth);
    s_3D.textureWrap(CLAMP);

    s_3D.translate(m_earthPos.x, m_earthPos.y, m_earthPos.z);
    s_3D.rotateX(m_earthRotation.x);
    s_3D.rotateY(m_rotationYModified);
    
    if (!m_profiledFirstRender)
      s_DebugProfiler.startProfileTimer();
    
    s_3D.shape(m_modelEarth);
    
    if (!m_profiledFirstRender)
      s_DebugProfiler.printTimeTakenMillis("First earth render");
      
    m_profiledFirstRender = true;
    s_3D.resetShader();
    s_3D.popMatrix();
  }

  /**
   * F. Wright
   *
   * Draws the Sun on the 3D canvas.
   *
   * @param lightDir The direction vector of the sunlight.
   */
  void drawSun(PVector lightDir) {
    PVector sunTranslation = lightDir.copy().mult(-3000);
    s_3D.shader(m_shaderSun);
    s_3D.textureWrap(REPEAT);

    s_3D.pushMatrix();
    s_3D.translate(m_earthPos.x, m_earthPos.y, m_earthPos.z);
    s_3D.rotateX(m_earthRotation.x);
    s_3D.rotateY(m_rotationYModified);
    s_3D.translate(sunTranslation.x, sunTranslation.y, sunTranslation.z);

    s_3D.shape(m_modelSun);
    s_3D.popMatrix();
    s_3D.resetShader();
    s_3D.textureWrap(CLAMP);
  }

  /**
   * F. Wright
   *
   * Draws the skybox on the 3D canvas.
   */
  void drawSkybox() {
    s_3D.pushMatrix();
    s_3D.shader(m_shaderSkySphere);

    s_3D.rotateX(m_earthRotation.x);
    s_3D.rotateY(m_earthRotation.y);

    s_3D.shape(m_modelSkySphere);
    s_3D.resetShader();
    s_3D.popMatrix();
  }

  /**
   * F. Wright
   *
   * Draws airport markers and connections on the 3D canvas.
   */
  void drawMarkersAndConnections() {
    s_3D.strokeWeight(ARC_SIZE_3D);
    s_3D.noFill();

    s_3D.pushMatrix();
    s_3D.translate(m_earthPos.x, m_earthPos.y, m_earthPos.z);
    s_3D.rotateX(m_earthRotation.x);
    s_3D.rotateY(m_rotationYModified);

    for (AirportPoint3DType point : m_airportHashmap.values()) {
      PVector endline = point.Pos.copy().mult(1 + (0.05f * m_arcFraction));

      if (m_markersEnabled) {
        s_3D.stroke(point.Color);
        s_3D.line(point.Pos.x, point.Pos.y, point.Pos.z, endline.x, endline.y, endline.z);
      }

      if (m_connectionsEnabled) {
        s_3D.stroke(255, 255, 255, 255);
        drawGreatCircleArcFast(point);
      }
    }

    s_3D.fill(255);
    s_3D.noStroke();
    s_3D.popMatrix();
  }

  /**
   * F. Wright
   *
   * Draws text labels for airport markers on the 3D canvas.
   */
  void drawMarkerText() {
    s_3D.fill(255, 255, 255, 255);
    s_3D.textAlign(CENTER);
    s_3D.textSize(TEXT_SIZE_3D);

    for (AirportPoint3DType point : m_airportHashmap.values()) {
      float verticalDisplacement = point.Pos.y > 0 ? TEXT_DISPLACEMENT_3D.y : -TEXT_DISPLACEMENT_3D.y;

      s_3D.pushMatrix();
      s_3D.translate(m_earthPos.x, m_earthPos.y + verticalDisplacement, m_earthPos.z + TEXT_DISPLACEMENT_3D.z);
      s_3D.rotateX(m_earthRotation.x);
      s_3D.rotateY(m_rotationYModified);
      s_3D.translate(point.Pos.x, point.Pos.y, point.Pos.z);
      s_3D.rotateY(-m_rotationYModified);
      s_3D.rotateX(-m_earthRotation.x);

      if (m_zoomLevel > 0) {
        float scaleMult = 1 - (m_zoomLevel / 350.0f);
        scaleMult = (scaleMult * 0.6f) + 0.4f;
        s_3D.scale(scaleMult);
      }

      s_3D.text(point.Name, 0, 0);
      s_3D.popMatrix();
    }
  }

  /**
   * F. Wright
   *
   * Draws great circle arcs between airports on the 3D canvas.
   *
   * @param point The airport point for which to draw the arcs.
   */
  void drawGreatCircleArcFast(AirportPoint3DType point) {
    for (var connection : point.ConnectionArcPoints) {
      PVector lastPos = connection.get(0);

      float connectionSize = connection.size();
      for (int i = 1; i < connection.size(); i++) {
        PVector pointOnArc = connection.get(i);
        float t = i / connectionSize;

        if (t > m_arcFraction) {
          float lastT = (i-1) / connectionSize;
          float frac = (m_arcFraction - lastT) / (t - lastT);
          pointOnArc = PVector.lerp(lastPos, pointOnArc, frac);
          s_3D.line(lastPos.x, lastPos.y, lastPos.z, pointOnArc.x, pointOnArc.y, pointOnArc.z);
          break;
        }

        s_3D.line(lastPos.x, lastPos.y, lastPos.z, pointOnArc.x, pointOnArc.y, pointOnArc.z);
        lastPos = pointOnArc;
      }
    }
  }

  //================================================
  // INPUT
  //================================================

  /**
   * F. Wright
   *
   * Gets the event type for mouse dragged events.
   *
   * @return The event type for mouse dragged events.
   */
  public EventType<MouseDraggedEventInfoType> getOnDraggedEvent() {
    return m_onDraggedEvent;
  }

  /**
   * F. Wright
   *
   * Handles mouse dragged events.
   *
   * @param e The mouse dragged event information.
   */
  private void onDraggedHandler(MouseDraggedEventInfoType e) {
    PVector deltaDrag = new PVector( -(e.Y - e.PreviousPos.y) * 2, e.X - e.PreviousPos.x);
    deltaDrag.mult(s_deltaTime).mult(VERTICAL_DRAG_SPEED_3D);
    m_earthRotationalVelocity.add(deltaDrag);
  }

  /**
   * F. Wright
   *
   * Gets the event type for mouse wheel events.
   *
   * @return The event type for mouse wheel events.
   */
  public EventType<MouseWheelEventInfoType> getOnMouseWheelEvent() {
    return m_onWheelEvent;
  }

  /**
   * F. Wright
   *
   * Handles mouse wheel events.
   *
   * @param e The mouse wheel event information.
   */
  private void onWheelHandler(MouseWheelEventInfoType e) {
    m_zoomLevel -= e.WheelCount * MOUSE_SCROLL_STRENGTH_3D;
    m_zoomLevel = clamp(m_zoomLevel, -500, 350);
  }

  //================================================
  // SETTINGS
  //================================================

  /**
   * F. Wright
   *
   * Sets the duration and delay for the growth of arcs.
   *
   * @param timeTakenMillis The time taken for the arcs to grow, in milliseconds.
   * @param delay The delay before the arcs start growing, in milliseconds.
   */
  public void setArcGrowMillis(float timeTakenMillis, int delay) {
    m_arcStartGrowMillis = millis() + delay;
    m_arcGrowMillis = timeTakenMillis;
  }

  /**
   * F. Wright
   *
   * Sets whether the day is permanent.
   *
   * @param enabled True to enable permanent day, false otherwise.
   */
  public void setPermaDay(boolean enabled) {
    m_shaderEarth.set("permaDay", enabled ? 10.0f : 0.0f);
  }

  /**
   * F. Wright
   *
   * Sets whether connections are enabled.
   *
   * @param enabled True to enable connections, false otherwise.
   */
  public void setConnectionsEnabled(boolean enabled) {
    m_connectionsEnabled = enabled;
  }

  /**
   * F. Wright
   *
   * Sets whether text is enabled.
   *
   * @param enabled True to enable text, false otherwise.
   */
  public void setTextEnabled(boolean enabled) {
    m_textEnabled = enabled;
  }

  /**
   * F. Wright
   *
   * Sets whether markers are enabled.
   *
   * @param enabled True to enable markers, false otherwise.
   */
  public void setMarkersEnabled(boolean enabled) {
    m_markersEnabled = enabled;
  }

  /**
   * F. Wright
   *
   * Sets whether time is locked.
   *
   * @param enabled True to lock time, false otherwise.
   */
  public void setLockTime(boolean enabled) {
    m_lockTime = enabled;
  }

  /**
   * F. Wright
   *
   * Sets the speed of the day cycle.
   *
   * @param speed The speed of the day cycle.
   */
  public void setDayCycleSpeed(float speed) {
    m_dayCycleSpeed = speed;
  }
}

// Descending code authorship changes:
// F. Wright, Created 3D flight map screen using OpenGL GLSL shaders and P3D features. Implemented light shading and day-night cycle, 9pm 07/03/24
// F. Wright, Fixed loading screen, 10am, 08/03/24
// F. Wright, Created latitude/longitude coords to 3D point converter and used geometric slerping to create arcs around the planet for connections between airports, 3pm 08/03/24
// F. Wright, Specular maps, vertical scrolling, bigger window, more constants, growing arcs over time, 3pm 09/03/24
// F. Wright, Skybox, shaders, fullscreen, UI, buttons, sun, connections, loading in data, etc, etc
// CKM, made minor edits to neaten up code 16:00 12/03
// CKM, inital no spin setup 11:00 13/03
// F. Wright, Implemented "Lock time" checkbox, 12pm 13/03/24
// F. Wright, Improved time locking options, more progress on normal mapping, 9pm 13/03/24
// F. Wright, Finally got normal mapping working! Had to go deep into github repos and tiny forums for that one, 11am 14/03/24
// F. Wright, Changed earth size to depend on screen size, 10am 15/03/24
// F. Wright, Implemented zooming and improved performance, 12pm 15/03/24
