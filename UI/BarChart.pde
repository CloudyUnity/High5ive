import java.util.function.Function;
import java.util.TreeMap;
import java.util.Map;

class BarChart<T> extends Widget {
  public BarChart(int x, int y, int width, int height) {
    super(x, y, width, height);
    this.map = new TreeMap<String, Integer>();
    this.bottomPadding = (int)((double)this.height * 0.1);
    this.foregroundColour = color(#F000CD);
  }
  
  public void addData(ArrayList<T> data, Function<T, String> getKey) {
    for (var value : data) {
      String k = getKey.apply(value);
      Integer entryValue = this.map.get(k);
      if (entryValue == null)
        this.map.put(k, 1);
      else
        this.map.replace(k, entryValue + 1);
    }
    this.barWidth = this.width / this.map.size();
    if (this.map.size() != 0) {
      if (maxValue == null) {
        this.maxValue = 0;
        for (var value : this.map.values()) {
          if (value > this.maxValue)
            this.maxValue = value;
        }
      }
    }
  }
  
  public void removeData() {
    this.map = new TreeMap<String, Integer>();
    this.maxValue = null;
    this.barWidth = null;
    this.getKey = null;
    this.data = null;
  }
  
  @ Override
  public void draw() {
    super.draw();
    fill(this.backgroundColour);
    rect(this.x, this.y, this.width, this.height);
    
    if (this.map.size() != 0) {
      int count = 0;
      textAlign(CENTER, CENTER);
      for (Map.Entry<String, Integer> entry : map.entrySet()) {
        System.out.printf("Value: %d\n", entry.getValue());
        int barHeight = (int)(((double)entry.getValue() / (double)this.maxValue) * (double)this.height) - this.bottomPadding;
        System.out.printf("Bar height: %d\n", barHeight);
        fill(this.foregroundColour);
        rect(this.x + count * this.barWidth, this.y + this.height - barHeight - this.bottomPadding, this.barWidth, barHeight);
        fill(0);
        text(entry.getKey(), this.x + count * this.barWidth, this.y + this.height - this.bottomPadding, this.barWidth, this.bottomPadding);
        count++;
      }
    }
  }
  
  TreeMap<String, Integer> map;
  Integer maxValue = null; // Can be null
  Integer barWidth = null; // Can be null
  ArrayList<T> data; // Can be null
  Function<T, String> getKey; // Can be null
  int bottomPadding;
}
