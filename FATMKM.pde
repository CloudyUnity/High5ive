ApplicationClass s_ApplicationClass = new ApplicationClass();
InputClass s_InputClass = new InputClass();
int s_deltaTime;

void setup() {
  size(600, 600);
  if (FULLSCREEN_ENABLED)
    fullScreen();
    
  surface.setTitle("Flight Thing");
  surface.setResizable(true);
  resizeWindow(700, 700);
    
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

void mousePressed() {
  s_ApplicationClass.onMouseClick();
}

void mouseMoved() {
  s_ApplicationClass.onMouseMoved();
}

void mouseDragged() {
  s_ApplicationClass.onMouseDragged();
}

void resizeWindow(int w, int h) {
  surface.setSize(w, h);
}
