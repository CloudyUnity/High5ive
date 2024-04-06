/**
 * F.Wright:
 * Represents a textbox with an attached operator dropdown for querying flight data. 
 */

class TextboxWithOpType {
  public TextboxUI Textbox;
  public DropdownUI<QueryOperatorType> OpDropdown;
  public QueryType Type;

  public TextboxWithOpType(TextboxUI tb, DropdownUI<QueryOperatorType> opDD, QueryType type) {
    Textbox = tb;
    OpDropdown = opDD;
    Type = type;
  }
}

/**
 * M.Poole:
 * Represents a user interface for querying flight data. Manages user inputs and interactions
 * for querying flight data and displaying results.
 */
class UserQueryUI extends Widget {
  private  QueryManagerClass m_queryManager;
  private Screen m_screen;

  private FlightMultiDataType m_flightsLists;
  private ArrayList<FlightQueryType> m_activeQueries = new ArrayList<FlightQueryType>();
  private Consumer<FlightType[]> m_onLoadDataEvent;
  private Consumer<FlightType[]> m_onLoadDataOtherScreenEvent;

  private ListboxUI m_queryLB;
  private QueryLocationType m_location = QueryLocationType.US;

  private TextboxUI m_originTB, m_destTB, m_airlineTB, m_flightNumTB, m_tailNumTB;
  private ArrayList<TextboxWithOpType> m_tbopList = new ArrayList<TextboxWithOpType>();
  private ArrayList<Widget> m_lockBoxesList = new ArrayList<Widget>();
  private ArrayList<Widget> m_usOnlyFields = new ArrayList<Widget>();

  private RadioButtonUI m_cancelledRadio;
  private RadioButtonUI m_divertedRadio;
  private RadioButtonUI m_successRadio;
  private RadioButtonUI m_worldRadio;
  private RadioButtonUI m_usRadio;
  private ButtonUI m_loadDataOtherScreenButton;
  private RadioButtonGroupTypeUI cancelDivertGroup;

  private PImage m_lockImg = loadImage("data/Images/Lock.png");

