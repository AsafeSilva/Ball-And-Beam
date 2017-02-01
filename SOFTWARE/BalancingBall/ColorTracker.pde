class ColorTracker {

  private int trackerWidth;
  private int trackerHeight;
  private int xCoord;
  private int yCoord;  

  private int thresholdH;
  private int thresholdS;
  private int thresholdB;

  private color trackingColor;

  private int xPosition, yPosition;

  private int firstX, firstY;
  private int lastX, lastY;

  private boolean enableAnalyze = false;

  public ColorTracker(int x, int y, int _width, int _height) {

    this.xCoord = x;
    this.yCoord = y;

    this.trackerWidth = _width;
    this.trackerHeight = _height;

    this.thresholdH = 10;
    this.thresholdS = 40;
    this.thresholdB = 60;
  }

  public void analyze(PImage image) {

    if (!getEnableAnalyze()) return;

    firstX = firstY = trackerWidth + 1;
    lastX = lastY = -1;

    color currentColor;

    float diffH, diffS, diffB;

    colorMode(HSB);

    for (int curY = 0; curY < trackerHeight; curY+=5) {
      for (int curX = 0; curX < trackerWidth; curX+=5) {
        currentColor = image.get(curX, curY);

        diffH = abs(hue(trackingColor) - hue(currentColor));
        diffS = abs(saturation(trackingColor) - saturation(currentColor));
        diffB = abs(brightness(trackingColor) - brightness(currentColor));

        if (diffH < thresholdH && diffS < thresholdS && diffB <thresholdB) {
          if (curX < firstX) firstX = curX;
          if (curY < firstY) firstY = curY;
          if (curX > lastX)  lastX = curX;
          if (curY > lastY)  lastY = curY;

          stroke(80, 255, 255);
          strokeWeight(1);
          point(curX + xCoord, curY + yCoord);
        }
      }
    }

    setX(xCoord + firstX + abs(firstX - lastX) / 2);
    setY(yCoord + firstY + abs(firstY - lastY) / 2);
    
    noFill();
    strokeWeight(2);
    rect(firstX+xCoord, firstY+yCoord, abs(firstX - lastX), abs(firstY - lastY));
  }

  private void setX(int x) {  
    this.xPosition = x;
  }
  private void setY(int y) {  
    this.yPosition = y;
  }

  public int getX() {  
    return this.xPosition;
  }
  public int getY() {  
    return this.yPosition;
  }

  public void setTrackingColor(color c) {
    this.trackingColor = c;
  }

  public color getTrackingColor() {
    return this.trackingColor;
  }

  public void setEnableAnalyze(boolean enable) {
    this.enableAnalyze = enable;
  }

  public boolean getEnableAnalyze() {
    return this.enableAnalyze;
  }
  
  public void setThresholdH(int H){
    this.thresholdH = H;
  }
  
  public void setThresholdS(int S){
    this.thresholdS = S;
  }
  
  public void setThresholdB(int B){
    this.thresholdB = B;
  }  
}