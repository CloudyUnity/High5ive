/**
 * F. Wright
 *
 * Class for profiling code execution time.
 */
class DebugProfilerClass {
  private Stack<Long> m_timerStack = new Stack<Long>();

  /**
   * F. Wright
   *
   * Starts a new profile timer.
   */
  public void startProfileTimer() {
    m_timerStack.push(System.nanoTime());
  }

  /**
   * F. Wright
   *
   * Prints the time taken in milliseconds since the last startProfileTimer() call.
   *
   * @param name The name of the profiled task.
   */
  public void printTimeTakenMillis(String name) {
    for (int i = 1; i < m_timerStack.size(); i++)
      print("-");

    double millis = (System.nanoTime() - m_timerStack.pop()) / (double)MILLI_TO_NANO;
    println("Milliseconds taken for " + name + " is " + millis);
  }

  /**
   * F. Wright
   *
   * Prints the time taken in seconds since the last startProfileTimer() call.
   *
   * @param name The name of the profiled task.
   */
  public void printTimeTakenSeconds(String name) {
    for (int i = 1; i < m_timerStack.size(); i++)
      print("-");

    double secs = (System.nanoTime() - m_timerStack.pop()) / (double)SECOND_TO_NANO;
    println("Seconds taken for " + name + " is " + secs);
  }
}

// Descending code authorship changes:
// F. Wright, Created and implemented DebugProfilerClass using a stack, 2pm 06/03/24
// F. Wright, Deleted DebugFPSClass, 9am 19/03/24
