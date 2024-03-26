class AlexTestingScreen extends Screen {
  private TextboxUI box;
  private ListboxUI<String> list;
  private ButtonUI clearListButton;
  private ButtonUI removeSelectedButton;
  private ButtonUI addItemButton;
  private DropdownUI<String> testDropdown;
  private ImageUI imageBox;
  private int counter = 0;

  public AlexTestingScreen(String screenId) {
    super(screenId, color(220, 220, 220, 255));
  }

  @Override
    public void init() {
    super.init();
    box = new TextboxUI(50, 70, 200, 50);
    list = new ListboxUI<String>(50, 170, 200, 400, 40, v -> v);
    imageBox = new ImageUI(400, 50, 60, 60);

    box.setPlaceholderText("Placeholder...");

    addItemButton = createButton(300, 50, 80, 20);
    addItemButton.setText("Add item");
    addItemButton.getOnClickEvent().addHandler(e -> addItemOnClick(e));

    clearListButton = createButton(300, 90, 80, 20);
    clearListButton.setText("Clear");
    clearListButton.getOnClickEvent().addHandler(e -> clearListOnClick(e));

    removeSelectedButton = createButton(300, 130, 80, 20);
    removeSelectedButton.setText("Remove selected");
    removeSelectedButton.getOnClickEvent().addHandler(e -> list.removeSelected());

    testDropdown = new DropdownUI<String>(400, 90, 200, 400, 30, v -> v);
    testDropdown.add("One");
    testDropdown.add("Two");
    testDropdown.add("Three");
    testDropdown.add("One");
    testDropdown.add("Two");
    testDropdown.add("Three");
    testDropdown.add("One");
    testDropdown.add("Two");
    testDropdown.add("Three");
    testDropdown.add("One");
    testDropdown.add("Two");
    testDropdown.add("Three");
    testDropdown.add("One");
    testDropdown.add("Two");
    testDropdown.add("Three");

    testDropdown.setSearchable(true);

    addWidget(box);
    addWidget(list);
    addWidget(testDropdown);
    addWidget(imageBox);


    ButtonUI returnBttn = createButton(20, displayHeight - 60, 160, 50);

    returnBttn.getOnClickEvent().addHandler(e -> switchScreen(e, SCREEN_1_ID));
    returnBttn.setGrowScale(1.05);
    returnBttn.setText("<-");
    returnBttn.setTextSize(20);
    returnBttn.getLabel().setCentreAligned(true);
  }

  private void addItemOnClick(EventInfoType e) {
    list.add("" + counter);
    counter++;
  }

  private void clearListOnClick(EventInfoType e) {
    list.clear();
  }
}
