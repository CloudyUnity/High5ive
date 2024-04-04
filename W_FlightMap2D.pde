class FlightMap2DUI extends Widget {

  private PImage m_mapImage;

  public FlightMap2DUI(int posX, int posY, int scaleX, int scaleY) {
    super(posX, posY, scaleX, scaleY);
    m_mapImage = loadImage("data/Images/EarthDay2kNoIce.jpg");
  }

  // Draws the map
  @ Override
    public void draw() {
    super.draw();

    fill(m_backgroundColour);
    image(m_mapImage, 250, 0, (displayWidth-250), (displayHeight-125));
  }

  public void loadFlights(FlightType[] flights, QueryManagerClass queries) {
  }

  void drawAirportPoint(int longitude, int lat)
  {
    int xpos = ((displayWidth/2) + 100 ) + longitude/180*(displayWidth  -  ((displayWidth/2) +100)) ;
    int ypos = ((displayHeight- 100) / 2) + lat/90*((displayHeight-100) -((displayHeight-100)/2));
    circle(xpos, ypos, 3);
  }
}


// M. Orlowski: Added this to not mess with anything else that uses the W_FlightMap map.
