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
  private ListboxUI m_queryList;
  private TextboxUI m_Origin;
  private TextboxUI m_Dest;
  private TextboxUI m_Distance;
  private ButtonUI  clearListButton;
  private ButtonUI  removeSelectedButton;
  private ButtonUI  addItemButton;
  private ButtonUI  loadDataButton;
  private ButtonUI  setOperatorsBttn;
  private CheckboxUI m_Cancelled;
  private QueryLocationType m_location = QueryLocationType.US;
  public int m_listCounter;
  private FlightQueryType m_OriginQuery;
  private FlightQueryType m_DestQuery;
  private FlightQueryType m_DistanceQuery;
  private FlightQueryType m_CancelledQuery;
  private FlightType[] m_flights;
  private FlightMap3D m_flightMap3D;
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

    m_queryList = new ListboxUI<String>(20, 650, 200, 400, 40, v -> v);

    m_flightQueries = new ArrayList<FlightQueryType>();
    m_activeQueries = new ArrayList<FlightQueryType>();

    addWidget(m_queryList);

    RadioButtonGroupTypeUI group = new RadioButtonGroupTypeUI();
    addWidgetGroup(group);

    RadioButtonUI worldRadio = new RadioButtonUI(width/3, 20, 50, 50, "Histogram");
    worldRadio.getOnCheckedEvent().addHandler(e -> changeDataToUS());
    group.addMember(worldRadio);

    RadioButtonUI usRadio = new RadioButtonUI(width/2, 20, 50, 50, "Pie");
    usRadio.getOnCheckedEvent().addHandler(e -> changeDataToWorld());
    group.addMember(usRadio);

    addItemButton = new ButtonUI(20, 600, 80, 20);
    addWidget(addItemButton);
    addItemButton.setText("Add item");
    addItemButton.getOnClickEvent().addHandler(e -> saveAllQueries());

    clearListButton = new ButtonUI(120, 600, 80, 20);
    addWidget(clearListButton);
    clearListButton.setText("Clear");
    clearListButton.getOnClickEvent().addHandler(e -> clearQueries());

    removeSelectedButton = new ButtonUI(120, 500, 80, 20);
    addWidget(removeSelectedButton);
    removeSelectedButton.setText("Remove selected");
    removeSelectedButton.getOnClickEvent().addHandler(e -> m_queryList.removeSelected());

    loadDataButton = new ButtonUI(220, 500, 180, 120);
    addWidget(loadDataButton);
    loadDataButton.setText("Load Data");
    loadDataButton.getOnClickEvent().addHandler(e -> loadData());

    setOperatorsBttn = new ButtonUI(220, 700, 180, 120);
    addWidget(loadDataButton);
    loadDataButton.setText("Load Data");
    loadDataButton.getOnClickEvent().addHandler(e -> setOperators());

    m_Origin =  new TextboxUI(20, 500, 160, 30);
    addWidget(m_Origin);
    m_Origin.setPlaceholderText("Origin");


    m_OriginQuery = new FlightQueryType(QueryType.AIRPORT_ORIGIN_INDEX, QueryOperatorType.EQUAL, m_location);
    m_flightQueries.add(m_OriginQuery);


    m_Dest =  new TextboxUI(20, 550, 160, 30);
    addWidget(m_Dest);
    m_Dest.setPlaceholderText("Destination");


    m_DestQuery = new FlightQueryType(QueryType.AIRPORT_DEST_INDEX, QueryOperatorType.EQUAL, m_location);
    m_flightQueries.add(m_DestQuery);

    m_Distance =  new TextboxUI(20, 450, 160, 30);
    addWidget(m_Distance);
    m_Distance.setPlaceholderText("Kilometers ");


    m_DistanceQuery = new FlightQueryType(QueryType.KILOMETRES_DISTANCE, QueryOperatorType.LESS_THAN, m_location);
    m_flightQueries.add(m_DestQuery);

    

    m_CancelledQuery = new FlightQueryType(QueryType.KILOMETRES_DISTANCE, QueryOperatorType.EQUAL, m_location);
    m_flightQueries.add(m_DestQuery);
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
    if (m_location == QueryLocationType.US) {
      result = m_flightsLists.US;
    } else {
      result = m_flightsLists.WORLD;
    }
    for (FlightQueryType query : m_activeQueries) {
      result  = m_queryManager.queryFlights(result, query, query.QueryValue);
    }

    //result = m_queryManager.getHead(m_flightsLists.WORLD , 10);

    println(m_OriginQuery.QueryValue);

    s_DebugProfiler.startProfileTimer();
    m_onLoadDataEvent.accept(result);
    s_DebugProfiler.printTimeTakenMillis("User query event");
  }

  /**
   * M.Poole:
   * Saves a query based on the provided input field and query type. Captures user input and saves
   * it as a query for further data retrieval and analysis.
   *
   * @param inputField The input field containing the user query.
   * @param inputQuery The query to be saved.
   */

  private void saveQuery( Widget inputField, FlightQueryType inputQuery) {
    // Saves currently written user input into a quer
    if (inputField instanceof TextboxUI) {

      if (((TextboxUI)inputField).getTextLength() > 0 ) {
        int dayVal = m_queryManager.formatQueryValue(inputQuery.Type, ((TextboxUI)inputField).getText().toUpperCase());
        inputQuery.setQueryValue(dayVal);
        m_activeQueries.add(inputQuery);
      }
    }

    // Adds to query output field textbox thing
    m_queryList.add((((TextboxUI)inputField).getText()).toUpperCase() );
    m_listCounter++;

    // Set all user inputs back to default
    ((TextboxUI)inputField).setText("");
  }
  /**
   * M.Poole:
   * Saves all active queries entered by the user. Collects and stores all active queries
   * for subsequent data retrieval and analysis.
   */
  private void saveAllQueries() {
    saveQuery(m_Origin, m_OriginQuery);
    saveQuery(m_Dest, m_DestQuery);
    saveQuery(m_Distance, m_DistanceQuery);
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
    // Clear all currently saved user queries


    m_OriginQuery = new FlightQueryType(QueryType.AIRPORT_ORIGIN_INDEX, QueryOperatorType.EQUAL, m_location);
    m_DestQuery = new FlightQueryType(QueryType.AIRPORT_DEST_INDEX, QueryOperatorType.EQUAL, m_location);
    m_DistanceQuery = new FlightQueryType(QueryType.KILOMETRES_DISTANCE, QueryOperatorType.LESS_THAN, m_location);
    m_activeQueries = new ArrayList<FlightQueryType>();

    m_queryList.clear();
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
}

// F.Wright  created Framework for UserQuery class 8pm 3/14/24
// M.Poole   fixed issue with key input not detecting and implemented Listbox Functionality
// M.Poole   implemented single item search querying
