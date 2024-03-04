class Slider extends Widget implements IDraggable, IClickable {
  public Slider(int x, int y, int width, int height, double min, double max, double interval) {
    super(x, y, width, height);
    this.onDraggedEvent = new Event<MouseDraggedEventInfo>();
    this.onClickEvent = new Event<EventInfo>();
    this.filledColour = DEFAULT_FILLED_COLOUR;
    this.min = min;
    this.max = max;
    this.value = min;
    this.interval = interval;
    this.labelSpace = this.height / 3;
    this.label = new Label(this.x, this.y, this.width, this.labelSpace, String.format("Value: %.2f", this.value));
    label.setCentreAligned(true);
    label.setTextSize(15);
    
    this.onDraggedEvent.addHandler(e -> this.onDraggedHandler(e));
    this.onClickEvent.addHandler(e -> this.onClickHandler(e));
  }
  
  @ Override
  public void draw() {
    super.draw();
    fill(this.backgroundColour);
    rect(this.x, this.y + this.labelSpace, this.width, this.height - this.labelSpace);
    fill(this.filledColour);
    rect(this.x, this.y + this.labelSpace, (int)(this.width * ((this.value - this.min) / (this.max - this.min))), this.height - this.labelSpace);
    this.label.draw();
  }
  
  // Example: "Value: %.2d"
  public void setLabelText(String text) {
    this.label.setText(text);
  }
  
  public double getValue() {
    return this.value; 
  }
  
  public Event<MouseDraggedEventInfo> getOnDraggedEvent() {
    return this.onDraggedEvent;
  }
  
  public Event<EventInfo> getOnClickEvent() {
    return this.onClickEvent;
  }
  
  private void onDraggedHandler(MouseDraggedEventInfo e) {
    double percentAcross = this.clamp((double)(e.x - this.x) / (double)(this.width), 0.0, 1.0);
    double unrounded = ((double)this.min + percentAcross * (double)(this.max - this.min));
    this.value = interval * (Math.round(unrounded/interval));
    this.label.setText(String.format("Value: %.2f", this.value));
  }
  
  private void onClickHandler(EventInfo e) {
    double percentAcross = this.clamp((double)(e.x - this.x) / (double)(this.width), 0.0, 1.0);
    double unrounded = ((double)this.min + percentAcross * (double)(this.max - this.min));
    this.value = interval * (Math.round(unrounded/interval));
    this.label.setText(String.format("Value: %.2f", this.value));
  }
  
  private double clamp(double val, double min, double max) {
    return Math.max(min, Math.min(max, val));
  }
  
  private Label label;
  private int labelSpace;
  private double min, max, interval, value;
  private color filledColour;
  private final color DEFAULT_FILLED_COLOUR = color(#00BCD4);
  private Event<MouseDraggedEventInfo> onDraggedEvent;
  private Event<EventInfo> onClickEvent;
}
