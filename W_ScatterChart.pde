class ScatterChartUI<T> extends Widget implements IChart2Axis<T, Integer> {

  PShape m_pointsShape = null;
  
  public ScatterChartUI(int posX, int posY, int scaleX, int scaleY){
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
    
    m_pointsShape.beginShape(POINTS);
    
    for (var value : data) {
      Integer x = getKeyX.apply(value) + 1;
      Integer y = getKeyY.apply(value) + 1;
      float fracX = x / (float)maxValX;
      float fracY = y / (float)maxValY;            
      m_pointsShape.vertex(fracX * m_scale.x, (1 - fracY) * m_scale.y);
    }
    
    m_pointsShape.endShape();
  }

  public <I extends Iterable<T>> void addData(I data, Function<T, Integer> getKeyX, Function<T, Integer> getKeyY) {
    removeData();
    
    m_pointsShape.beginShape(POINTS);
    
    for (var value : data) {
      Integer x = getKeyX.apply(value);
      Integer y = getKeyY.apply(value);
      m_pointsShape.vertex(x, y);
    }
    
    m_pointsShape.endShape();
  }

  public void removeData() {
     m_pointsShape = createShape();
  }

  @ Override
    public void draw() {
    super.draw();        

    fill(color(m_backgroundColour));
    rect(m_pos.x, m_pos.y, m_scale.x, m_scale.y);
    
    if (m_pointsShape == null)
      return;
    
    shape(m_pointsShape, m_pos.x, m_pos.y);
  }
}
