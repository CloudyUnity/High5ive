class Image extends Widget{
  
  private PImage m_displayedImage;
  private int m_posX;
  private int m_posY;
  private int m_imageLength;
  private int m_imageWidth;

  Image(int scaleY, int scaleX, int posX, int posY){
    super(posX, posY, scaleX, scaleY);
    m_displayedImage = loadImage("data/Images/EarthDay2k.jpg");
    m_imageWidth = scaleX;
    m_imageLength = scaleY;
    m_posX = posX;
    m_posY = posY;
  }
  
  Image(PImage inputImage, int scaleY, int scaleX, int posX, int posY){
    super(posX, posY, scaleX, scaleY);
    m_displayedImage = inputImage;
    m_imageWidth = scaleX;
    m_imageLength = scaleY;
    m_posX = posX;
    m_posY = posY;
  }
  
  public void draw(){
    super.draw(); 
    image(m_displayedImage, m_posX, m_posY, m_imageWidth, m_imageLength); 
    
  }
  
 

}

//code authorship
// M.Poole 3/11/2024 XX:XXpm : Created Image Widget
