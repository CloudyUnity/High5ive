class ApplicationClass {
  private ArrayList<GameObjectClass> m_goList = new ArrayList<GameObjectClass>();
  private RenderClass m_renderClass = new RenderClass();
  private int m_timeLastFrame = 0;
  private int m_fixedFrameCounter = 0;

  void init() {
    m_renderClass.init();
    m_renderClass.setBackgroundColor(color(150, 150, 150, 255));

    // This is where everything in the game is created and initialised

    GameObjectClass player = initGameObject("Player");
    player.setPosition(19, 8, 7);
  }

  void frame() {
    s_deltaTime = millis() - m_timeLastFrame;
    m_timeLastFrame = millis();
    
    for (var go : m_goList)
      go.frame();
      
    if (m_fixedFrameCounter < millis()) {
      fixedFrame();
      m_fixedFrameCounter += FIXED_FRAME_INCREMENT;
    }

    m_renderClass.render(m_goList);
  }
  
  void fixedFrame() {
    for (var go : m_goList)
      go.fixedFrame();
  }

  // This will also include all sprites/models/shaders/textures/etc
  GameObjectClass initGameObject(String name) {
    GameObjectClass go = new GameObjectClass(name);
    m_goList.add(go);
    return go;
  }
}
