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

  private ListboxUI m_queryLB;
  private QueryLocationType m_location = QueryLocationType.US;

  private TextboxUI m_originTB;
  private TextboxUI m_destTB;
  private TextboxUI m_airlineTB;
  private TextboxUI m_flightNumTB;
  private ArrayList<TextboxWithOpType> m_tbopList = new ArrayList<TextboxWithOpType>();

  private RadioButtonUI m_cancelledRadio;
  private RadioButtonUI m_divertedRadio;
  private RadioButtonUI m_successRadio;
  private RadioButtonUI m_worldRadio;
  private RadioButtonUI m_usRadio;

  private ButtonUI m_clearListButton;
  private ButtonUI m_addItemButton;
  private ButtonUI m_loadDataButton;

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

    m_queryLB = new ListboxUI<String>(20, 650, 200, 400, 40, v -> v);
    addWidget(m_queryLB);

    // BUTTONS

    m_addItemButton = new ButtonUI(20, 600, 80, 20);
    addWidget(m_addItemButton);
    m_addItemButton.setText("Add item");
    m_addItemButton.getOnClickEvent().addHandler(e -> saveAllQueries());

    m_clearListButton = new ButtonUI(120, 600, 80, 20);
    addWidget(m_clearListButton);
    m_clearListButton.setText("Clear");
    m_clearListButton.getOnClickEvent().addHandler(e -> clearQueries());

    m_loadDataButton = new ButtonUI(220, 500, 180, 120);
    addWidget(m_loadDataButton);
    m_loadDataButton.setText("Load Data");
    m_loadDataButton.getOnClickEvent().addHandler(e -> loadData());

    // WORLD - US RADIO BUTTONS

    RadioButtonGroupTypeUI worldUSGroup = new RadioButtonGroupTypeUI();
    addWidgetGroup(worldUSGroup);

    m_worldRadio = new RadioButtonUI(width - 60, 20, 50, 50, "WORLD");
    m_worldRadio.getOnCheckedEvent().addHandler(e -> changeDataToWorld());
    worldUSGroup.addMember(m_worldRadio);

    m_usRadio = new RadioButtonUI(width - 60, 80, 50, 50, "US");
    m_usRadio.getOnCheckedEvent().addHandler(e -> changeDataToUS());
    worldUSGroup.addMember(m_usRadio);
    m_usRadio.setChecked(true);

    // CANCELLED - DIVERTED - SUCCESSFUL RADIO BUTTONS

    RadioButtonGroupTypeUI cancelDivertGroup = new RadioButtonGroupTypeUI();
    addWidgetGroup(cancelDivertGroup);

    m_cancelledRadio = new RadioButtonUI(20, 350, 20, 20, "CANCELLED");
    addWidget(m_cancelledRadio);
    m_cancelledRadio.setUncheckable(true);
    cancelDivertGroup.addMember(m_cancelledRadio);

    m_divertedRadio = new RadioButtonUI(55, 350, 20, 20, "DIVERTED");
    addWidget(m_divertedRadio);
    m_divertedRadio.setUncheckable(true);
    cancelDivertGroup.addMember(m_divertedRadio);

    m_successRadio = new RadioButtonUI(90, 350, 20, 20, "SUCCESS");
    addWidget(m_successRadio);
    cancelDivertGroup.addMember(m_successRadio);
    m_successRadio.setUncheckable(true);

    // LABELS

    LabelUI cancelLabel = createLabel(17, 350, 160, 50, "C      D      N");
    cancelLabel.setTextSize(15);
    cancelLabel.setCentreAligned(false);

    // TEXTBOXES

    m_destTB = createTextboxUI(20, 550, 160, 30, "Dest");
    m_originTB = createTextboxUI(20, 500, 160, 30, "Origin");    
    m_airlineTB = createTextboxUI(20, 350, 160, 30, "Airline");
    m_flightNumTB = createTextboxUI(20, 400, 160, 30, "Flight Number");

    // TEXTBOXES WITH OPERATORS

    createTextboxWithOp(180, 450, 160, 40, "Distance", QueryType.KILOMETRES_DISTANCE);
    createTextboxWithOp(180, 300, 160, 40, "Arrival Time", QueryType.ARRIVAL_TIME);
    createTextboxWithOp(180, 250, 160, 40, "Sch Arrival", QueryType.SCHEDULED_ARRIVAL_TIME);
    createTextboxWithOp(180, 200, 160, 40, "Arrival Delay", QueryType.ARRIVAL_DELAY);
    createTextboxWithOp(180, 150, 160, 40, "Depart Time", QueryType.DEPARTURE_TIME);
    createTextboxWithOp(180, 100, 160, 40, "Sch Depart", QueryType.SCHEDULED_DEPARTURE_TIME);
    createTextboxWithOp(180, 50, 160, 40, "Depart Delay", QueryType.DEPARTURE_DELAY);
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
  private TextboxWithOpType createTextboxWithOp(int posX, int posY, int scaleX, int scaleY, String placeholderTxt, QueryType type) {
    TextboxUI tb = new TextboxUI(posX, posY, scaleX, scaleY);
    addWidget(tb);
    tb.setPlaceholderText(placeholderTxt);

    DropdownUI<QueryOperatorType> opDD = new DropdownUI<QueryOperatorType>(posX + scaleX, posY, 100, 400, 30, v -> formatText(v.toString()));
    addWidget(opDD);
    opDD.setTextboxText(formatText("LESS_THAN"));

    opDD.add(QueryOperatorType.EQUAL);
    opDD.add(QueryOperatorType.NOT_EQUAL);
    opDD.add(QueryOperatorType.LESS_THAN);
    opDD.add(QueryOperatorType.GREATER_THAN);

    TextboxWithOpType tbop = new TextboxWithOpType(tb, opDD, type);
    m_tbopList.add(tbop);
    return tbop;
  }
  
  private TextboxUI createTextboxUI(int posX, int posY, int scaleX, int scaleY, String placeholderTxt){
    TextboxUI tb =  new TextboxUI(posX, posY, scaleX, scaleY);
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
   *
   * Loads flight data based on the active queries. Queries the flight manager for relevant data
   * based on user input queries and updates the displayed data accordingly.
   */
  private void loadData() {
    FlightType[] result;
    if (m_location == QueryLocationType.US)
      result = m_flightsLists.US;
    else
      result = m_flightsLists.WORLD;

    for (FlightQueryType query : m_activeQueries) {
      result  = m_queryManager.queryFlights(result, query, query.QueryValue);
    }

    s_DebugProfiler.startProfileTimer();
    m_onLoadDataEvent.accept(result);
    s_DebugProfiler.printTimeTakenMillis("User query event");
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
    addToQueryList(fqt, queryTypeStr + ": " + opStr + " [" + formatValue(text, queryType) + "]");
  }

  private void addToQueryList(FlightQueryType query, String text) {
    m_activeQueries.add(query);
    m_queryLB.add(text);
  }

  /**
   * M.Poole:
   * Saves all active queries entered by the user. Collects and stores all active queries
   * for loading data.
   */
  private void saveAllQueries() {
    saveQuery(m_originTB, QueryType.AIRPORT_ORIGIN_INDEX, QueryOperatorType.EQUAL);
    saveQuery(m_destTB, QueryType.AIRPORT_DEST_INDEX, QueryOperatorType.EQUAL);
    saveQuery(m_airlineTB, QueryType.CARRIER_CODE_INDEX, QueryOperatorType.EQUAL);
    saveQuery(m_flightNumTB, QueryType.FLIGHT_NUMBER, QueryOperatorType.EQUAL);

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
      addToQueryList(fqtD, "Not Cancelled");
    }
  }

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
    default:
      return text;
    }
  }
  
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
   * Adds a widget to the user interface. Incorporates a new widget into the interface layout
   * for user interaction and data display.
   *
   * @param widget The widget to be added to the interface.
   */
  private void addWidget(Widget widget) {
    m_screen.addWidget(widget);
    widget.setParent(this);
  }

  private void addWidgetGroup(WidgetGroupType group) {
    m_screen.addWidgetGroup(group);
  }

  public LabelUI createLabel(int posX, int posY, int scaleX, int scaleY, String text) {
    LabelUI label = new LabelUI(posX, posY, scaleX, scaleY, text);
    addWidget(label);
    return label;
  }

  public void setRenderWorldUSButtons(boolean enabled) {
    m_worldRadio.setRendering(enabled);
    m_usRadio.setRendering(enabled);
  }

  public void setWorldUSParent(Widget parent) {
    m_worldRadio.setParent(parent);
    m_usRadio.setParent(parent);
  }
}

// F.Wright  created Framework for UserQuery class 8pm 3/14/24
// M.Poole   fixed issue with key input not detecting and implemented Listbox Functionality
// M.Poole   implemented single item search querying
