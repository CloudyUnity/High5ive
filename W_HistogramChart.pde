class HistogramChartUI<T, TData> extends Widget implements IChart<T, TData> {
  private TreeMap<TData, Integer> m_map;
  private Integer m_maxValue = -1; // Can be null
  private Integer m_barWidth = -1; // Can be null
  private int m_bottomPadding = 0;
  private int m_topPadding = 0;
  private int m_sidePadding = 0;
  private Integer m_maxScaleValue = 1;
  private Integer m_scaleInterval = 1;
  private String m_title = "Histogram", m_labelX = "X-axis", m_labelY = "Frequency";
  private int m_numberTextBoxWidth = 0;
  private int m_numberTextBoxHeight = 0;

  private QueryType m_translationField = null;
  private QueryManagerClass m_queryManager = null;

  public HistogramChartUI(int posX, int posY, int scaleX, int scaleY) {
    super(posX, posY, scaleX, scaleY);
    m_map = new TreeMap<TData, Integer>();
    m_numberTextBoxHeight = m_bottomPadding = (int)((double)m_scale.y * 0.1);
    m_topPadding = (int)((double)m_scale.y * 0.1);
    m_numberTextBoxWidth = m_sidePadding = (int)((double)m_scale.x * 0.1);
    m_foregroundColour = color(#F000CD);
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

    setUpAfterDataAdded();
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

    setUpAfterDataAdded();
  }

  private void setUpAfterDataAdded() {
    m_barWidth = (int)((m_scale.y - m_sidePadding) / (float)m_map.size());

    if (m_map.size() == 0)
      return;

    m_maxValue = 0;
    for (var value : m_map.values()) {
      if (value > m_maxValue)
        m_maxValue = value;
    }

    m_scaleInterval = 1;
    for (int i = m_maxValue; i > 1; i /= 10)
      m_scaleInterval *= 10;
    m_maxScaleValue = m_scaleInterval * ((m_maxValue + m_scaleInterval - 1) / m_scaleInterval); // Round up to the nearest m_scaleInterval.
  }

  public void removeData() {
    m_map = new TreeMap<TData, Integer>();
    m_maxValue = -1;
    m_barWidth = -1;
  }

  public void setTitle(String title) {
    m_title = title;
  }

  public void setXAxisLabel(String name) {
    m_labelX = name;
  }

  public void setTranslationField(QueryType queryType, QueryManagerClass queryManager) {
    m_translationField = queryType;
    m_queryManager = queryManager;
  }

  @ Override
    public void draw() {
    super.draw();

    fill(color(m_backgroundColour));
    rect(m_pos.x, m_pos.y, m_scale.x, m_scale.y);

    if (m_maxValue == -1 || m_barWidth == -1)
      return;

    if (m_map.size() == 0)
      return;

    textAlign(CENTER, CENTER);
    fill(255);

    if (m_title != null)
      text(m_title, m_pos.x + m_sidePadding, m_pos.y, m_scale.x - m_sidePadding, m_topPadding);

    text(m_labelX, m_pos.x, m_pos.y + m_scale.y + 10, m_scale.x, 100);

    pushMatrix();

    translate(m_pos.x - 20, m_pos.y + m_scale.y * 0.5f);
    rotate(radians(-90));
    translate(-m_scale.y * 0.5f, -100 * 0.5f);
    text(m_labelY, 0, 0, m_scale.y, 100);

    popMatrix();

    text("0", m_pos.x, m_pos.y + m_scale.y - m_bottomPadding - m_numberTextBoxHeight * 0.5, m_numberTextBoxWidth, m_numberTextBoxHeight);
    for (int i = 1; i <= (m_maxScaleValue / m_scaleInterval); i++) {
      float numberYPos = m_pos.y + m_scale.y - m_bottomPadding - // Align to bottom of bar draw section
        (m_scale.y - m_topPadding - m_bottomPadding) * ((i * m_scaleInterval) / (float)m_maxScaleValue) // Multiply max bar draw height by % of maxScaleValue currently at
        - m_numberTextBoxHeight * 0.5; // Make centre of number at the value
      text(((Integer)(i * m_scaleInterval)).toString(), m_pos.x, numberYPos, m_numberTextBoxWidth, m_numberTextBoxHeight);
    }

    int i = 0;
    for (Map.Entry<TData, Integer> entry : m_map.entrySet()) {
      int barHeight = (int)(((double)entry.getValue() / (double)m_maxScaleValue) * (double)(m_scale.y - m_bottomPadding - m_topPadding));
      int barTop = (int)(m_pos.y + m_scale.y - m_bottomPadding - barHeight);

      int valTextYTop = Math.min((int)(m_pos.y + m_scale.y - m_bottomPadding - m_numberTextBoxHeight), barTop); // Write the value of each bar inside it if possible, else just above the bottom

      fill(color(m_foregroundColour));
      rect(m_pos.x + m_sidePadding + i * m_barWidth, m_pos.y + m_scale.y - barHeight - m_bottomPadding, m_barWidth, barHeight);

      String key = entry.getKey().toString();
      fill(255);
      text(translateXValues(key), m_pos.x + m_sidePadding + i * m_barWidth, m_pos.y + m_scale.y - m_bottomPadding, m_barWidth, m_bottomPadding);
      fill(0);
      text(entry.getValue().toString(), m_pos.x + m_sidePadding + i * m_barWidth, valTextYTop, m_barWidth, m_numberTextBoxHeight);

      i++;
    }
  }

  public String translateXValues(String val) {
    if (m_translationField == null)
      return val;

    switch (m_translationField) {
    case CANCELLED:
      return val.equals("0") ? "None" :
        val.equals("1") ? "Cancelled" : "Diverted";
    case CARRIER_CODE_INDEX:
      return m_queryManager.getAirlineName(Integer.parseInt(val));
    default:
      return val;
    }
  }
}

// Code authorship:
// A. Robertson, Created a barchart widget. 8pm 06/03/24
