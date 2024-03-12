import java.util.function.Function;
import java.util.function.Consumer;

class FlightMap2DUI extends Widget {

  private PImage m_mapImage;
  
  public FlightMap2DUI(int posX, int posY, int scaleX, int scaleY) {
    super(posX, posY, scaleX, scaleY);
    m_mapImage = loadImage("data/Images/EarthDay8kNoIce.jpg");
  }

  @ Override
    public void draw() {
    super.draw();
    
    fill(m_backgroundColour);
    image(m_mapImage, m_pos.x, m_pos.y, m_scale.x, m_scale.y);
  }
}


// M. Orlowski: Added this to not mess with anything else that uses the W_FlightMap map.