  /**
   * M.Poole:
   * Constructs a UserQueryUI object with the specified position, dimensions, query manager, and screen.
   *
   * @param posX         The x-coordinate of the user interface position.
   * @param posY         The y-coordinate of the user interface position.
   * @param scaleX       The width of the user interface.
   * @param scaleY       The height of the user interface.
   * @param queryManager The query manager responsible for handling flight data queries.
   * @param screen       The screen where the user interface will be displayed.
   */
  UserQueryUI(int posX, int posY, int scaleX, int scaleY, QueryManagerClass queryManager, Screen screen) {
    super(posX, posY, scaleX, scaleY);

    m_queryManager = queryManager;
    m_screen = screen;

    // LISTBOXES

    int buttonScale = 150;

    m_queryLB = new ListboxUI<String>(20, 250, buttonScale, 390, 40, v -> v);
    addWidget(m_queryLB);

    // BUTTONS

    int textSize = 15;

    ButtonUI addItemButton = new ButtonUI(20, 150, buttonScale, 40);
    addWidget(addItemButton);
    addItemButton.setText("Add Query");
    addItemButton.setTextSize(textSize);
    addItemButton.getOnClickEvent().addHandler(e -> saveAllQueries());

    ButtonUI clearListButton = new ButtonUI(20, 200, buttonScale, 40);
    addWidget(clearListButton);
    clearListButton.setText("Clear All");
    clearListButton.setTextSize(textSize);
    clearListButton.getOnClickEvent().addHandler(e -> clearQueries());

    ButtonUI loadDataButton = new ButtonUI(20, 650, buttonScale, 40);
    addWidget(loadDataButton);
    loadDataButton.setText("Load Data");
    loadDataButton.setTextSize(textSize);
    loadDataButton.getOnClickEvent().addHandler(e -> loadData());

    m_loadDataOtherScreenButton = new ButtonUI(20, 700, buttonScale, 40);
    addWidget(m_loadDataOtherScreenButton);
    m_loadDataOtherScreenButton.setText("Load into Charts");
    m_loadDataOtherScreenButton.setTextSize(textSize);
    m_loadDataOtherScreenButton.getOnClickEvent().addHandler(e -> loadDataOtherScreen());
    m_usOnlyFields.add(m_loadDataOtherScreenButton);

    // WORLD - US RADIO BUTTONS

    RadioButtonGroupTypeUI worldUSGroup = new RadioButtonGroupTypeUI();
    addWidgetGroup(worldUSGroup);

    int iconSize = 70;
    m_worldRadio = new RadioImageButtonUI(width - iconSize - 10, 20, iconSize, iconSize, "WORLD", "data/Images/GlobeIcon.png", "data/Images/GlobeIconOff.png");
    m_worldRadio.getOnCheckedEvent().addHandler(e -> {
      changeDataToWorld();
      setLocksEnabled(true);
      clearUSQueries();
    }
    );
    m_worldRadio.setGrowScale(1.1f);
    worldUSGroup.addMember(m_worldRadio);

    m_usRadio = new RadioImageButtonUI(width - iconSize - 10, 50 + iconSize, iconSize, iconSize, "US", "data/Images/USIcon.png", "data/Images/USIconOff.png");
    m_usRadio.getOnCheckedEvent().addHandler(e -> {
      changeDataToUS();
      setLocksEnabled(false);
    }
    );
    m_usRadio.setGrowScale(1.1f);
    worldUSGroup.addMember(m_usRadio);
    m_usRadio.setChecked(true);

    // TEXTBOXES WITH OPERATORS

    int tbPosX = 220;
    int tbPosY = 150;

    createTextboxWithOp(tbPosX, tbPosY, "Distance", QueryType.KILOMETRES_DISTANCE);
    tbPosY += 50;
    createTextboxWithOp(tbPosX, tbPosY, "Day", QueryType.DAY);
    tbPosY += 50;
    createTextboxWithOp(tbPosX, tbPosY, "Arrival Time", QueryType.ARRIVAL_TIME);
    tbPosY += 50;
    createTextboxWithOp(tbPosX, tbPosY, "Sch Arrival", QueryType.SCHEDULED_ARRIVAL_TIME);
    tbPosY += 50;
    createTextboxWithOp(tbPosX, tbPosY, "Arrival Delay", QueryType.ARRIVAL_DELAY);
    tbPosY += 50;
    createTextboxWithOp(tbPosX, tbPosY, "Depart Time", QueryType.DEPARTURE_TIME);
    tbPosY += 50;
    createTextboxWithOp(tbPosX, tbPosY, "Sch Depart", QueryType.SCHEDULED_DEPARTURE_TIME);
    tbPosY += 50;
    createTextboxWithOp(tbPosX, tbPosY, "Depart Delay", QueryType.DEPARTURE_DELAY);
    tbPosY += 50;

    // TEXTBOXES

    m_originTB = createTextboxUI(tbPosX, tbPosY, "Origin");
    tbPosY += 50;
    m_destTB = createTextboxUI(tbPosX, tbPosY, "Dest");
    tbPosY += 50;
    m_flightNumTB = createTextboxUI(tbPosX, tbPosY, "Flight Number");
    m_usOnlyFields.add(m_flightNumTB);
    tbPosY += 50;
    m_airlineTB = createTextboxUI(tbPosX, tbPosY, "Airline");
    m_usOnlyFields.add(m_airlineTB);
    tbPosY += 50;
    m_tailNumTB = createTextboxUI(tbPosX, tbPosY, "Tail Number");
    m_usOnlyFields.add(m_tailNumTB);
    tbPosY += 50;

    // CANCELLED - DIVERTED - SUCCESSFUL RADIO BUTTONS

    cancelDivertGroup = new RadioButtonGroupTypeUI();
    addWidgetGroup(cancelDivertGroup);

    m_cancelledRadio = new RadioButtonUI(tbPosX, tbPosY, 40, 40, "CANCELLED");
    addWidget(m_cancelledRadio);
    m_cancelledRadio.setUncheckable(true);
    cancelDivertGroup.addMember(m_cancelledRadio);
    m_usOnlyFields.add(m_cancelledRadio);

    LabelUI cancelLabel = createLabel(tbPosX + 50, tbPosY - 5, 160, 40, "Cancelled");
    cancelLabel.setTextSize(20);
    cancelLabel.setCentreAligned(false);

    tbPosY += 50;

    m_divertedRadio = new RadioButtonUI(tbPosX, tbPosY, 40, 40, "DIVERTED");
    addWidget(m_divertedRadio);
    m_divertedRadio.setUncheckable(true);
    cancelDivertGroup.addMember(m_divertedRadio);
    m_usOnlyFields.add(m_divertedRadio);

    LabelUI divertLabel = createLabel(tbPosX + 50, tbPosY - 5, 160, 40, "Diverted");
    divertLabel.setTextSize(20);
    divertLabel.setCentreAligned(false);

    tbPosY += 50;

    m_successRadio = new RadioButtonUI(tbPosX, tbPosY, 40, 40, "SUCCESS");
    addWidget(m_successRadio);
    cancelDivertGroup.addMember(m_successRadio);
    m_successRadio.setUncheckable(true);
    m_usOnlyFields.add(m_successRadio);

    LabelUI successLabel = createLabel(tbPosX + 50, tbPosY - 5, 160, 40, "Successful");
    successLabel.setTextSize(20);
    successLabel.setCentreAligned(false);

    // LOCKBOXES

    createLockBoxes();
  }

