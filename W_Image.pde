class ImageUI extends Widget{
  
  private PImage m_displayedImage = null;
  private int m_posX;
  private int m_posY;
  private int m_imageLength;
  private int m_imageWidth;

  ImageUI(int scaleY, int scaleX, int posX, int posY){
    super(posX, posY, scaleX, scaleY);
    m_imageWidth = scaleX;
    m_imageLength = scaleY;
    m_posX = posX;
    m_posY = posY;
  }
  
  ImageUI(PImage inputImage, int scaleY, int scaleX, int posX, int posY ){
    this(scaleY, scaleX, posX, posY);
    m_displayedImage = inputImage;
  }
  
  @ Override
  public void draw(){
    super.draw();
    if (m_displayedImage != null)
      image(m_displayedImage, m_posX, m_posY, m_imageWidth, m_imageLength);
  }
  
  public void setImage(PImage inputImage) {
    m_displayedImage = inputImage; 
  }
}

//code authorship
// M.Poole 3/11/2024 XX:XXpm : Created Image Widget
// A. Robertson, Changed ImageUI, 14/03/2024
