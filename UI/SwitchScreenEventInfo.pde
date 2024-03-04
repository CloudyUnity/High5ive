class SwitchScreenEventInfo extends EventInfo {
  public SwitchScreenEventInfo(int x, int y, String newScreenId, Widget widget) {
    super(x, y, widget);
    this.newScreenId = newScreenId;
  }
  public String newScreenId;
}
