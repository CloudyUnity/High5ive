class RadioButtonGroup extends WidgetGroup {
  public RadioButtonGroup() {
    super();
  }
  
  public void addMember(RadioButton rb) {
    members.add(rb);
    rb.getOnClickEvent().addHandler(e -> this.memberClicked(e));
  }
  
  private void memberClicked(EventInfo e) {
    for (Widget member : this.members) {
      RadioButton rb = (RadioButton)member;
      if (rb != e.widget) {
        rb.setChecked(false);
      }
    }
  }
}
