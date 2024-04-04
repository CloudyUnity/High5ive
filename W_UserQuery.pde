
  /**
 * M.Poole:
 * Represents a user interface for querying flight data. Manages user inputs and interactions
 * for querying flight data and displaying results.
 */
class UserQueryUI extends Widget {
  private Consumer<FlightType[]> m_onLoadDataEvent;

  QueryManagerClass m_queryManager;
  private ArrayList<FlightQueryType> m_activeQueries; // All query types are ordered like so (Day, Airline, FlightNum, Origin, Dest, SchDep, Dep, Depdelay, SchArr, Arr, ArrDelay, Cancelled, Dievrted, Miles  )
  private ArrayList<FlightQueryType> m_flightQueries;

  private ListboxUI m_queryLB;
  private TextboxUI m_originTB;
  private TextboxUI m_destTB;
  private TextboxUI m_distanceTB;
  private TextboxUI m_airlineTB;
  private TextboxUI m_flightNumTB;
  private TextboxUI m_arrTimeTB, m_arrSchTB, m_arrDelTB, m_depTimeTB, m_depSchTB, m_depDelTB;

  private RadioButtonUI m_cancelledRadio;
  private RadioButtonUI m_divertedRadio;
  private RadioButtonUI m_successRadio;
  private RadioButtonUI m_worldRadio;
  private RadioButtonUI m_usRadio;
  private ButtonUI m_clearListButton;
  private ButtonUI m_addItemButton;
  private ButtonUI m_loadDataButton;

  private QueryLocationType m_location = QueryLocationType.US;

  public int m_listCounter;
  private FlightQueryType m_originQuery;
  private FlightQueryType m_destQuery;
  private FlightQueryType m_distanceQuery;
  private FlightQueryType m_cancelledQuery;
  private FlightQueryType m_divertedQuery;
  private FlightQueryType m_airlineQuery;
  private FlightQueryType m_flightNumQuery;
  private FlightQueryType m_arrTimeQuery, m_arrSchQuery, m_arrDelQuery, m_depTimeQuery, m_depSchQuery, m_depDelQuery;
  private Screen m_screen;
 

  private FlightMultiDataType m_flightsLists;

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

    m_flightQueries = new ArrayList<FlightQueryType>();
    m_activeQueries = new ArrayList<FlightQueryType>();

    RadioButtonGroupTypeUI worldUSGroup = new RadioButtonGroupTypeUI();
    addWidgetGroup(worldUSGroup);

    m_worldRadio = new RadioButtonUI(width - 60, 20, 50, 50, "WORLD");
    m_worldRadio.getOnCheckedEvent().addHandler(e -> changeDataToWorld());
    worldUSGroup.addMember(m_worldRadio);

    m_usRadio = new RadioButtonUI(width - 60, 80, 50, 50, "US");
    m_usRadio.getOnCheckedEvent().addHandler(e -> changeDataToUS());
    worldUSGroup.addMember(m_usRadio);
    m_usRadio.setChecked(true);

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

    LabelUI cancelLabel = createLabel(17, 350, 160, 50, "C      D      N");
    cancelLabel.setTextSize(15);
    cancelLabel.setCentreAligned(false);


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

    m_originTB =  new TextboxUI(20, 500, 160, 30);
    addWidget(m_originTB);
    m_originTB.setPlaceholderText("Origin");

    m_originQuery = new FlightQueryType(QueryType.AIRPORT_ORIGIN_INDEX, QueryOperatorType.EQUAL, m_location);
    m_flightQueries.add(m_originQuery);

    m_destTB =  new TextboxUI(20, 550, 160, 30);
    addWidget(m_destTB);
    m_destTB.setPlaceholderText("Destination");

    m_destQuery = new FlightQueryType(QueryType.AIRPORT_DEST_INDEX, QueryOperatorType.EQUAL, m_location);
    m_flightQueries.add(m_destQuery);

    m_airlineTB =  new TextboxUI(170, 350, 160, 30);
    addWidget(m_airlineTB);
    m_airlineTB.setPlaceholderText("Airline");

