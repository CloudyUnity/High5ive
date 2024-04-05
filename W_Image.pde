/**
 * M.Poole:
 * Represents an image widget for displaying images on the screen.
 * Extends the Widget class.
 */

class ImageUI extends Widget {
  private PImage m_displayedImage = null;
  private int m_posX;
  private int m_posY;
  private int m_imageLength;
  private int m_imageWidth;
/**
 * M.Poole:
 * Constructs an ImageUI object with the specified dimensions and position.
 *
 * @param scaleX The width of the image.
 * @param scaleY The height of the image.
 * @param posX   The x-coordinate of the image's position.
 * @param posY   The y-coordinate of the image's position.
 */
  ImageUI(int posX, int posY, int scaleX, int scaleY) {
    super(posX, posY, scaleX, scaleY);
    m_imageWidth = scaleX;
    m_imageLength = scaleY;
    m_posX = posX;
    m_posY = posY;
  }
  /**
 * M.Poole:
 * Constructs an ImageUI object with the specified input image, dimensions, and position.
 *
 * @param inputImage The image to be displayed.
 * @param scaleX     The width of the image.
 * @param scaleY     The height of the image.
 * @param posX       The x-coordinate of the image's position.
 * @param posY       The y-coordinate of the image's position.
 */

  ImageUI(PImage inputImage, int posX, int posY, int scaleX, int scaleY) {
    this(posX, posY, scaleX, scaleY);
    m_displayedImage = inputImage;
  }
/**
 * M.Poole:
 * Overrides the draw method to draw the displayed image on the screen.
 * If an image is set, it draws the image at the specified position with the specified dimensions.
 */
  @ Override
    public void draw() {
    super.draw();
    if (m_displayedImage != null)
      image(m_displayedImage, m_posX, m_posY, m_imageWidth, m_imageLength);
  }
/**
 * M.Poole:
 * Sets a new image to be displayed.
 *
 * @param inputImage The image to be displayed.
 */
  public void setImage(PImage inputImage) {
    m_displayedImage = inputImage;
  }
// toms functions
  public void setPos(posX, posY) {
    m_posX = posX;
    m_posY = posY;
  }
  public void setScale(scaleX, scaleY) {
    m_scaleX = scaleX;
    m_scaleY = scaleY;
  }
  public int[] getPos() {
    return {m_posX, m_posY}
  }
  public int[] getScale() {
    return {m_scaleX, m_scaleY}
  }
}

//code authorship
// M.Poole 3/11/2024 : Created Image Widget
// A. Robertson, Changed ImageUI, 14/03/2024
