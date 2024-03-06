import java.util.*;

class DebugFPSClass {
  private Deque<Integer> m_frameTimes = new LinkedList<Integer>();
  public int m_timeAtLastFrame = 0;
  
  public void addToFrameTimes(){
    if (m_frameTimes.size() >= DEBUG_FPS_COUNTER_STORAGE)
      m_frameTimes.removeFirst();
    
    int time = millis();
    m_frameTimes.addLast(time - m_timeAtLastFrame);
    m_timeAtLastFrame = time;
  }
  
  public double calculateFPS(){
    int total = 0;
    for (var frameTime : m_frameTimes){
      total += frameTime;
    }
    total /= DEBUG_FPS_COUNTER_STORAGE;
    
    double fps = 1.0 / (total / 1000.0);
    return Math.round(fps * 100) / 100.0;
  }
}

// Descending code authorship changes:
// F. Wright, Made FPS class to test performance of program, 6pm 06/03/24
