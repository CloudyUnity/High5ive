class ColorType {
  public int R, G, B, A;

  public ColorType(int r, int g, int b, int a) {
    R = r;
    G = g;
    B = b;
    A = a;
  }
}

class RenderClass {
  private TransformType m_cameraTransform = new TransformType();
  private ColorType m_backgroundColor;

  void init() {
  }

  void setBackgroundColor(ColorType bgColor) {
    m_backgroundColor = bgColor;
  }

  void render(ArrayList<GameObjectClass> goList) {
    background(m_backgroundColor.R, m_backgroundColor.G, m_backgroundColor.B, m_backgroundColor.A);

    for (var go : goList)
      go.render();
  }
}