  /**
   * F. Wright
   *
   * Creates a textbox input field with attached operator dropdown. Adds them to the main m_tbopList
   *
   * @param posX The x position of the textbox
   * @param posY The y position of the textbox
   * @param scaleX The x scale of the textbox
   * @param scaleY The y scale of the textbox
   * @param placeholderTxt The placeholder text in the textbox
   * @param type The query type to be checked
   */
  private TextboxWithOpType createTextboxWithOp(int posX, int posY, String placeholderTxt, QueryType type) {
    TextboxUI tb = new TextboxUI(posX, posY, (int)UQUI_TB_SCALE.x, (int)UQUI_TB_SCALE.y);
    addWidget(tb);
    tb.setPlaceholderText(placeholderTxt);
    m_usOnlyFields.add(tb);

    DropdownUI<QueryOperatorType> opDD = new DropdownUI<QueryOperatorType>(posX + (int)UQUI_TB_SCALE.x, posY, 100, 400, 40, v -> formatText(v.toString()));
    addWidget(opDD, -posY);
    opDD.setTextboxText(formatText("LESS_THAN"));
    m_usOnlyFields.add(opDD);

    opDD.add(QueryOperatorType.EQUAL);
    opDD.add(QueryOperatorType.NOT_EQUAL);
    opDD.add(QueryOperatorType.LESS_THAN);
    opDD.add(QueryOperatorType.GREATER_THAN);
    opDD.add(QueryOperatorType.LESS_THAN_EQUAL);
    opDD.add(QueryOperatorType.GREATER_THAN_EQUAL);

    TextboxWithOpType tbop = new TextboxWithOpType(tb, opDD, type);
    m_tbopList.add(tbop);
    return tbop;
  }

  private TextboxUI createTextboxUI(int posX, int posY, String placeholderTxt) {
    TextboxUI tb =  new TextboxUI(posX, posY, (int)UQUI_TB_SCALE.x, (int)UQUI_TB_SCALE.y);
    addWidget(tb);
    tb.setPlaceholderText(placeholderTxt);
    return tb;
  }

  /**
   * M.Poole:
   * Inserts base flight data into the user interface for further querying and analysis.
   *
   * @param flightData The flight data to be inserted into the interface.
   */
  public void insertBaseData(FlightMultiDataType flightData) {
    m_flightsLists = flightData;
    m_onLoadDataEvent.accept(new FlightType[0]);
  }

  /**
   * M.Poole:
   * Sets the handler for the data load event. This event occurs when flight data needs to be loaded.
   *
   * @param dataEvent The event handler for loading flight data.
   */
  public void setOnLoadHandler(Consumer<FlightType[]> dataEvent) {
    m_onLoadDataEvent = dataEvent;
  }

  /**
   * M.Poole:
   * Sets the handler for the data load event. This event occurs when flight data needs to be loaded.
   *
   * @param dataEvent The event handler for loading flight data.
   */
  public void setOnLoadOtherScreenHandler(Consumer<FlightType[]> dataEvent) {
    m_onLoadDataOtherScreenEvent = dataEvent;
  }


  /**
   * M.Poole:
   *
   * Loads flight data based on the active queries. Queries the flight manager for relevant data
   * based on user input queries and updates the displayed data accordingly.
   */
  private void loadData() {
    s_DebugProfiler.startProfileTimer();
    m_onLoadDataEvent.accept(createFlightTypeArr());
    s_DebugProfiler.printTimeTakenMillis("User query event");
  }
  
