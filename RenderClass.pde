class RenderClass {
  private TransformType m_cameraTransform = new TransformType();
  private color m_backgroundColor;

  void init() {
  }

  void setBackgroundColor(color bgColor) {
    m_backgroundColor = bgColor;
  }

  void render(ArrayList<GameObjectClass> goList) {
    background(m_backgroundColor);

    for (var go : goList)
      go.render();
  }
}
