class TransformType {
  public PVector Pos;
  public PVector Rot;
  public PVector Scale;

  public TransformType Parent = null;
}

class GameObjectClass {
  private TransformType m_transform;
  private color m_color = DEFAULT_COLOR;
  private String m_nameIdentifier = DEFAULT_GAMEOBJECT_NAME;
  private boolean m_renderingEnabled = true;
  // PImage or PShape depending on 2D or 3D

  public GameObjectClass(String name) {
    m_transform = new TransformType();
    m_nameIdentifier = name;
  }

  public void setPosition(float x, float y, float z) {
    m_transform.Pos = new PVector(x, y, z);
  }

  public void setRotation(float x, float y, float z) {
    m_transform.Rot = new PVector(x, y, z);
  }

  public void setScale(float x, float y, float z) {
    m_transform.Scale = new PVector(x, y, z);
  }

  public void setParent(TransformType trans) {
    m_transform.Parent = trans;
  }

  public void frame() {
    // Meant to be overriden
  }

  public void fixedFrame() {
    // Meant to be overriden
  }

  public void render() {
    pushMatrix();
    fill(m_color);

    // Render gameobject by applying transform

    popMatrix();
  }
}
