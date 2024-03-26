class PieChartUI<T, TData> extends Widget implements IChart<T, TData> {
  private TreeMap<TData, Integer> m_map = new TreeMap<TData, Integer>();
  private ArrayList<Float> m_arcSizes = new ArrayList<Float>();
  private boolean m_dataLoaded = false;

  private QueryType m_translationField = null;
  private QueryManagerClass m_queryManager = null;

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

      m_arcSizes.add(1.0f);
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

      m_arcSizes.add(1.0f);
    }

    m_dataLoaded = true;
  }

  public void removeData() {
    m_map = new TreeMap<TData, Integer>();
    m_arcSizes.clear();
    m_dataLoaded = false;
  }

  @ Override
    public void draw() {
    super.draw();
    if (!m_dataLoaded)
      return;

    int total = 0;
    for (var val : m_map.values()) {
      total += val;
    }

    float lastAngle = 0;
    int i = 0;
    for (Map.Entry<TData, Integer> entry : m_map.entrySet()) {
      float arcSize = 2 * PI * (entry.getValue() / (float)total);
      fill(randomColor(i));

      float diameterOfArc = m_scale.x * m_arcSizes.get(i);

      boolean isHovered = false;
      if (pointWithinSector(m_pos, mouseX, mouseY, diameterOfArc, lastAngle, lastAngle + arcSize))
        isHovered = true;

      float growTarget = isHovered ? 1.1f : 1.0f;
      m_arcSizes.set(i, lerp(m_arcSizes.get(i), growTarget, 0.2f));

      arc(m_pos.x, m_pos.y, diameterOfArc, diameterOfArc, lastAngle, lastAngle + arcSize, PIE);

      if (isHovered) {
        float middleAngle = lastAngle + (arcSize * 0.5f);
        float textPosX = m_pos.x + (cos(middleAngle) * diameterOfArc * 1.3f);
        float textPosY = m_pos.y + (sin(middleAngle) * diameterOfArc * 1.3f);
        fill(255);
        textAlign(CENTER);
        text(translateXValues(entry.getKey().toString()), textPosX, textPosY);
      }

      lastAngle += arcSize;
      i++;
    }
  }

  private color randomColor(int seed) {
    randomSeed(seed * 4639);
    colorMode(HSB, 360, 100, 100);
    color result = color(random(360), random(100), random(100));
    colorMode(RGB, 255, 255, 255);
    return result;
  }

  public void setTranslationField(QueryType query, QueryManagerClass queryManager) {
    m_translationField = query;
    m_queryManager = queryManager;
  }

  public String translateXValues(String val) {
    if (m_translationField == null)
      return val;

    switch (m_translationField) {
    case CANCELLED_OR_DIVERTED:
      return val.equals("0") ? "None" :
        val.equals("1") ? "Cancelled" : "Diverted";
    case CARRIER_CODE_INDEX:
      return m_queryManager.getAirlineName(Integer.parseInt(val));
    case AIRPORT_ORIGIN_INDEX:
    case AIRPORT_DEST_INDEX:
      return m_queryManager.getCode(Integer.parseInt(val));
    default:
      return val;
    }
  }
}

// Descending code authorship changes:
// F. Wright, Created pie chart class, 5pm 19/03/24
// F. Wright, Implemented juiciness to pie chart, 1pm, 20/03/24
