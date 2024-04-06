// import processing.video.*;
// Movie earth;

class Star {
  int X;
  int Y;
  int Diameter;
  Star(int x, int y, int diameter) {
    X = x;
    Y = y;
    Diameter = diameter;
  }
}

/**
 * F. Wright
 *
 * Screen representing the home screen of the application.
 */

class ScreenHome extends Screen {

  PImage earthImage;
  PImage starImage;
  ImageUI earth;
  ImageUI star1;
  ImageUI star2;
  PVector earthPos;
  PVector starPos1;
  PVector starPos2;

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
    earthImage = loadImage("data/Images/earthTitleScreenTrans.png");
    starImage = loadImage("data/Images/stars_background.jpg");
    starPos1 = new PVector(0, 0);
    star1 = new ImageUI(starImage, (int)starPos1.x, (int)starPos1.y, (int)(((float)height/(float)starImage.height)*(float)starImage.width), (int)height);
    starPos2 = new PVector(-(int)(((float)height/(float)starImage.height)*(float)starImage.width), 0);
    star2 = new ImageUI(starImage, (int)starPos2.x, (int)starPos2.y, (int)(((float)height/(float)starImage.height)*(float)starImage.width), (int)height);
    println((int)(((float)height/(float)starImage.height)*(float)starImage.width), (int)height);

    addWidget(star1);
    addWidget(star2);
      
    float growScale = 1.05f;
    float totalSpacing = (float)height/4.0;
    float totalButtonSize = height-totalSpacing;
    float oneSpacingUnit = totalSpacing/4.0;
    float oneHSpacingUnit = (float)width/12.0;
    float oneButtonUnit = totalButtonSize/3.0;

    float imgScale = 0.7;
    earthPos = new PVector(((width/2)-((earthImage.width*imgScale)/2)-(oneHSpacingUnit)), (int)(height - (earthImage.height*imgScale))-(oneSpacingUnit*2));
    earth = new ImageUI(earthImage, (int)earthPos.x, (int)earthPos.y, (int)(earthImage.width*imgScale), (int)(earthImage.height*imgScale));
    addWidget(earth);
    earth.setGrowScale(1.1f);

    ButtonUI switchTo2D = createButton((int)width-(width/4), (int)oneSpacingUnit, (int)width/4 - 100, (int)oneButtonUnit);
    switchTo2D.setBackgroundColour(COLOR_BLACK);
    switchTo2D.setOutlineColour(COLOR_WHITE);
    switchTo2D.getOnClickEvent().addHandler(e -> switchScreen(e, SCREEN_TWOD_MAP_ID));
    switchTo2D.setText("2D Map");
    switchTo2D.setTextSize((int)((float)height/20.0));
    switchTo2D.setGrowScale(growScale);

    ButtonUI switchTo3D = createButton((int)width-(width/4), (int)((oneSpacingUnit*2)+oneButtonUnit), (int)width/4 - 100, (int)oneButtonUnit);
    switchTo3D.setBackgroundColour(COLOR_BLACK);
    switchTo3D.setOutlineColour(COLOR_WHITE);
    switchTo3D.getOnClickEvent().addHandler(e -> switchScreen(e, SCREEN_FLIGHT_MAP_ID));
    switchTo3D.setText("3D Globe");
    switchTo3D.setTextSize((int)((float)height/20.0));
    switchTo3D.setGrowScale(growScale);

    ButtonUI switchToCharts = createButton((int)width-(width/4), (int)((oneSpacingUnit*3)+(oneButtonUnit*2)), (int)width/4 - 100, (int)oneButtonUnit);
    switchToCharts.setBackgroundColour(COLOR_BLACK);
    switchToCharts.setOutlineColour(COLOR_WHITE);
    switchToCharts.getOnClickEvent().addHandler(e -> switchScreen(e, SCREEN_CHARTS_ID));
    switchToCharts.setText("Charts");
    switchToCharts.setTextSize((int)((float)height/20.0));
    
    LabelUI title = createLabel((int)oneSpacingUnit, (int)oneSpacingUnit, (int)((float)width/2.0), (int)((float)height/5.0), "High5ive");
    title.setCentreAligned(false);
    title.setTextSize((int)((float)height/10.0));   

    LabelUI subTitle = createLabel((int)(oneSpacingUnit*1.1), (int)((float)height/4.0), (int)((float)width/2.0), (int)((float)height/10.0), "Flights :)");
    subTitle.setForegroundColour(COLOR_LIGHT_GRAY);
    subTitle.setCentreAligned(false);
    subTitle.setTextSize((int)((float)height/20.0)); 

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

  public PVector moveStar(PVector star) {
    if (star.x > width) {
      star.x = -(int)(((float)height/(float)starImage.height)*(float)starImage.width);
    }
    if (star.x < -(int)(((float)height/(float)starImage.height)*(float)starImage.width)) {
      star.x = width;
    }
    star.x+=(10*((float)mouseX/(float)width))-5;
    return star;
  }

  @Override
  public void draw() {
    super.draw();
    earth.setPos(relitiveEarthPos(earthPos, 80));
    star1.setPos(moveStar(starPos1));
    star2.setPos(moveStar(starPos2));
    // println(starPos1, starPos2);
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
