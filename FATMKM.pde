ApplicationClass s_ApplicationClass = new ApplicationClass();
InputClass s_InputClass = new InputClass();
int s_deltaTime;

void setup() {
  fullScreen();
  noStroke();
  frameRate(60);
  
  textFont(loadFont("AgencyFB-Bold-48.vlw"));

  s_ApplicationClass.init();
}

void draw() {
  s_InputClass.frame();
  s_ApplicationClass.frame();   
    
  pushMatrix();
  textAlign(CENTER);
  fill(255, 255, 255, 255);
  text("DeltaTime: " + s_deltaTime, width/2, height/2, 400f, 200f);
  popMatrix();
}

void keyPressed() {
  if (!keyPressed)
    return;

  s_InputClass.setKeyState(key, true);
}

void keyReleased() {
  s_InputClass.setKeyState(key, false);
}
