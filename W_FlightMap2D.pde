class FlightMap2DUI extends Widget {

  private PImage m_mapImage;
  private List<TwoDFlight> flightList ;

  public FlightMap2DUI(int posX, int posY, int scaleX, int scaleY) {
    super(posX, posY, scaleX, scaleY);
    m_mapImage = loadImage("data/Images/EarthDay2kNoIce.jpg");
    List<TwoDFlight> flightList = new ArrayList<TwoDFlight>();
  }
  private void loadFlightsTwoD(FlightType[] flights, QueryManagerClass queries, int startIndex, int endIndex) {
    TwoDFlight temp ;
    
    for (int i = startIndex; i < endIndex; i++)
    {
       temp = new TwoDFlight(flights, queries, i);
       flightList.add(temp);
    }
    
    
  }

  // Draws the map
  @ Override
    public void draw() {
    super.draw();

    fill(m_backgroundColour);
    image(m_mapImage, 200, 0, (displayWidth-200), (displayHeight-100));
  }
}

class TwoDFlight {
  String originCode, destCode ;
  CoordType Origin ;
  CoordType Destination ;

  TwoDFlight(FlightType[] flights, QueryManagerClass queries, int index)
  {
    float originLongi = -queries.getLongitudeFromIndex(flights[index].AirportOriginIndex);
    float originLat = queries.getLatitudeFromIndex(flights[index].AirportOriginIndex);
    float destLongi = -queries.getLongitudeFromIndex(flights[index].AirportDestIndex);
    float destLat = queries.getLatitudeFromIndex(flights[index].AirportDestIndex);  ;
    
    String originCode = queries.getCode(flights[index].AirportOriginIndex);
    String destCode = queries.getCode(flights[index].AirportDestIndex);
    CoordType Origin = new CoordType(originLongi, originLat);
    CoordType Destination = new CoordType(destLongi, destLat) ;
  }
}





// M. Orlowski: Added this to not mess with anything else that uses the W_FlightMap map.

/** TO DO!
 * Create function to load full map data into 2d map
 * Display flights using similar points connections to Finn
 * Connect queries to 2d map
