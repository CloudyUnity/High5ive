class TransSquareType {
  public PVector Pos;
  public PVector Scale;
  public color Color;

  public TransSquareType(PVector pos, PVector scale, color col) {
    Pos = pos;
    Scale = scale;
    Color = col;
  }
}

class TransitionManagerClass {
  private long m_startTimeTrans = 0;
  private float m_transDur = 500.0f;
  private float m_positionalOffset = 25f;
  private boolean m_transitioning = true;
  private boolean m_detransitioning = true;
  private boolean m_inTransitionState = true;
  private PVector m_squareSize;

  private Consumer m_onTrans;

  TransSquareType[][] m_transSquareMatrix = new TransSquareType[20][10];

  public void init() {
    int columns = m_transSquareMatrix.length;
    int rows = m_transSquareMatrix[0].length;
    m_squareSize = new PVector(width/columns, height/rows);

    int color1 = CP_BLUE;
    int color2 = CP_LIGHT_BLUE;

    for (int i = 0; i < columns; i++) {
      for (int j = 0; j < rows; j++) {
        PVector pos = new PVector(i * m_squareSize.x, j * m_squareSize.y);
        int col = (i + j) % 2 == 0 ? color1 : color2;
        m_transSquareMatrix[i][j] = new TransSquareType(pos, m_squareSize, col);
      }
    }
  }

  public void startTransition() {
    m_startTimeTrans = millis();
    m_transitioning = true;
    m_detransitioning = false;
    m_inTransitionState = true;
  }

  public void startDetransition() {
    m_startTimeTrans = millis();
    m_transitioning = true;
    m_detransitioning = true;
  }

  public void setOnTrans(Consumer onTr) {
    m_onTrans = onTr;
  }

  public void frame() {
    if (!m_transitioning)
      return;

    int columns = m_transSquareMatrix.length;
    int rows = m_transSquareMatrix[0].length;
    PVector targetScale = m_detransitioning ? new PVector(0, 0) : m_squareSize;
    PVector inverseTargetScale = m_detransitioning ? m_squareSize : new PVector(0, 0);

    for (int i = 0; i < columns; i++) {
      for (int j = 0; j < rows; j++) {
        float offset = (i + j) * m_positionalOffset;
        float t = clamp((millis() - offset - m_startTimeTrans) / m_transDur, 0.0f, 1.0f);
        t = smoothstep(t);
        m_transSquareMatrix[i][j].Scale = PVector.lerp(inverseTargetScale, targetScale, t);
      }
    }

    float offset1 = (columns + rows - 2) * m_positionalOffset;
    float t1 = (millis() - offset1 - m_startTimeTrans) / m_transDur;
    if (t1 >= 1) {
      m_transitioning = false;

      if (m_detransitioning) {
        m_inTransitionState = false;
        m_detransitioning = false;
      } 
      else
        m_onTrans.accept(null);
    }
  }

  public void render() {
    int columns = m_transSquareMatrix.length;
    int rows = m_transSquareMatrix[0].length;

    stroke(CP_BLACK);

    for (int i = 0; i < columns; i++) {
      for (int j = 0; j < rows; j++) {
        PVector pos = m_transSquareMatrix[i][j].Pos;
        PVector scale = m_transSquareMatrix[i][j].Scale;
        color col = m_transSquareMatrix[i][j].Color;
        pos = pos.copy().sub(scale.copy().mult(0.5f)).add(m_squareSize.copy().mult(0.5f));

        fill(col);
        rect(pos.x, pos.y, scale.x, scale.y);
      }
    }   
  }

  public boolean getTransitionState() {
    return m_inTransitionState;
  }
}

//CKM had job taken by program
