ApplicationClass s_ApplicationClass = new ApplicationClass();
InputClass s_InputClass = new InputClass();
int s_deltaTime;

void setup() {
  fullScreen();
  noStroke();
  frameRate(FRAME_RATE);
  
  textFont(loadFont("AgencyFB-Bold-48.vlw"));

  s_ApplicationClass.init();
}

void draw() {
  s_InputClass.frame();
  s_ApplicationClass.frame();       
}

void keyPressed() {
  if (!keyPressed)
    return;   

  s_InputClass.setKeyState(key, true);
}

void keyReleased() {
  s_InputClass.setKeyState(key, false);
}
