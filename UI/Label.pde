class Label extends Widget {
  public Label(int x, int y, int width, int height, String text) {
    super(x, y, width, height);
    this.text = text;
    this.textSize = 12;
    this.textYOffset = 0;
    this.textXOffset = 5;
    this.centreAligned = false;
  }
  
  @ Override
  public void draw() {
    super.draw();
    
    if (this.text != null) {
      textSize(this.textSize);
      fill(this.foregroundColour);
      textAlign(this.centreAligned ? CENTER : LEFT, CENTER);
      text(this.text, this.x + this.textXOffset, this.y + this.textYOffset, this.width - this.textXOffset, this.height - this.textYOffset);
    }
  }
  
  public void setCentreAligned(boolean centreAligned) {
    this.centreAligned = centreAligned;
  }
  
  public void setText(String text) {
    this.text = text;
  }

  /**
   * Sets the button text size.
   *
   * @param  textSize The size of the text.
   * @throws IllegalArgumentException when the size argument is negative.
   **/
  public void setTextSize(int textSize) {
    if (textSize < 0)
      throw new IllegalArgumentException("Text size cannot be less than 0.");
    else
      this.textSize = textSize;
  }

  /**
   * Sets the button text offset from the left edge if not centred.
   *
   * @param  textXOffset The offset from the left edge of the button.
   * @throws IllegalArgumentException when the textXOffset argument is negative.
   **/
  public void setTextXOffset(int textXOffset) {
    if (textXOffset < 0)
      throw new IllegalArgumentException("Text X offset cannot be less than 0.");
    else
      this.textXOffset = textXOffset;
  }

  /**
   * Sets the button text offset from the top edge if not centred.
   *
   * @param  textXOffset The offset from the left edge of the button.
   * @throws IllegalArgumentException when the textXOffset argument is negative.
   **/
  public void setTextYOffset(int textYOffset) {
    if (textYOffset < 0)
      throw new IllegalArgumentException("Text Y offset cannot be less than 0.");
    else
      this.textYOffset = textYOffset;
  }
  
  private boolean centreAligned;
  private String text; // Can be null
  private int textSize, textXOffset, textYOffset;
}
