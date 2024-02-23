class ApplicationClass {
  private ArrayList<GameObjectClass> m_goList = new ArrayList<GameObjectClass>();
  private RenderClass m_renderClass = new RenderClass();
  private int m_timeLastFrame = 0;

  public ApplicationClass() {
  }

  void init() {
    m_renderClass.init();
    m_renderClass.setBackgroundColor(new ColorType(150, 150, 150, 255));

    // This is where everything in the game is created and initialised

    GameObjectClass player = initGameObject("Player");
    player.setPosition(19, 8, 7);
  }

  void frame() {
    s_deltaTime = millis() - m_timeLastFrame;
    m_timeLastFrame = millis();
    
    for (var go : m_goList)
      go.frame();

    m_renderClass.render(m_goList);
  }

  // This will also include all sprites/models/shaders/textures/etc
  GameObjectClass initGameObject(String name) {
    GameObjectClass go = new GameObjectClass(name);
    m_goList.add(go);
    return go;
  }
}