  /**
   * F.Wright:
   *
   * Loads flight data to another screen based on the active queries. Queries the flight manager for relevant data
   * based on user input queries and updates the displayed data accordingly.
   */

  private void loadDataOtherScreen() {
    s_DebugProfiler.startProfileTimer();
    m_onLoadDataOtherScreenEvent.accept(createFlightTypeArr());
    s_DebugProfiler.printTimeTakenMillis("Loading data into other screen");
  }

  private FlightType[] createFlightTypeArr() {
    FlightType[] result;
    if (m_location == QueryLocationType.US)
      result = m_flightsLists.US;
    else
      result = m_flightsLists.WORLD;

    for (FlightQueryType query : m_activeQueries) {
      result  = m_queryManager.queryFlights(result, query, query.QueryValue);
    }

    return result;
  }
  
  

  private void saveQuery(TextboxWithOpType tbop) {
    QueryOperatorType op = tbop.OpDropdown.getSelected();
    if (op == null)
      op = QueryOperatorType.LESS_THAN;

    saveQuery(tbop.Textbox, tbop.Type, op);
  }

  /**
   * M.Poole:
   *
   * Saves a query based on the provided textbox and query type. Captures user input and saves
   * it as a query for loading data.
   *
   * @param inputField The input field containing the user query.
   * @param inputQuery The query to be saved.
   */
  private void saveQuery(TextboxUI inputField, QueryType queryType, QueryOperatorType op) {
    if (inputField.getTextLength() <= 0)
      return;

    String text = inputField.getText().toUpperCase();
    if (text.isEmpty())
      return;

    inputField.setText("");

    int val = m_queryManager.formatQueryValue(queryType, text);
    if (val == -1)
      return;

    FlightQueryType fqt = new FlightQueryType(queryType, op, m_location);
    fqt.setQueryValue(val);

    String queryTypeStr = formatText(queryType.toString());
    String opStr = formatText(op.toString());
    addToQueryList(fqt, queryTypeStr + " " + opStr + " " + formatValue(text, queryType));
  }

  private void addToQueryList(FlightQueryType query, String text) {
    m_activeQueries.add(query);
    m_queryLB.add(text);
  }

  /**
   * M.Poole:
   *
   * Saves all active queries entered by the user. Collects and stores all active queries
   * for loading data.
   */
  private void saveAllQueries() {
    saveQuery(m_originTB, QueryType.AIRPORT_ORIGIN_INDEX, QueryOperatorType.EQUAL);
    saveQuery(m_destTB, QueryType.AIRPORT_DEST_INDEX, QueryOperatorType.EQUAL);
    saveQuery(m_airlineTB, QueryType.CARRIER_CODE_INDEX, QueryOperatorType.EQUAL);
    saveQuery(m_flightNumTB, QueryType.FLIGHT_NUMBER, QueryOperatorType.EQUAL);
    saveQuery(m_tailNumTB, QueryType.TAIL_NUMBER, QueryOperatorType.EQUAL);

    for (int i = 0; i < m_tbopList.size(); i++)
      saveQuery(m_tbopList.get(i));

    if (m_cancelledRadio.getChecked()) {
      FlightQueryType fqt = new FlightQueryType(QueryType.CANCELLED, QueryOperatorType.EQUAL, m_location);
      addToQueryList(fqt, "Cancelled");
    }

    if (m_divertedRadio.getChecked()) {
      FlightQueryType fqt = new FlightQueryType(QueryType.DIVERTED, QueryOperatorType.EQUAL, m_location);
      addToQueryList(fqt, "Diverted");
    }

    if (m_successRadio.getChecked()) {
      FlightQueryType fqtC = new FlightQueryType(QueryType.CANCELLED, QueryOperatorType.NOT_EQUAL, m_location);
      FlightQueryType fqtD = new FlightQueryType(QueryType.DIVERTED, QueryOperatorType.NOT_EQUAL, m_location);
      addToQueryList(fqtC, "Not Cancelled");
      addToQueryList(fqtD, "Not Diverted");
    }
  }


/**
 * F. Wright
 *
 * Formats the specified text according to certain predefined cases.
 *
 * @param text The text to format.
 * @return The formatted text.
 */
  private String formatText(String text) {
    switch (text) {
    case "KILOMETRES_DISTANCE":
      return "KM";
    case "AIRPORT_ORIGIN_INDEX":
      return "Origin";
    case "AIRPORT_DEST_INDEX":
      return "Dest";

    case "GREATER_THAN":
      return " >";
    case "LESS_THAN":
      return " <";
    case "EQUAL":
      return " =";
    case "NOT_EQUAL":
      return " !=";
    case "LESS_THAN_EQUAL":
      return " <=";
    case "GREATER_THAN_EQUAL":
      return " >=";
    default:
      return text;
    }
  }
/**
 * F. Wright
 *
 * Formats the specified value according to the query type.
 *
 * @param text The text to format.
 * @param query The query type to determine the formatting.
 * @return The formatted value.
 */
  private String formatValue(String text, QueryType query) {
    switch (query) {
    case ARRIVAL_TIME:
    case SCHEDULED_ARRIVAL_TIME:
    case DEPARTURE_TIME:
    case SCHEDULED_DEPARTURE_TIME:
      String cleanTxt = text.replace(":", "");
      if (cleanTxt.length() == 3)
        return cleanTxt.charAt(0) + ":" + cleanTxt.substring(1, 3);
      return cleanTxt.substring(0, 2) + ":" + cleanTxt.substring(2, 4);

    default:
      return text;
    }
  }

