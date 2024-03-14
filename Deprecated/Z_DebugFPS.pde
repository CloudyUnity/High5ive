/*class DebugFPSClass {
 private Deque<Integer> m_frameTimes = new LinkedList<Integer>();
 public int m_timeAtLastFrame = 0;
 
 public void addToFrameTimes(){
 if (m_frameTimes.size() >= DEBUG_FPS_COUNTER_STORAGE)
 m_frameTimes.removeFirst();
 
 int time = millis();
 m_frameTimes.addLast(time - m_timeAtLastFrame);
 m_timeAtLastFrame = time;
 }
 
 public float calculateFPS(){
 int total = 0;
 for (var frameTime : m_frameTimes){
 total += frameTime;
 }
 total /= DEBUG_FPS_COUNTER_STORAGE;
 
 float fps = 1.0 / (total / 1000.0);
 return round(fps * 100.0f) / 100.0f;
 }
 }
 */

// Descending code authorship changes:
// F. Wright, Made FPS class to test performance of program, 6pm 06/03/24
// CKM, Used native framerate function, 15:00 14/03.
// CKM, Relocated to Debug Class
