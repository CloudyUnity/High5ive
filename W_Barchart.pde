import java.util.function.Function;
import java.util.TreeMap;
import java.util.Map;
import java.util.function.Consumer;

class BarChartUI<T> extends Widget {
  private TreeMap<String, Integer> m_map;
  private Integer m_maxValue = null; // Can be null
  private Integer m_barWidth = null; // Can be null
  private int m_bottomPadding;

  public BarChartUI(int posX, int posY, int scaleX, int scaleY) {
    super(posX, posY, scaleX, scaleY);
    m_map = new TreeMap<String, Integer>();
    m_bottomPadding = (int)((double)m_scale.y * 0.1);
    m_foregroundColour = color(#F000CD);
  }

  public <C extends Iterable<T>> void addData(C data, Function<T, String> getKey) {
    for (var value : data) {
      String k = getKey.apply(value);
      Integer entryValue = m_map.get(k);

      if (entryValue == null)
        m_map.put(k, 1);
      else
        m_map.replace(k, entryValue + 1);
    }

    m_barWidth = (int)((m_scale.y) / (float)m_map.size());

    if (m_map.size() == 0)
      return;

    if (m_maxValue != null)
      return;

    m_maxValue = 0;
    for (var value : m_map.values()) {
      if (value > m_maxValue)
        m_maxValue = value;
    }
  }

  public void removeData() {
    m_map = new TreeMap<String, Integer>();
    m_maxValue = null;
    m_barWidth = null;
  }

  @ Override
    public void draw() {
    super.draw();
    fill(color(m_backgroundColour));
    rect(m_pos.x, m_pos.y, m_scale.x, m_scale.y);

    if (m_map.size() == 0)
      return;

    textAlign(CENTER, CENTER);
    fill(0);
    int i = 0;
    for (Map.Entry<String, Integer> entry : m_map.entrySet()) {
      if (DEBUG_MODE)
        System.out.printf("Value: %d\n", entry.getValue());

      int barHeight = (int)(((double)entry.getValue() / (double)m_maxValue) * (double)(m_scale.y - m_bottomPadding));
      if (DEBUG_MODE)
        System.out.printf("Bar height: %d\n", barHeight);

      fill(color(m_foregroundColour));
      rect(m_pos.x + i * m_barWidth, m_pos.y + m_scale.y - barHeight - m_bottomPadding, m_barWidth, barHeight);

      fill(0);
      text(entry.getKey(), m_pos.x + i * m_barWidth, m_pos.y + m_scale.y - m_bottomPadding, m_barWidth, m_bottomPadding);

      i++;
    }
  }
}
