import java.util.Stack;

// This class is used for debug purposes only
// Start the timer before beginning a task. Then once it's complete print the time using the printTimeTakenMillis() function
// This uses a stack so you don't need to worry about possible overwriting or nested profilings.
class DebugProfilerClass { 
  private Stack<Long> m_timerStack = new Stack<Long>();
  
  public void startProfileTimer(){
    m_timerStack.push(System.nanoTime());
  }
  
  public void printTimeTakenMillis(String name){    
    for (int i = 1; i < m_timerStack.size(); i++)
      print("-");
      
    double millis = (System.nanoTime() - m_timerStack.pop()) / (double)MILLI_TO_NANO;
    println("Milliseconds taken for " + name + " is " + millis);
  }
  
  public void printTimeTakenSeconds(String name){    
    for (int i = 1; i < m_timerStack.size(); i++)
      print("-");
      
    double secs = (System.nanoTime() - m_timerStack.pop()) / (double)SECOND_TO_NANO;
    println("Seconds taken for " + name + " is " + secs);
  }
}

// Descending code authorship changes:
// F. Wright, Created and implemented DebugProfilerClass using a stack, 2pm 06/03/24