  /**
   * M.Poole:
   * Clears all currently saved user queries. Resets the interface by removing all
   * saved queries and resetting input fields.
   */
  private void clearQueries() {
    m_activeQueries.clear();
    m_queryLB.clear();
  }

  /**
   * M.Poole:
   * Changes the data location to US. Updates the interface to reflect data relevant
   * to the United States.
   */
  private void changeDataToUS() {
    m_location = QueryLocationType.US;
  }

  /**
   * M.Poole:
   * Changes the data location to World. Updates the interface to reflect global data.
   */
  private void changeDataToWorld() {
    m_location = QueryLocationType.WORLD;
  }

  /**
   * M.Poole:
   *
   * Adds a widget to the user interface. Incorporates a new widget into the interface layout
   * for user interaction and data display.
   *
   * @param widget The widget to be added to the interface.
   */
  private void addWidget(Widget widget) {
    if (m_screen != null)
      m_screen.addWidget(widget);
    widget.setParent(this);
  }


  /**
   * F.Wright:
   *
   * Adds a widget to the user interface. Incorporates a new widget into the interface layout
   * for user interaction and assigns it to a specific layer.
   *
   * @param widget The widget to be added to the interface.
   * @param layer The layer of the widget draw order
   */
  private void addWidget(Widget widget, int layer) {
    if (m_screen != null)
      m_screen.addWidget(widget, layer);
    widget.setParent(this);
  }

/**
 * F. Wright
 *
 * Enables or disables the lock functionality for the specified fields and lock boxes.
 *
 * @param enabled True to enable locks, false to disable them.
 */
 
  private void setLocksEnabled(boolean enabled) {
    for (int i = 0; i < m_usOnlyFields.size(); i++)
      m_usOnlyFields.get(i).setActive(!enabled);

    for (int i = 0; i < m_lockBoxesList.size(); i++)
      m_lockBoxesList.get(i).setActive(enabled);
  }
  /**
   * F. Wright
   *
   * Adds a widget group to the screen if the screen is not null.
   *
   * @param group The type of widget group to add.
   */

  private void addWidgetGroup(WidgetGroupType group) {
    if (m_screen != null)
      m_screen.addWidgetGroup(group);
  }
  /**
 * F. Wright
 *
 * Creates a label with the specified position, scale, and text, adds it to the widget group, and returns the label.
 *
 * @param posX The x-coordinate of the label.
 * @param posY The y-coordinate of the label.
 * @param scaleX The horizontal scale of the label.
 * @param scaleY The vertical scale of the label.
 * @param text The text to display on the label.
 * @return The created label.
 */

  public LabelUI createLabel(int posX, int posY, int scaleX, int scaleY, String text) {
    LabelUI label = new LabelUI(posX, posY, scaleX, scaleY, text);
    addWidget(label);
    return label;
  }
  /**
 * F. Wright
 *
 * Sets the rendering status of the world and US radio buttons.
 *
 * @param enabled True to enable rendering, false to disable it.
 */

