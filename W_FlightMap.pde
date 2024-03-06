import java.util.function.Function;
import java.util.function.Consumer;

class FlightMapUI extends Widget {

  private PImage m_mapImage;
  
  public FlightMapUI(int posX, int posY, int scaleX, int scaleY) {
    super(posX, posY, scaleX, scaleY);
    m_mapImage = loadImage("data/Images/worldmap-countries-hd.jpg");
  }

  @ Override
    public void draw() {
    super.draw();
    
    fill(m_backgroundColour);
    image(m_mapImage, m_pos.x, m_pos.y, m_scale.x, m_scale.y);
  }
}
