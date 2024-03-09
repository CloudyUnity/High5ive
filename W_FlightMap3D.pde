import java.util.function.Function;
import java.util.function.Consumer;

class CoordType {
  public float Latitude;
  public float Longitude;

  public CoordType(float lat, float longi) {
    Latitude = lat;
    Longitude = longi;
  }
}

class AirportPointType {
  public PVector Pos;
  public String Name;
  public color Color = color(0, 255, 0, 255);
  public ArrayList<AirportPointType> Connections = new ArrayList<AirportPointType>();
  public ArrayList<ArrayList<PVector>> ConnectionArcPoints = new ArrayList<ArrayList<PVector>>();

  public AirportPointType(PVector pos, String name) {
    Pos = pos;
    Name = name;
  }

  public AirportPointType(PVector pos, String name, color col) {
    Pos = pos;
    Name = name;
    Color = col;
  }
}

class FlightMap3D extends Widget implements IDraggable {

  private Event<MouseDraggedEventInfoType> m_onDraggedEvent = new Event<MouseDraggedEventInfoType>();

  private PShape m_earthModel;
  private PImage m_earthDayTex, m_earthNightTex;
  private PImage m_earthSpecularMap;
  private PShader m_earthShader;

  private PVector m_earthRotation = new PVector(0, 0, 0);
  private PVector m_earthRotationalVelocity = new PVector(0, 0, 0);
  private final float m_earthRotationalFriction = 0.99;

  private float m_arcFraction = 1.0f;
  private float m_arcGrowMillis = 1.0f;
  private int m_arcStartGrowMillis = 0;

  private boolean m_assetsLoaded = false;
  private boolean m_drawnLoadingScreen = false;

  private PImage m_backgroundImg;

  private ArrayList<AirportPointType> m_allAirportPoints = new ArrayList<AirportPointType>();

  private PVector m_earthPos;

  public FlightMap3D() {
    super(0, 0, (int)WINDOW_SIZE_3D_FLIGHT_MAP.x, (int)WINDOW_SIZE_3D_FLIGHT_MAP.y);

    new Thread(() -> {
      m_earthModel = s_3D.createShape(SPHERE, EARTH_SPHERE_SIZE);
      m_earthModel.disableStyle();

      m_earthDayTex = loadImage("data/Images/EarthDay2k.jpg");
      m_earthNightTex = loadImage("data/Images/EarthNight2k.jpg");
      m_earthSpecularMap = loadImage("data/Images/EarthSpecular2k.tif");

      m_earthShader = s_3D.loadShader("data/Shaders/EarthFrag.glsl", "data/Shaders/EarthVert.glsl");

      m_earthShader.set("texDay", m_earthDayTex);
      m_earthShader.set("texNight", m_earthNightTex);
      m_earthShader.set("specularMap", m_earthSpecularMap);

      m_earthPos = new PVector(WINDOW_SIZE_3D_FLIGHT_MAP.x * 0.5f, WINDOW_SIZE_3D_FLIGHT_MAP.y * 0.5f, EARTH_Z);

      manualAddPoint(40.641766f, 73.780968f, "JFK");
      manualAddPoint(30.11983333f, -31.40333056f, "CAI");
      manualAddPoint(51.509865f, -0.118092f, "LHR");
      manualAddPoint(90, 0, "North Pole");

      // DEBUG RANDOM PLACEMENT
      for (int i = 0; i < 369; i++) {
        var p = manualAddPoint(random(-180.0f, 180.0f), random(-180.0f, 180.0f), i + "");
        
        for (int j = 0; j < 1; j++) {
          p.Connections.add(m_allAirportPoints.get((int)random(0, i-1)));
          p.ConnectionArcPoints.add(cacheArcPoints(p.Pos, p.Connections.get(j).Pos));
        }
      }

      m_assetsLoaded = true;
      println("Loading 3D assets complete!");
    }
    ).start();

    m_backgroundImg = loadImage("data/Images/Stars2k.jpg");
    m_onDraggedEvent.addHandler(e -> onDraggedHandler(e));
  }

  @ Override
    public void draw() {
    super.draw();

    m_earthRotation.add(m_earthRotationalVelocity);
    m_earthRotationalVelocity.mult(m_earthRotationalFriction);
    m_earthRotation.x = clamp(m_earthRotation.x, -VERTICAL_SCROLL_LIMIT, VERTICAL_SCROLL_LIMIT);
    m_arcFraction = (millis() - m_arcStartGrowMillis) / m_arcGrowMillis;

    image(m_backgroundImg, 0, 0, width, height);

    if (!m_assetsLoaded || !m_drawnLoadingScreen) {
      textAlign(CENTER);
      fill(255, 255, 255, 255);
      textSize(50);
      text("Loading...", width/2, height/2);
      m_drawnLoadingScreen = true;

      setArcGrowMillis(10_000.0f, 5000);
      return;
    }

    float time = millis() * DAY_CYCLE_SPEED;
    m_earthShader.set("lightDir", cos(time), 0, sin(time));

    s_3D.beginDraw();
    s_3D.clear();
    s_3D.noStroke();

    s_3D.pushMatrix();
    s_3D.shader(m_earthShader);

    s_3D.fill(255);
    s_3D.translate(m_earthPos.x, m_earthPos.y, m_earthPos.z);
    s_3D.rotateX(m_earthRotation.x);
    s_3D.rotateY(m_earthRotation.y);

    s_3D.shape(m_earthModel);
    s_3D.resetShader();
    s_3D.popMatrix();

    drawMarkersAndConnections();
    drawMarkerText();

    s_3D.endDraw();

    image(s_3D, 0, 0);
  }

