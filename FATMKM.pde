ApplicationClass s_ApplicationClass = new ApplicationClass();
InputClass s_InputClass = new InputClass();

void setup()
{
  fullScreen();
  noStroke();

  s_ApplicationClass.init();
}

void draw()
{
  s_InputClass.frame();
  s_ApplicationClass.frame();

  if (DEBUG_MODE && s_InputClass.getKey('A'))
    println("A pressed");
}

void keyPressed()
{
  if (!keyPressed)
    return;
    
  s_InputClass.setKeyState(key, true);
}

void keyReleased()
{
  s_InputClass.setKeyState(key, false);
}
