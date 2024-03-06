import java.util.function.Function;
import java.util.TreeMap;
import java.util.Map;
import java.util.function.Consumer;

class BarChartUI<T> extends Widget {
  private TreeMap<String, Integer> m_map;
  private Integer m_maxValue = null; // Can be null
  private Integer m_barWidth = null; // Can be null
  private int m_bottomPadding;
  private int m_topPadding;
  private int m_sidePadding;
  private Integer m_maxScaleValue;
  private Integer m_scaleInterval;
  private String m_title;
  private int m_numberTextBoxWidth;
  private int m_numberTextBoxHeight;

  public BarChartUI(int posX, int posY, int scaleX, int scaleY) {
    super(posX, posY, scaleX, scaleY);
    m_map = new TreeMap<String, Integer>();
    m_numberTextBoxHeight = m_bottomPadding = (int)((double)m_scale.y * 0.1);
    m_topPadding = (int)((double)m_scale.y * 0.1);
    m_numberTextBoxWidth = m_sidePadding = (int)((double)m_scale.x * 0.1);
    m_foregroundColour = color(#F000CD);
  }
  
  public void addData(T[] data, Function<T, String> getKey) {
    for (var value : data) {
      String k = getKey.apply(value);
      Integer entryValue = m_map.get(k);

      if (entryValue == null)
        m_map.put(k, 1);
      else
        m_map.replace(k, entryValue + 1);
    }

    setUpAfterDataAdded();
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

    setUpAfterDataAdded();
  }

  private void setUpAfterDataAdded() {
    m_barWidth = (int)((m_scale.y - m_sidePadding) / (float)m_map.size());

    if (m_map.size() == 0)
      return;

    if (m_maxValue != null)
      return;

    m_maxValue = 0;
    for (var value : m_map.values()) {
      if (value > m_maxValue)
        m_maxValue = value;
    }
    
    m_scaleInterval = 1;
    for (int tmp = m_maxValue; tmp > 1; tmp /= 10)
      m_scaleInterval *= 10;
    m_maxScaleValue = m_scaleInterval * ((m_maxValue + m_scaleInterval - 1) / m_scaleInterval); // Round up to the nearest m_scaleInterval.
  }
  public void removeData() {
    m_map = new TreeMap<String, Integer>();
    m_maxValue = null;
    m_barWidth = null;
  }
  
  public void setTitle(String title) {
    m_title = title;
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
    
    if (m_title != null) 
      text(m_title, m_pos.x + m_sidePadding, m_pos.y, m_scale.x - m_sidePadding, m_topPadding);
    
    text("0", m_pos.x, m_pos.y + m_scale.y - m_bottomPadding - m_numberTextBoxHeight * 0.5, m_numberTextBoxWidth, m_numberTextBoxHeight);
    for (int i = 1; i <= (m_maxScaleValue / m_scaleInterval); i++) {
      float numberYPos = m_pos.y + m_scale.y - m_bottomPadding - // Align to bottom of bar draw section
        (m_scale.y - m_topPadding - m_bottomPadding) * ((i * m_scaleInterval) / (float)m_maxScaleValue) // Multiply max bar draw height by % of maxScaleValue currently at
        - m_numberTextBoxHeight * 0.5; // Make centre of number at the value
      text(((Integer)(i * m_scaleInterval)).toString(), m_pos.x, numberYPos, m_numberTextBoxWidth, m_numberTextBoxHeight);
    }
    
    int i = 0;
    for (Map.Entry<String, Integer> entry : m_map.entrySet()) {
      int barHeight = (int)(((double)entry.getValue() / (double)m_maxScaleValue) * (double)(m_scale.y - m_bottomPadding - m_topPadding));
      int barTop = (int)(m_pos.y + m_scale.y - m_bottomPadding - barHeight);
      
      int valTextYTop = Math.min((int)(m_pos.y + m_scale.y - m_bottomPadding - m_numberTextBoxHeight), barTop); // Write the value of each bar inside it if possible, else just above the bottom

      fill(color(m_foregroundColour));
      rect(m_pos.x + m_sidePadding + i * m_barWidth, m_pos.y + m_scale.y - barHeight - m_bottomPadding, m_barWidth, barHeight);

      fill(0);
      text(entry.getKey(), m_pos.x + m_sidePadding + i * m_barWidth, m_pos.y + m_scale.y - m_bottomPadding, m_barWidth, m_bottomPadding);
      text(entry.getValue().toString(), m_pos.x + m_sidePadding + i * m_barWidth, valTextYTop, m_barWidth, m_numberTextBoxHeight);

      i++;
    }
  }
}
