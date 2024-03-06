import java.util.function.Function;
import java.util.function.Consumer;

class FlightMap3D extends Widget implements IDraggable {

  private Event<MouseDraggedEventInfoType> m_onDraggedEvent;

  public FlightMap3D(int posX, int posY, int scaleX, int scaleY) {
    super(posX, posY, scaleX, scaleY);
  }

  @ Override
    public void draw() {
    super.draw();

    s_3D.beginDraw();
    s_3D.line(20, 20, mouseX, mouseY);
    s_3D.sphere(280);
    s_3D.endDraw();
    
    image(s_3D, 0, 0);
  }

  public Event<MouseDraggedEventInfoType> getOnDraggedEvent() {
    return m_onDraggedEvent;
  }

  private void onDraggedHandler(MouseDraggedEventInfoType e) {
  }
}
