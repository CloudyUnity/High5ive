import java.util.function.Function;
import java.util.TreeMap;
import java.util.Map;
import java.util.function.Consumer;

class BarChartUI<T> extends Widget {
  private TreeMap<String, Integer> m_map;
  private Integer m_maxValue = null; // Can be null
  private Integer m_barWidth = null; // Can be null
  private ArrayList<T> m_data; // Can be null
  private Function<T, String> m_getKey; // Can be null
  private int m_bottomPadding;

  public BarChartUI(int posX, int posY, int scaleX, int scaleY) {
    super(posX, posY, scaleX, scaleY);
    m_map = new TreeMap<String, Integer>();
    m_bottomPadding = (int)((double)m_scale.y * 0.1);
    m_foregroundColour = color(#F000CD);
  }

  public void addData(ArrayList<T> data, Function<T, String> getKey) {
    for (var value : data) {
      String k = getKey.apply(value);
      Integer entryValue = m_map.get(k);

      if (entryValue == null)
        m_map.put(k, 1);
      else
        m_map.replace(k, entryValue + 1);
    }

    m_barWidth = (int)(m_scale.y / (float)m_map.size());

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
    m_getKey = null;
    m_data = null;
  }

  @ Override
    public void draw() {
    super.draw();
    fill(m_backgroundColour);
    rect(m_pos.x, m_pos.y, m_scale.x, m_scale.y);

    if (m_map.size() == 0)
      return;

    int i = 0;
    textAlign(CENTER, CENTER);
    for (Map.Entry<String, Integer> entry : m_map.entrySet()) {
      if (DEBUG_MODE)
        System.out.printf("Value: %d\n", entry.getValue());

      int barHeight = (int)(((double)entry.getValue() / (double)m_maxValue) * (double)m_scale.y) - m_bottomPadding;
      if (DEBUG_MODE)
        System.out.printf("Bar height: %d\n", barHeight);

      fill(m_foregroundColour);
      rect(m_pos.x + i * m_barWidth, m_pos.y + m_scale.y - barHeight - m_bottomPadding, m_barWidth, barHeight);

      fill(0);
      text(entry.getKey(), m_pos.x + i * m_barWidth, m_pos.y + m_scale.y - m_bottomPadding, m_barWidth, m_bottomPadding);

      i++;
    }
  }
}

class ButtonUI extends Widget implements IClickable {
  private Event<EventInfoType> m_onClickEvent;
  private int m_textSize, m_textXOffset, m_textYOffset;
  private LabelUI m_label;

  public ButtonUI(int posX, int posY, int scaleX, int scaleY) {
    super(posX, posY, scaleX, scaleY);
    m_textSize = 12;
    m_onClickEvent = new Event<EventInfoType>();
    m_textXOffset = 5;
    m_textYOffset = 0;
    m_label = new LabelUI(posX, posY, scaleX, scaleY, null);
  }

  @ Override
    public void draw() {
    super.draw();
    
    fill(m_backgroundColour);
    rect(m_pos.x, m_pos.y, m_scale.x, m_scale.y);
    
    m_label.draw();
  }

  public Event<EventInfoType> getOnClickEvent() {
    return m_onClickEvent;
  }

  public void setText(String text) {
    m_label.setText(text);
  }

  /**
   * Sets the button text size.
   *
   * @param  textSize The size of the text.
   * @throws IllegalArgumentException when the size argument is negative.
   **/
  public void setTextSize(int textSize) {
    m_label.setTextSize(textSize);
  }

  /**
   * Sets the button text offset from the left edge if not centred.
   *
   * @param  textXOffset The offset from the left edge of the button.
   * @throws IllegalArgumentException when the textXOffset argument is negative.
   **/
  public void setTextXOffset(int textXOffset) {
    m_label.setTextXOffset(textXOffset);
  }

  /**
   * Sets the button text offset from the top edge if not centred.
   *
   * @param  textXOffset The offset from the left edge of the button.
   * @throws IllegalArgumentException when the textXOffset argument is negative.
   **/
  public void setTextYOffset(int textYOffset) {
    m_label.setTextYOffset(textYOffset);
  }
}

class CheckboxUI extends Widget implements IClickable {
  private LabelUI m_label;
  private int m_textPadding;
  private Event<EventInfoType> m_onClickEvent;
  private boolean m_checked;
  private color m_checkedColour = DEFAULT_CHECKBOX_CHECKED_COLOUR;

