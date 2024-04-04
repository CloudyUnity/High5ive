/**
 * F. Wright
 *
 * Represents a Pie Chart user interface widget.
 *
 * @param <T>     The type of data for the chart.
 * @param <TData> The type of the data key.
 * @extends Widget
 * @implements IChart<T, TData>
 */
class PieChartUI<T, TData> extends Widget implements IChart<T, TData> {
  private TreeMap<TData, Integer> m_map = new TreeMap<TData, Integer>();
  private ArrayList<Float> m_arcSizes = new ArrayList<Float>();
  private boolean m_dataLoaded = false;

  private QueryType m_translationField = null;
  private QueryManagerClass m_queryManager = null;

  /**
   * F. Wright
   *
   * Initializes a new instance of the PieChartUI class.
   *
   * @param posX     The x-coordinate of the top-left corner of the widget.
   * @param posY     The y-coordinate of the top-left corner of the widget.
   * @param diameter The diameter of the pie chart.
   */
  public PieChartUI(int posX, int posY, int diameter) {
    super(posX, posY, diameter, diameter);
  }

  /**
   * F. Wright
   *
   * Adds data to the pie chart.
   *
   * @param data  The array of data to be added.
   * @param getKey The function to extract the key from each data element.
   */
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

  /**
   * F. Wright
   *
   * Adds data to the pie chart from an iterable collection.
   *
   * @param <I>   The type of the iterable collection.
   * @param data  The iterable collection of data to be added.
   * @param getKey The function to extract the key from each data element.
   */
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

  /**
   * F. Wright
   *
   * Removes all data from the pie chart.
   */
  public void removeData() {
    m_map = new TreeMap<TData, Integer>();
    m_arcSizes.clear();
    m_dataLoaded = false;
  }

  /**
   * F. Wright
   *
   * Draws the pie chart on the screen.
   */
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

  /**
   * F. Wright
   *
   * Generates a random color based on a given seed.
   *
   * @param seed The seed value for generating the color.
   * @return The generated color.
   */
  private color randomColor(int seed) {
    randomSeed(seed * 4639);
    colorMode(HSB, 360, 100, 100);
    color result = color(random(360), random(100), random(100));
    colorMode(RGB, 255, 255, 255);
    return result;
  }

  /**
   * F. Wright
   *
   * Sets the translation field and query manager for translating X values of the pie chart.
   *
   * @param query The query type for translation.
   * @param queryManager The query manager for fetching translation data.
   */
  public void setTranslationField(QueryType query, QueryManagerClass queryManager) {
    m_translationField = query;
    m_queryManager = queryManager;
  }

  /**
   * F. Wright
   *
   * Translates X-axis values of the pie chart based on the set translation field and query manager.
   *
   * @param val The value to translate.
   * @return The translated value.
   */
  public String translateXValues(String val) {
    if (m_translationField == null)
      return val;

    switch (m_translationField) {
    case CANCELLED:
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
