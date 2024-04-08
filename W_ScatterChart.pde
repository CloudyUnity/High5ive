/**
 * F. Wright
 *
 * Scatter plot for representing data
 */
class ScatterChartUI<T> extends Widget implements IChart2Axis<T, Integer> {
  private PShape m_pointsShape = null;
  private String m_labelX = "X-axis", m_labelY = "Y-axis";
  private int m_maxValX, m_maxValY;

  private QueryType m_qtX = null, m_qtY = null;

  /**
   * F. Wright
   *
   * Constructs a new ScatterChartUI instance with the specified position and scale.
   *
   * @param posX The x-coordinate of the top-left corner of the scatter chart.
   * @param posY The y-coordinate of the top-left corner of the scatter chart.
   * @param scaleX The horizontal scale of the scatter chart.
   * @param scaleY The vertical scale of the scatter chart.
   */
  public ScatterChartUI(int posX, int posY, int scaleX, int scaleY) {
    super(posX, posY, scaleX, scaleY);
  }

  /**
   * F. Wright
   *
   * Adds data to the scatter chart using an array of elements and the specified functions to extract X and Y values.
   *
   * @param data An array of data elements.
   * @param getKeyX A function to extract X-axis values from the data elements.
   * @param getKeyY A function to extract Y-axis values from the data elements.
   */
  public void addData(T[] data, Function<T, Integer> getKeyX, Function<T, Integer> getKeyY) {
    removeData();

    m_maxValX = 0;
    m_maxValY = 0;
    for (var value : data) {
      Integer x = getKeyX.apply(value);
      Integer y = getKeyY.apply(value);

      if (x > m_maxValX)
        m_maxValX = x;

      if (y > m_maxValY)
        m_maxValY = y;
    }
    m_maxValX += 2;
    m_maxValY += 2;

    s_DebugProfiler.startProfileTimer();

    m_pointsShape.beginShape(POINTS);

    float strokeWeight = lerp(8.0f, 2.0f, data.length / 650_000.0f);
    m_pointsShape.strokeWeight(strokeWeight);

    HashSet<PVector> vectorHashSet = new HashSet<PVector>();

    for (var value : data) {
      Integer x = getKeyX.apply(value) + 1;
      Integer y = getKeyY.apply(value) + 1;

      PVector vec = new PVector(x, y);
      if (vectorHashSet.contains(vec))
        continue;
      vectorHashSet.add(vec);

      float fracX = x / (float)m_maxValX;
      float fracY = y / (float)m_maxValY;
      m_pointsShape.vertex(fracX * m_scale.x, (1 - fracY) * m_scale.y);
    }

    m_pointsShape.endShape();

    s_DebugProfiler.printTimeTakenMillis("Initialising scatter plot points into PShape");
  }

  /**
   * F. Wright
   *
   * Adds data to the scatter chart using an iterable collection of elements and the specified functions to extract X and Y values.
   *
   * @param data An iterable collection of data elements.
   * @param getKeyX A function to extract X-axis values from the data elements.
   * @param getKeyY A function to extract Y-axis values from the data elements.
   */
  public <I extends Iterable<T>> void addData(I data, Function<T, Integer> getKeyX, Function<T, Integer> getKeyY) {
    removeData();

    m_maxValX = 0;
    m_maxValY = 0;
    for (var value : data) {
      Integer x = getKeyX.apply(value);
      Integer y = getKeyY.apply(value);

      if (x > m_maxValX)
        m_maxValX = x;

      if (y > m_maxValY)
        m_maxValY = y;
    }
    m_maxValX += 2;
    m_maxValY += 2;

    s_DebugProfiler.startProfileTimer();

    m_pointsShape.beginShape(POINTS);

    HashSet<PVector> vectorHashSet = new HashSet<PVector>();

    for (var value : data) {
      Integer x = getKeyX.apply(value) + 1;
      Integer y = getKeyY.apply(value) + 1;

      PVector vec = new PVector(x, y);
      if (vectorHashSet.contains(vec))
        continue;
      vectorHashSet.add(vec);

      float fracX = x / (float)m_maxValX;
      float fracY = y / (float)m_maxValY;
      m_pointsShape.vertex(fracX * m_scale.x, (1 - fracY) * m_scale.y);
    }

    m_pointsShape.endShape();

    s_DebugProfiler.printTimeTakenMillis("Initialising scatter plot points into PShape");
  }

  /**
   * F. Wright
   *
   * Removes all data points from the scatter chart.
   */
  public void removeData() {
    m_pointsShape = createShape();
  }

  /**
   * F. Wright
   *
   * Sets the labels for the X and Y axes.
   *
   * @param x The label for the X-axis.
   * @param y The label for the Y-axis.
   */
  public void setAxisLabels(String x, String y) {
    m_labelX = x;
    m_labelY = y;
  }

  /**
   * F. Wright
   *
   * Sets the translation field and query manager for translating X values of the pie chart.
   *
   * @param query The query type for translation.
   * @param queryManager The query manager for fetching translation data.
   */
  public void setTranslationField(QueryType queryX, QueryType queryY) {
    m_qtX = queryX;
    m_qtY = queryY;
  }

  /**
   * F. Wright
   *
   * Draws the scatter plot
   */
  @ Override
    public void draw() {
    super.draw();

    fill(color(m_backgroundColour));
    rect(m_pos.x, m_pos.y, m_scale.x, m_scale.y, DEFAULT_WIDGET_ROUNDNESS_1);

    fill(getColor(0));
    text(m_labelX, m_pos.x, m_pos.y + m_scale.y - 20, m_scale.x, 100);

    pushMatrix();
    translate(m_pos.x - 20, m_pos.y + m_scale.y * 0.5f);
    rotate(radians(-90));
    translate(-m_scale.y * 0.5f, -100 * 0.5f);
    text(m_labelY, 0, 0, m_scale.y, 100);
    popMatrix();

    fill(getColor(1));
    text(formatValue(m_maxValX + "", m_qtX), m_pos.x + m_scale.x, m_pos.y + m_scale.y, 100, 50);

    fill(getColor(2));
    text(formatValue(m_maxValY + "", m_qtY), m_pos.x - 80, m_pos.y - 50, 100, 50);

    if (m_pointsShape == null)
      return;

    shape(m_pointsShape, m_pos.x, m_pos.y);
  }

  /**
   * F. Wright
   *
   * Translates X-axis values of the pie chart based on the set translation field and query manager.
   *
   * @param val The value to translate.
   * @return The translated value.
   */
  public String formatValue(String val, QueryType qt) {
    if (qt == null)
      return val;

    switch (qt) {
    case ARRIVAL_TIME:
    case SCHEDULED_ARRIVAL_TIME:
    case DEPARTURE_TIME:
    case SCHEDULED_DEPARTURE_TIME:
      String cleanTxt = val.replace(":", "");
      if (cleanTxt.length() == 3)
        return cleanTxt.charAt(0) + ":" + cleanTxt.substring(1, 3);
      else if (cleanTxt.length() == 4)
        return cleanTxt.substring(0, 2) + ":" + cleanTxt.substring(2, 4);

    default:
      return val;
    }
  }
}

// Descending code authorship changes:
// F. Wright, Created scatter plots, 7pm 20/03/24
// F. Wright, Added extra labelling to scatter plots, 8pm 25/03/24
