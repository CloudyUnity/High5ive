ApplicationClass s_ApplicationClass = new ApplicationClass();
InputClass s_InputClass = new InputClass();
DebugProfilerClass s_DebugProfiler = new DebugProfilerClass();
PGraphics s_3D;
int s_deltaTime;

void setup() {
  fullScreen(P2D, SPAN);

  s_DebugProfiler.startProfileTimer();
  
  surface.setTitle("Flight Thing");
  surface.setResizable(!FULLSCREEN_ENABLED);
  surface.setLocation(0, 0);

  frameRate(FRAME_RATE);

  textFont(createFont("Century Gothic Bold", 48, true));

  s_3D = createGraphics((int)WINDOW_SIZE_3D_FLIGHT_MAP.x, (int)WINDOW_SIZE_3D_FLIGHT_MAP.y, P3D);  

  s_ApplicationClass.init();
  
  s_DebugProfiler.printTimeTakenMillis("All Setup");
}

void draw() {
  s_InputClass.frame();
  s_ApplicationClass.frame();
}

void keyPressed() {
  if (!keyPressed)
    return;

  s_InputClass.setKeyState(key, true);
  s_ApplicationClass.onKeyPressed(key, keyCode);
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
void mouseWheel(MouseEvent event) {

  s_ApplicationClass.onMouseWheel(event);

}
void resizeWindow(int w, int h) {
  surface.setSize(w, h);
}

// Descending code authorship changes:
// F. Wright, Made setup(), draw(), 8pm 23/02/24
// F. Wright, Made input functions for use in InputClass such as keyPressed(), 9pm 23/02/24
// F. Wright, Made mouse related functions for use in ApplicationClass and Widgets. Set up window resizing, 6pm 04/03/24
// F. Wright, Modified and simplified UI code to fit coding standard. Combined all UI elements into the UI tab, 6pm 04/03/24
// F. Wright, Used symbolic linking to allow us to put all UI pde files into subfolder, 11pm 05/03/24
// M. Poole, Modified to add to add mouseWheel(), 1pm 12/3/24 
// CKM, implemented working fullscreen 15:00 12/03
