class WidgetGroup {
  public WidgetGroup() {
    members = new ArrayList<Widget>();
  }
  
  public ArrayList<Widget> getMembers() {
    return this.members;
  }
  
  protected ArrayList<Widget> members;
}
