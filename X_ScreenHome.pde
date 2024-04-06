// import processing.video.*;
// Movie earth;
/**
 * F. Wright
 *
 * Screen representing the home screen of the application.
 */

class ScreenHome extends Screen {

  PImage earthImage;
  ImageUI earth;
  PVector lastMousePos;
  PVector mousePos;
  PVector earthPos;

  /**
   * F. Wright
   *
   * Constructs a new instance of ScreenHome with the given screen ID.
   *
   * @param screenId The unique identifier for the screen.
   */
  public ScreenHome(String screenId) {
    super(screenId, DEFAULT_SCREEN_COLOUR);
  }


  /**
   * F. Wright
   *
   * Initializes the screen by adding UI elements and setting their properties.
   */

  @Override
    public void init() {
    super.init();
    earthImage = loadImage("data/Images/earthTitleScreen.png");

    float imgScale = 0.7;
    int pixelsFromSide = 75;
    earthPos = new PVector(((width/2)-((earthImage.width*imgScale)/2)-100), (int)(height - (earthImage.height*imgScale))-pixelsFromSide);
    earth = new ImageUI(earthImage, (int)earthPos.x, (int)earthPos.y, (int)(earthImage.width*imgScale), (int)(earthImage.height*imgScale));
    mousePos = new PVector(mouseX, mouseY);
    lastMousePos = new PVector(mouseX, mouseY);
    addWidget(earth);
    earth.setGrowScale(1.1f);

    float growScale = 1.05f;

    ButtonUI switchTo2D = createButton((int)width-(width/4), 100, (int)width/4 - 100, 200);
    switchTo2D.setBackgroundColour(COLOR_BLACK);
    switchTo2D.setOutlineColour(COLOR_WHITE);
    switchTo2D.getOnClickEvent().addHandler(e -> switchScreen(e, SCREEN_TWOD_MAP_ID));
    switchTo2D.setText("2D Map");
    switchTo2D.setTextSize(50);
    switchTo2D.setGrowScale(growScale);

    ButtonUI switchTo3D = createButton((int)width-(width/4), 400, (int)width/4 - 100, 200);
    switchTo3D.setBackgroundColour(COLOR_BLACK);
    switchTo3D.setOutlineColour(COLOR_WHITE);
    switchTo3D.getOnClickEvent().addHandler(e -> switchScreen(e, SCREEN_FLIGHT_MAP_ID));
    switchTo3D.setText("3D Globe");
    switchTo3D.setTextSize(50);
    switchTo3D.setGrowScale(growScale);

    ButtonUI switchToCharts = createButton((int)width-(width/4), 700, (int)width/4 - 100, 200);
    switchToCharts.setBackgroundColour(COLOR_BLACK);
    switchToCharts.setOutlineColour(COLOR_WHITE);
    switchToCharts.getOnClickEvent().addHandler(e -> switchScreen(e, SCREEN_CHARTS_ID));
    switchToCharts.setText("Charts");
    switchToCharts.setTextSize(50);

    // LabelUI name = createLabel(100, 100, 200, 100, "High5ive");
    // name.setCentreAligned(true);
    // name.setTextSize(40);
    
    LabelUI title = createLabel(100, 100, (int)width/2, 200, "High5ive");
    title.setCentreAligned(false);
    title.setTextSize(175);   

    LabelUI subTitle = createLabel(110, 300, (int)width/2, 100, "Flights :)");
    subTitle.setForegroundColour(COLOR_LIGHT_GRAY);
    subTitle.setCentreAligned(false);
    subTitle.setTextSize(64); 

    switchToCharts.setGrowScale(growScale);
  }

  public PVector moveEarthPosInd(PVector earthPos, PVector mousePos, PVector lastMousePos, int wigglePower, int strength) {
    PVector wiggleStrength = mousePos.sub(lastMousePos).mult(wigglePower);
    PVector totalStrength = wiggleStrength.mult(strength).mult((sin(wiggleStrength.x) + sin(wiggleStrength.y))/2);
    return totalStrength;
  }

  public PVector moveEarthPos(PVector earthPos, PVector mousePos, PVector lastMousePos, int wigglePower, int scaler) { 
    PVector movement = moveEarthPosInd(earthPos, mousePos, lastMousePos, wigglePower, 8);
    return movement.normalize().mult(scaler).add(earthPos);
  }

  public PVector relitiveEarthPos(PVector earthPos, float strength) {
    PVector addition = new PVector(((float)mouseX/(float)width), ((float)mouseY/(float)height));
    return addition.mult(strength).add(earthPos);
  }

  // public PVector idelEarthPos(PVector earthPos, float strength) {
  //   PVector
  // }

  @Override
  public void draw() {
    super.draw();
    mousePos = new PVector(mouseX, mouseY); 
    PVector temp = relitiveEarthPos(earthPos, 80);
    earth.setPos(temp);
    lastMousePos = mousePos;
  }
}

// Descending code authorship changes:
// A. Robertson, Wrote Screen1 and Screen2 presets
// F. Wright, Modified and simplified code to fit coding standard. Fixed checkbox issues with colours, 6pm 04/03/24
// F. Wright, Refactored screen, presets and applied grow mode to relevant widgets, 1pm 07/03/24
// F. Wright, Created 3D flight map screen using OpenGL GLSL shaders and P3D features. Implemented light shading and day-night cycle, 9pm 07/03/24
// M. Orlowski, Worked on 2D Map Button, 1pm 12/03/2024
// CKM, reintroduced some code that was overwritten, 14:00 12/03
// CKM, implemented spin control for 3D map, 10:00 13/03
// M. Orlowski, Added 2D calls, 12:00 13/03
// M. Poole added TextBoxes and removed background 5pm 13/03
// F.Wright Split HomeScreen into new File 26/03
// CKM, fixed reversion issue, 17:00 28/03
