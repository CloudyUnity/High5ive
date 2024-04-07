class FlightMap2DUI extends Widget {
  private int m_pointRadius = 3;
  private PImage m_mapImage;
  private HashMap<String, AirportPoint3DType> m_airportHashmap = new HashMap<String, AirportPoint3DType>();

  public FlightMap2DUI(int posX, int posY, int scaleY) {
    super(posX, posY, scaleY * 2, scaleY);
    m_mapImage = loadImage("data/Images/EarthDay2kNoIce.jpg");
  }

  // Draws the map
  @ Override
    public void draw() {
    super.draw();
  
    fill(m_backgroundColour);
    image(m_mapImage, m_pos.x, m_pos.y, m_scale.x, m_scale.y);
    
    fill(m_foregroundColour);
    drawAirportPoint(53.24491, -7.52348);
  }
  
  private PVector coordsTo2dPoint(double latitude, double longitude, int mapHeight) {
    int xpos = (int)((double)(mapHeight /180.0) * (180.0 + longitude));
    int ypos = (int)((double)(mapHeight /180.0) *  (90.0 - latitude));
    
    return new PVector(xpos, ypos);
  }

  void drawAirportPoint(double latitude, double longitude)
  {
    PVector point = coordsTo2dPoint(latitude, longitude, (int)m_scale.y);
    ellipseMode(RADIUS);
    circle(m_pos.x + point.x, m_pos.y + point.y, m_pointRadius);
  }
  
  public void loadFlights(FlightType[] flights, QueryManagerClass queries) {
    
  }
  
  private AirportPoint3DType manualAddPoint(double latitude, double longitude, String code) {
    PVector pos = coordsTo2dPoint(latitude, longitude, (int)m_scale.y);
    pos.x += m_pos.x;
    pos.y += m_pos.y;
    
    AirportPoint3DType point = new AirportPoint3DType(pos, code);
    m_airportHashmap.put(code, point);

    point.Color = color(COLOR_3D_MARKER);

    return point;
  }
  
  public void setPointRadius(int pointRadius) {
    m_pointRadius = pointRadius;
  }
}


// M. Orlowski: Added this to not mess with anything else that uses the W_FlightMap map.