class PieChartUI<T, TData> extends Widget implements IChart<T, TData> {

  private TreeMap<TData, Integer> m_map = new TreeMap<TData, Integer>();
  private boolean m_dataLoaded = false;

  public PieChartUI(int posX, int posY, int diameter) {
    super(posX, posY, diameter, diameter);
  }

  public void addData(T[] data, Function<T, TData> getKey) {
    for (var value : data) {
      TData k = getKey.apply(value);
      Integer entryValue = m_map.get(k);

      if (entryValue == null)
        m_map.put(k, 1);
      else
        m_map.replace(k, entryValue + 1);
    }

    m_dataLoaded = true;
  }

  public <I extends Iterable<T>> void addData(I data, Function<T, TData> getKey) {
    for (var value : data) {
      TData k = getKey.apply(value);
      Integer entryValue = m_map.get(k);

      if (entryValue == null)
        m_map.put(k, 1);
      else
        m_map.replace(k, entryValue + 1);
    }

    m_dataLoaded = true;
  }

  public void removeData() {
    m_map = new TreeMap<TData, Integer>();
    m_dataLoaded = false;
  }

  @ Override
  public void draw() {
    super.draw();
    if (!m_dataLoaded)
      return;
      
    int total = 0;
    for (var val : m_map.values()){
      total += val;
    }
    
    float lastAngle = 0;
    int i = 0;
    for (var val : m_map.values()) {
      float arcSize = 2 * PI * (val / (float)total); 
      fill(randomColor(i));
      arc(m_pos.x, m_pos.y, m_scale.x, m_scale.x, lastAngle, lastAngle + arcSize, PIE);
      lastAngle += arcSize;
      i++;
    }    
  }
  
  private color randomColor(int seed){
    randomSeed(seed * 4639);
    colorMode(HSB, 360, 100, 100);
    color result = color(random(360), random(100), random(100));
    colorMode(RGB, 255, 255, 255);
    return result;
  }
}