    m_airlineQuery = new FlightQueryType(QueryType.CARRIER_CODE_INDEX, QueryOperatorType.EQUAL, m_location);
    m_flightQueries.add(m_airlineQuery);

    m_flightNumTB =  new TextboxUI(20, 400, 160, 30);
    addWidget(m_flightNumTB);
    m_flightNumTB.setPlaceholderText("Flight Number");

    m_flightNumQuery = new FlightQueryType(QueryType.FLIGHT_NUMBER, QueryOperatorType.EQUAL, m_location);
    m_flightQueries.add(m_flightNumQuery);

    m_cancelledQuery = new FlightQueryType(QueryType.CANCELLED, QueryOperatorType.NOT_EQUAL, m_location);
    m_flightQueries.add(m_cancelledQuery);
    m_cancelledQuery.setQueryValue(1);

    m_divertedQuery = new FlightQueryType(QueryType.DIVERTED, QueryOperatorType.NOT_EQUAL, m_location);
    m_flightQueries.add(m_cancelledQuery);
    m_divertedQuery.setQueryValue(1);

    m_distanceQuery = new FlightQueryType(QueryType.KILOMETRES_DISTANCE, QueryOperatorType.LESS_THAN, m_location);
    m_distanceTB = createTextboxWithOp(20, 450, 160, 40, "Distance", m_distanceQuery);

    m_arrTimeQuery = new FlightQueryType(QueryType.ARRIVAL_TIME, QueryOperatorType.LESS_THAN, m_location);
    m_arrTimeTB = createTextboxWithOp(20, 300, 160, 40, "Arrival Time (00:00)", m_arrTimeQuery);

    m_arrSchQuery = new FlightQueryType(QueryType.SCHEDULED_ARRIVAL_TIME, QueryOperatorType.LESS_THAN, m_location);
    m_arrSchTB = createTextboxWithOp(20, 250, 160, 40, "Scheduled Arrival", m_arrSchQuery);

    m_arrDelQuery = new FlightQueryType(QueryType.ARRIVAL_DELAY, QueryOperatorType.LESS_THAN, m_location);
    m_arrDelTB = createTextboxWithOp(20, 200, 160, 40, "Arrival Delay", m_arrDelQuery);
    
    m_depTimeQuery = new FlightQueryType(QueryType.DEPARTURE_TIME, QueryOperatorType.LESS_THAN, m_location);
    m_depTimeTB = createTextboxWithOp(20, 150, 160, 40, "Depart Time (00:00)", m_depTimeQuery);
    
    m_depSchQuery = new FlightQueryType(QueryType.SCHEDULED_DEPARTURE_TIME, QueryOperatorType.LESS_THAN, m_location);
    m_depSchTB = createTextboxWithOp(180, 100, 160, 40, "Scheduled Depart", m_depSchQuery);
    
