final int SCREEN_WIDTH = 600;
final int SCREEN_HEIGHT = 600;
final String SCREEN1_ID = "Screen 1";
final String SCREEN2_ID = "Screen 2";


ArrayList<Screen> screens;
Screen currentScreen;
Event<SwitchScreenEventInfo> onSwitchScreen;

void settings() {
  size(SCREEN_WIDTH, SCREEN_HEIGHT);
}

void setup() {
  screens = new ArrayList<Screen>();
  onSwitchScreen = new Event<SwitchScreenEventInfo>();
  onSwitchScreen.addHandler(e -> switchScreen(e));
  
  Screen1 s1 = new Screen1(SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN1_ID);
  Screen2 s2 = new Screen2(SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN2_ID);

  screens.add(s1);  
  screens.add(s2);
  currentScreen = screens.get(0);
}

void draw() {
  background(220);
  currentScreen.draw();
}

void mousePressed() {
  EventInfo onClickInfo = new EventInfo(mouseX, mouseY, currentScreen);
  currentScreen.getOnClickEvent().raise(onClickInfo);
}

void mouseMoved() {
  MouseMovedEventInfo e = new MouseMovedEventInfo(mouseX, mouseY, pmouseX, pmouseY, currentScreen);
  currentScreen.getOnMouseMovedEvent().raise(e);
}

void mouseDragged() {
  MouseDraggedEventInfo e = new MouseDraggedEventInfo(mouseX, mouseY, pmouseX, pmouseY, currentScreen);
  currentScreen.getOnMouseDraggedEvent().raise(e);
}

void switchScreen(SwitchScreenEventInfo e) {
  e.widget.getOnMouseExitEvent().raise((EventInfo)e);
  for (Screen screen : screens)
    if (e.newScreenId.compareTo(screen.getScreenId()) == 0)
      currentScreen = screen;
}