  public void setRenderWorldUSButtons(boolean enabled) {
    m_worldRadio.setRendering(enabled);
    m_usRadio.setRendering(enabled);
  }
  /**
 * F. Wright
 *
 * Sets the parent widget for the world and US radio buttons.
 *
 * @param parent The parent widget to set.
 */

  public void setWorldUSParent(Widget parent) {
    m_worldRadio.setParent(parent);
    m_usRadio.setParent(parent);
  }
  
  /**
 * F. Wright
 *
 * Sets the text for the load data to charts screen button.
 *
 * @param str The text to set.
 */

  public void setLoadOtherScreenText(String str) {
    m_loadDataOtherScreenButton.setText(str);
  }


  /**
   * M.Poole & F.Wright:
   *
   *
   * Creates LockBox sprites to block queries that connot be used on the world
   * data set, and sets them offscreen as to not display when UQUI is first loaded
   *
   */

  private void createLockBoxes() {
    int posX = 220;
    int lockPosX = int(posX + (265 * 0.5f) - 20);

    // TBOPs

    for (int i = 150; i < 550; i += 50) {
      ImageUI lock = new ImageUI(m_lockImg, lockPosX, i, 40, 40);
      addWidget(lock);
      lock.setLayer(5);
      m_lockBoxesList.add(lock);
      lock.setActive(false);

      ButtonUI bg = new ButtonUI(posX, i, 265, 40);
      bg.setText("");
      addWidget(bg);
      bg.setHighlightOutlineOnEnter(false);
      m_lockBoxesList.add(bg);
      bg.setActive(false);
    }

    lockPosX = int(posX + (160 * 0.5f) - 20);

    // Textboxes

    for (int i = 650; i < 800; i += 50) {
      ImageUI lock = new ImageUI(m_lockImg, lockPosX, i, 40, 40);
      addWidget(lock);
      lock.setLayer(5);
      m_lockBoxesList.add(lock);
      lock.setActive(false);

      ButtonUI bg = new ButtonUI(posX, i, 160, 40);
      bg.setText("");
      addWidget(bg);
      bg.setHighlightOutlineOnEnter(false);
      m_lockBoxesList.add(bg);
      bg.setActive(false);
    }

    // C/D/S

    for (int i = 800; i < 950; i += 50) {
      ImageUI lock = new ImageUI(m_lockImg, posX, i, 40, 40);
      addWidget(lock);
      lock.setLayer(5);
      m_lockBoxesList.add(lock);
      lock.setActive(false);

      ButtonUI bg = new ButtonUI(posX, i, 40, 40);
      bg.setText("");
      addWidget(bg);
      bg.setHighlightOutlineOnEnter(false);
      m_lockBoxesList.add(bg);
      bg.setActive(false);
    }

    // "Load Into Charts"

    posX = 20;
    lockPosX = int(posX + (150 * 0.5f) - 20);

    ImageUI lock = new ImageUI(m_lockImg, lockPosX, 700, 40, 40);
    addWidget(lock);
    lock.setLayer(5);
    m_lockBoxesList.add(lock);
    lock.setActive(false);

    ButtonUI bg = new ButtonUI(posX, 700, 150, 40);
    bg.setText("");
    addWidget(bg);
    bg.setHighlightOutlineOnEnter(false);
    m_lockBoxesList.add(bg);
    bg.setActive(false);
  }

  /**
   * F. Wright
   *
   * Removes all active queries related to US airports from the list of active queries and their associated query labels.
   */

  private void clearUSQueries() {
    for (int i = 0; i < m_activeQueries.size(); i++) {
      QueryType qType = m_activeQueries.get(i).Type;
      boolean isOrigin = qType == QueryType.AIRPORT_ORIGIN_INDEX;
      boolean isDest = qType == QueryType.AIRPORT_DEST_INDEX;
      if (isOrigin || isDest)
        continue;
      m_activeQueries.remove(i);
      m_queryLB.removeAt(i);
    }
  }
}

// F.Wright  created Framework for UserQuery class 8pm 3/14/24
// M.Poole   fixed issue with key input not detecting and implemented Listbox Functionality
// M.Poole   implemented single item search querying
