class MouseMovedEventInfo extends EventInfo {
  public MouseMovedEventInfo(int x, int y, int px, int py, Widget widget) {
    super(x, y, widget);
    this.px = px;
    this.py = py;
  }
  public int px, py;
}
