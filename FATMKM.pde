ApplicationClass s_ApplicationClass = new ApplicationClass();

void setup()
{
  fullScreen();
  noStroke();
  
  s_ApplicationClass.init();
}

void draw()
{
  s_ApplicationClass.frame();
}
