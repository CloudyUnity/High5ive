class ScatterChartUI<T> extends Widget implements IChart2Axis<T, Integer> {

  PShape m_pointsShape = null;
  String m_labelX = "X-axis", m_labelY = "Y-axis";

  public ScatterChartUI(int posX, int posY, int scaleX, int scaleY) {
    super(posX, posY, scaleX, scaleY);
  }

  public void addData(T[] data, Function<T, Integer> getKeyX, Function<T, Integer> getKeyY) {
    removeData();

    int maxValX = 0;
    int maxValY = 0;
    for (var value : data) {
      Integer x = getKeyX.apply(value);
      Integer y = getKeyY.apply(value);

      if (x > maxValX)
        maxValX = x;

      if (y > maxValY)
        maxValY = y;
    }
    maxValX += 2;
    maxValY += 2;

    s_DebugProfiler.startProfileTimer();

    m_pointsShape.beginShape(POINTS);

    for (var value : data) {
      Integer x = getKeyX.apply(value) + 1;
      Integer y = getKeyY.apply(value) + 1;
      float fracX = x / (float)maxValX;
      float fracY = y / (float)maxValY;
      m_pointsShape.vertex(fracX * m_scale.x, (1 - fracY) * m_scale.y);
    }

    m_pointsShape.endShape();

    s_DebugProfiler.printTimeTakenMillis("Initialising scatter plot points into PShape");
  }

  public <I extends Iterable<T>> void addData(I data, Function<T, Integer> getKeyX, Function<T, Integer> getKeyY) {
    removeData();

    int maxValX = 0;
    int maxValY = 0;
    for (var value : data) {
      Integer x = getKeyX.apply(value);
      Integer y = getKeyY.apply(value);

      if (x > maxValX)
        maxValX = x;

      if (y > maxValY)
        maxValY = y;
    }
    maxValX += 2;
    maxValY += 2;

    s_DebugProfiler.startProfileTimer();

    m_pointsShape.beginShape(POINTS);

    for (var value : data) {
      Integer x = getKeyX.apply(value) + 1;
      Integer y = getKeyY.apply(value) + 1;
      float fracX = x / (float)maxValX;
      float fracY = y / (float)maxValY;
      m_pointsShape.vertex(fracX * m_scale.x, (1 - fracY) * m_scale.y);
    }

    m_pointsShape.endShape();

    s_DebugProfiler.printTimeTakenMillis("Initialising scatter plot points into PShape");
  }

  public void removeData() {
    m_pointsShape = createShape();
  }
  
  public void setAxisLabels(String x, String y) {
    m_labelX = x;
    m_labelY = y;
  }

  @ Override
    public void draw() {
    super.draw();

    fill(color(m_backgroundColour));
    rect(m_pos.x, m_pos.y, m_scale.x, m_scale.y);

    fill(255);
    text(m_labelX, m_pos.x, m_pos.y + m_scale.y - 20, m_scale.x, 100);

    pushMatrix();
    translate(m_pos.x - 20, m_pos.y + m_scale.y * 0.5f);
    rotate(radians(-90));
    translate(-m_scale.y * 0.5f, -100 * 0.5f);
    text(m_labelY, 0, 0, m_scale.y, 100);
    popMatrix();

    if (m_pointsShape == null)
      return;

    shape(m_pointsShape, m_pos.x, m_pos.y);
  }
}