  public CheckboxUI(int posX, int posY, int scaleX, int scaleY, String label) {
    super(posX, posY, scaleX, scaleY);
    m_label = new LabelUI(posX + scaleY + m_textPadding, posY, scaleX - scaleY - m_textPadding, scaleY, label);
    m_textPadding = 5;
    
    m_onClickEvent = new Event<EventInfoType>();
    m_onClickEvent.addHandler(e -> {
      m_checked = !m_checked;
    });
  }

  @ Override
    public void draw() {
    super.draw();

    fill(m_checked ? m_checkedColour : m_backgroundColour);
    rect(m_pos.y, m_pos.y, m_scale.y, m_scale.y);

    m_label.draw();
  }

  public Event<EventInfoType> getOnClickEvent() {
    return m_onClickEvent;
  }

  public void setCheckedColour(color checkedColour) {
    m_checkedColour = checkedColour;
  }

  public boolean getChecked() {
    return m_checked;
  }

  public void setChecked(boolean checked) {
    m_checked = checked;
  }

  /**
   * Sets the button text size.
   *
   * @param  textSize The size of the text.
   * @throws IllegalArgumentException when the size argument is negative.
   **/
  public void setTextSize(int textSize) {
    m_label.setTextSize(textSize);
  }

  public void setText(String text) {
    m_label.setText(text);
  }
}

class LabelUI extends Widget {
  private boolean m_centreAligned;
  private String m_text; // Can be null
  private int m_textSize, m_textXOffset, m_textYOffset;

  public LabelUI(int posX, int posY, int scaleX, int scaleY, String text) {
    super(posX, posY, scaleX, scaleY);
    m_text = text;
    m_textSize = 12;
    m_textYOffset = 0;
    m_textXOffset = 5;
    m_centreAligned = false;
  }

  @ Override
    public void draw() {
    super.draw();

    if (m_text == null)
      return;

    textSize(m_textSize);

    fill(m_foregroundColour);
    textAlign(this.m_centreAligned ? CENTER : LEFT, CENTER);
    text(m_text, m_pos.x + m_textXOffset, m_pos.y + m_textYOffset, m_scale.x - m_textXOffset, m_scale.y - m_textYOffset);
  }

  public void setCentreAligned(boolean centreAligned) {
    m_centreAligned = centreAligned;
  }

  public void setText(String text) {
    m_text = text;
  }

  /**
   * Sets the button text size.
   *
   * @param  textSize The size of the text.
   * @throws IllegalArgumentException when the size argument is negative.
   **/
  public void setTextSize(int textSize) {
    if (textSize < 0)
      throw new IllegalArgumentException("Text size cannot be less than 0.");

    m_textSize = textSize;
  }

  /**
   * Sets the button text offset from the left edge if not centred.
   *
   * @param  textXOffset The offset from the left edge of the button.
   * @throws IllegalArgumentException when the textXOffset argument is negative.
   **/
  public void setTextXOffset(int textXOffset) {
    if (textXOffset < 0)
      throw new IllegalArgumentException("Text X offset cannot be less than 0.");

    m_textXOffset = textXOffset;
  }

  /**
   * Sets the button text offset from the top edge if not centred.
   *
   * @param  textXOffset The offset from the left edge of the button.
   * @throws IllegalArgumentException when the textXOffset argument is negative.
   **/
  public void setTextYOffset(int textYOffset) {
    if (textYOffset < 0)
      throw new IllegalArgumentException("Text Y offset cannot be less than 0.");

    m_textYOffset = textYOffset;
  }
}

class RadioButtonUI extends Widget implements IClickable {
  private Event<EventInfoType> m_onClickEvent;
  private Event<EventInfoType> m_onCheckedEvent;
  private LabelUI m_label;
  private boolean m_checked;
  private color m_checkedColour = DEFAULT_RADIOBUTTON_CHECKED_COLOUR;

  public RadioButtonUI(int posX, int posY, int scaleX, int scaleY, String label) {
    super(posX, posY, scaleX, scaleY);
    m_label = new LabelUI(posX + scaleY, posY, scaleX - scaleY, scaleY, label);

    m_onCheckedEvent = new Event<EventInfoType>();
    m_onClickEvent = new Event<EventInfoType>();

    m_onClickEvent.addHandler(e -> {
      RadioButtonUI box = (RadioButtonUI)e.Widget;
      if (!box.getChecked()) {
        m_onCheckedEvent.raise(e);
      }
      box.setChecked(true);
    }
    );
  }

