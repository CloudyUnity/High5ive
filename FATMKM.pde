ApplicationClass s_ApplicationClass = new ApplicationClass();
InputClass s_InputClass = new InputClass();
DebugProfilerClass s_DebugProfiler = new DebugProfilerClass();
PGraphics s_3D;
int s_deltaTime;

void setup() {
  size(600, 600, P2D);
  if (FULLSCREEN_ENABLED)
    fullScreen();

  surface.setTitle("Flight Thing");
  surface.setResizable(true);
  surface.setLocation(0, 0);

  frameRate(FRAME_RATE);

  textFont(loadFont("data/Fonts/AgencyFB-Bold-48.vlw"));

  s_3D = createGraphics(width, height, P3D);  

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

// Descending code authorship changes:
// F. Wright, Made setup(), draw(), 8pm 23/02/24
// F. Wright, Made input functions for use in InputClass such as keyPressed(), 9pm 23/02/24
// F. Wright, Made mouse related functions for use in ApplicationClass and Widgets. Set up window resizing, 6pm 04/03/24
// F. Wright, Modified and simplified UI code to fit coding standard. Combined all UI elements into the UI tab, 6pm 04/03/24
// F. Wright, Used symbolic linking to allow us to put all UI pde files into subfolder, 11pm 05/03/24
