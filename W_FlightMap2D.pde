class FlightMap2DUI extends Widget {

  private PImage m_mapImage;

  public FlightMap2DUI(int posX, int posY, int scaleX, int scaleY) {
    super(posX, posY, scaleX, scaleY);
    m_mapImage = loadImage("data/Images/EarthDay2kNoIce.jpg");
  }

  @ Override
    public void draw() {
    super.draw();

    fill(m_backgroundColour);
    image(m_mapImage, 200, 0, (displayWidth-200), (displayHeight-100));
  }
}


// M. Orlowski: Added this to not mess with anything else that uses the W_FlightMap map.