    m_depDelQuery = new FlightQueryType(QueryType.DEPARTURE_DELAY, QueryOperatorType.LESS_THAN, m_location);
    m_depDelTB = createTextboxWithOp(180, 50, 160, 40, "Depart Delay", m_depDelQuery);
  }

  private TextboxUI createTextboxWithOp(int posX, int posY, int scaleX, int scaleY, String placeholder, FlightQueryType fqt) {
    TextboxUI tb = new TextboxUI(posX, posY, scaleX, scaleY);
    addWidget(tb);
    tb.setPlaceholderText(placeholder);

    m_flightQueries.add(fqt);

    DropdownUI<QueryOperatorType> opDD = new DropdownUI<QueryOperatorType>(posX + scaleX, posY, 100, 400, 30, v -> formatText(v.toString()));
    addWidget(opDD);
    opDD.setTextboxText(formatText("LESS_THAN"));
    opDD.getOnSelectionChanged().addHandler(e -> {
      ListboxSelectedEntryChangedEventInfoType elistbox = (ListboxSelectedEntryChangedEventInfoType)e;
      QueryOperatorType op = (QueryOperatorType)elistbox.Data;
      fqt.setOperator(op);
    }
    );
    opDD.add(QueryOperatorType.EQUAL);
    opDD.add(QueryOperatorType.NOT_EQUAL);
    opDD.add(QueryOperatorType.LESS_THAN);
    opDD.add(QueryOperatorType.GREATER_THAN);

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

  /**
   * M.Poole:
   * Saves a query based on the provided textbox and query type. Captures user input and saves
   * it as a query for loading data.
   *
   * @param inputField The input field containing the user query.
   * @param inputQuery The query to be saved.
   */
  private void saveQuery(TextboxUI inputField, FlightQueryType inputQuery) {
    if (inputField.getTextLength() <= 0)
      return;

    String text = inputField.getText().toUpperCase();
    if (text.isEmpty())
      return;

    inputField.setText("");

    int val = m_queryManager.formatQueryValue(inputQuery.Type, text);
    if (val == -1)
      return;

    inputQuery.setQueryValue(val);
    addToQueryList(inputQuery, formatText(inputQuery.Type.toString()) + ": " + formatText(inputQuery.Operator.toString()) + " [" + formatText(text) + "]");
  }

  private void addToQueryList(FlightQueryType query, String text) {
    m_activeQueries.add(query);
    m_queryLB.add(text);
    m_listCounter++;
  }

  /**
   * M.Poole:
   * Saves all active queries entered by the user. Collects and stores all active queries
   * for loading data.
   */
  private void saveAllQueries() {
    saveQuery(m_originTB, m_originQuery);
    saveQuery(m_destTB, m_destQuery);
    saveQuery(m_distanceTB, m_distanceQuery);
    saveQuery(m_airlineTB, m_airlineQuery);
    saveQuery(m_flightNumTB, m_flightNumQuery);
    saveQuery(m_arrTimeTB, m_arrTimeQuery);
    saveQuery(m_arrSchTB, m_arrSchQuery);
    saveQuery(m_arrDelTB, m_arrDelQuery);

    if (m_cancelledRadio.getChecked()) {
      m_cancelledQuery.setOperator(QueryOperatorType.EQUAL);
      addToQueryList(m_cancelledQuery, "Cancelled");
    }

    if (m_divertedRadio.getChecked()) {
      m_divertedQuery.setOperator(QueryOperatorType.EQUAL);
      addToQueryList(m_divertedQuery, "Diverted");
    }

    if (m_successRadio.getChecked()) {
      m_cancelledQuery.setOperator(QueryOperatorType.NOT_EQUAL);
      m_divertedQuery.setOperator(QueryOperatorType.NOT_EQUAL);
      addToQueryList(m_cancelledQuery, "Not Cancelled");
      addToQueryList(m_divertedQuery, "Not Diverted");
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

  /**
   * M.Poole:
   * Changes the operator for a given query. Modifies the operator used in a query based
   * on user interaction or selection.
   *
   * @param input         The query for which the operator needs to be changed.
   * @param inputOperator The new operator for the query.
   */
  private void changeOperator(FlightQueryType input, QueryOperatorType inputOperator) {
    input.setOperator(inputOperator);
  }

  private void setOperators() {
  }

  /**
   * M.Poole:
   * Clears all currently saved user queries. Resets the interface by removing all
   * saved queries and resetting input fields.
   */
  private void clearQueries() {
    m_originQuery = new FlightQueryType(QueryType.AIRPORT_ORIGIN_INDEX, QueryOperatorType.EQUAL, m_location);
    m_destQuery = new FlightQueryType(QueryType.AIRPORT_DEST_INDEX, QueryOperatorType.EQUAL, m_location);
    m_distanceQuery = new FlightQueryType(QueryType.KILOMETRES_DISTANCE, QueryOperatorType.LESS_THAN, m_location);
    m_airlineQuery = new FlightQueryType(QueryType.CARRIER_CODE_INDEX, QueryOperatorType.EQUAL, m_location);
    m_flightNumQuery = new FlightQueryType(QueryType.FLIGHT_NUMBER, QueryOperatorType.EQUAL, m_location);

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