  @ Override
    public void draw() {
    super.draw();

    ellipseMode(RADIUS);
    fill(m_checked ? m_checkedColour : m_backgroundColour);
    circle(m_pos.x + m_scale.y / 2, m_pos.y + m_scale.y / 2, m_scale.y / 2);

    m_label.draw();
  }

  public Event<EventInfoType> getOnClickEvent() {
    return m_onClickEvent;
  }

  public Event<EventInfoType> getOnCheckedEvent() {
    return m_onCheckedEvent;
  }

  public void setChecked(boolean checked) {
    m_checked = checked;
  }

  public boolean getChecked() {
    return m_checked;
  }

  public void setText(String text) {
    m_label.setText(text);
  }

  /**
   * Sets the button text size.
   *
   * @param  textSize The size of the text.
   * @throws IllegalArgumentException when the size argument is negative.
   **/
  public void setTextSize(int textSize) {
    m_label.setTextSize(textSize);
  }
}

class RadioButtonGroupTypeUI extends WidgetGroupType {
  public RadioButtonGroupTypeUI() {
    super();
  }

  public void addMember(RadioButtonUI rb) {
    Members.add(rb);
    rb.getOnClickEvent().addHandler(e -> memberClicked(e));
  }

  private void memberClicked(EventInfoType e) {
    for (Widget member : Members) {
      RadioButtonUI rb = (RadioButtonUI)member;

      if (rb != e.Widget) {
        rb.setChecked(false);
      }
    }
  }
}

class SliderUI extends Widget implements IDraggable, IClickable {
  private LabelUI m_label;
  private int m_labelSpace;
  private double m_min, m_max, m_interval, m_value;
  private color m_filledColour = DEFAULT_SLIDER_FILLED_COLOUR;
  private Event<MouseDraggedEventInfoType> m_onDraggedEvent;
  private Event<EventInfoType> m_onClickEvent;

  public SliderUI(int posX, int posY, int scaleX, int scaleY, double min, double max, double interval) {
    super(posX, posY, scaleX, scaleY);
    m_onDraggedEvent = new Event<MouseDraggedEventInfoType>();
    m_onClickEvent = new Event<EventInfoType>();
    m_min = min;
    m_max = max;
    m_value = min;
    m_interval = interval;
    m_labelSpace = scaleY / 3;
    m_label = new LabelUI(posX, posY, scaleX, m_labelSpace, String.format("Value: %.2f", m_value));
    m_label.setCentreAligned(true);
    m_label.setTextSize(15);

    m_onDraggedEvent.addHandler(e -> onDraggedHandler(e));
    m_onClickEvent.addHandler(e -> onClickHandler(e));
  }

  @ Override
    public void draw() {
    super.draw();
    
    fill(m_backgroundColour);
    rect(m_pos.x, m_pos.y + m_labelSpace, m_scale.x, m_scale.y - m_labelSpace);
    
    fill(m_filledColour);
    rect(m_pos.x, m_pos.y + m_labelSpace, (int)(m_scale.x * ((m_value - m_min) / (m_max - m_min))), m_scale.y - m_labelSpace);
    
    m_label.draw();
  }

  public void setLabelText(String text) {
    m_label.setText(text);
  }

  public double getValue() {
    return m_value;
  }

  public Event<MouseDraggedEventInfoType> getOnDraggedEvent() {
    return m_onDraggedEvent;
  }

  public Event<EventInfoType> getOnClickEvent() {
    return m_onClickEvent;
  }

  private void onDraggedHandler(MouseDraggedEventInfoType e) {
    double percentAcross = clamp((double)(e.X - m_pos.x) / (double)(m_scale.x), 0.0, 1.0);
    double unrounded = ((double)m_min + percentAcross * (double)(m_max - m_min));
    
    m_value = m_interval * (Math.round(unrounded/m_interval));
    
    m_label.setText(String.format("Value: %.2f", m_value));
  }

  private void onClickHandler(EventInfoType e) {
    double percentAcross = clamp((double)(e.X - m_pos.x) / (double)(m_scale.x), 0.0, 1.0);
    double unrounded = ((double)m_min + percentAcross * (double)(m_max - m_min));
    
    m_value = m_interval * (Math.round(unrounded/m_interval));
    
    m_label.setText(String.format("Value: %.2f", m_value));
  }

  private double clamp(double val, double min, double max) {
    return Math.max(min, Math.min(max, val));
  }
}

// Descending code authorship changes:
// A. Robertson, ___
// F. Wright, Modified and simplified code to fit coding standard. Combined all UI elements into the UI tab, 6pm 04/03/24