  void drawMarkersAndConnections() {
    s_3D.strokeWeight(ARC_SIZE);
    s_3D.noFill();
    float count = m_allAirportPoints.size();

    s_3D.pushMatrix();
    s_3D.translate(m_earthPos.x, m_earthPos.y, m_earthPos.z);
    s_3D.rotateX(m_earthRotation.x);
    s_3D.rotateY(m_earthRotation.y);

    for (int i = 0; i < count; i++) {
      AirportPointType point = m_allAirportPoints.get(i);
      PVector endline = point.Pos.copy().mult(1.05f);

      s_3D.stroke(point.Color);
      s_3D.line(point.Pos.x, point.Pos.y, point.Pos.z, endline.x, endline.y, endline.z);

      s_3D.stroke(255, 255, 255, 255);
      drawGreatCircleArcFast(point);
    }

    s_3D.fill(255);
    s_3D.noStroke();
    s_3D.popMatrix();
  }

  void drawMarkerText() {
    s_3D.fill(255, 255, 255, 255);
    s_3D.textAlign(CENTER);
    s_3D.textSize(10);

    float count = m_allAirportPoints.size();
    for (int i = 0; i < count; i++) {
      AirportPointType point1 = m_allAirportPoints.get(i);
      int verticalDisplacement = point1.Pos.y > 0 ? 15 : -15;

      s_3D.pushMatrix();
      s_3D.translate(m_earthPos.x, m_earthPos.y + verticalDisplacement, m_earthPos.z + 10);
      s_3D.rotateX(m_earthRotation.x);
      s_3D.rotateY(m_earthRotation.y);
      s_3D.translate(point1.Pos.x, point1.Pos.y, point1.Pos.z);
      s_3D.rotateY(-m_earthRotation.y);

      s_3D.text(point1.Name, 0, 0);
      s_3D.popMatrix();
    }
  }

  public Event<MouseDraggedEventInfoType> getOnDraggedEvent() {
    return m_onDraggedEvent;
  }

  private void onDraggedHandler(MouseDraggedEventInfoType e) {
    PVector deltaDrag = new PVector( -(e.Y - e.PreviousPos.y) * 2, e.X - e.PreviousPos.x);
    deltaDrag.mult(s_deltaTime).mult(VERTICAL_DRAG_SPEED);
    m_earthRotationalVelocity.add(deltaDrag);
  }

  private AirportPointType manualAddPoint(double latitude, double longitude, String name) {
    PVector pos = coordsToPoint(latitude, longitude);
    AirportPointType point = new AirportPointType(pos, name);
    m_allAirportPoints.add(point);
    return point;
  }

  private PVector coordsToPoint(double latitude, double longitude) {
    float radius = EARTH_SPHERE_SIZE;

    float radLat = radians((float)latitude);
    float radLong = radians((float)(longitude+180));

    float x = radius * cos(radLat) * cos(radLong);
    float y = radius * -sin(radLat);
    float z = radius * cos(radLat) * sin(radLong);

    return new PVector(x, y, z);
  }

  void drawGreatCircleArcFast(AirportPointType point) {
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
          return;
        }

        s_3D.line(lastPos.x, lastPos.y, lastPos.z, pointOnArc.x, pointOnArc.y, pointOnArc.z);
        lastPos = pointOnArc.copy();
      }
    }
  }

  ArrayList<PVector> cacheArcPoints(PVector p1, PVector p2) {
    ArrayList<PVector> cacheResult = new ArrayList<PVector>();
    cacheResult.ensureCapacity(ARC_SEGMENTS+1);
    cacheResult.add(p1);

    for (int i = 1; i < ARC_SEGMENTS; i++) {
      float t = i / (float)ARC_SEGMENTS;
      float bonusHeight = ARC_HEIGHT_MULT * t * (1-t) + 1;
      PVector pointOnArc = slerp(p1, p2, t).mult(EARTH_SPHERE_SIZE * bonusHeight);
      cacheResult.add(pointOnArc);
    }

    cacheResult.add(p2);
    return cacheResult;
  }

  public void setArcGrowMillis(float timeTakenMillis, int delay) {
    m_arcStartGrowMillis = millis() + delay;
    m_arcGrowMillis = timeTakenMillis;
  }
}

// Descending code authorship changes:
// F. Wright, Created 3D flight map screen using OpenGL GLSL shaders and P3D features. Implemented light shading and day-night cycle, 9pm 07/03/24
// F. Wright, Fixed loading screen, 10am, 08/03/24
// F. Wright, Created latitude/longitude coords to 3D point converter and used geometric slerping to create arcs around the planet for connections between airports, 3pm 08/03/24
// F. Wright, Specular maps, vertical scrolling, bigger window, more constants, growing arcs over time, 3pm 09/03/24
