class PAMap {

  PApplet app;

  PImage imgMap;
  double ulLat;
  double ulLon;
  double lrLat;
  double lrLon;

  int pixWidth;
  int pixHeight;
  double scaleLat = 0.0f;
  double scaleLon = 0.0f;

  PGraphics gBuffer;
  PImage imgBuffer;
  boolean redrawBuffer = false;

  int LATITUDE = 1;
  int LONGITUDE = 0;

  int scrX = 0;
  int scrY = 0;
  int scrW = 0;
  int scrH = 0;
  int scrOffsetX = 0;
  int scrOffsetY = 0;

  ArrayList<PAMapLocation> locations;

  PAMap(PApplet app, PImage mapImage, double ulLat, double ulLon, double lrLat, double lrLon) {
    this.app = app;

    this.ulLat = ulLat;
    this.ulLon = ulLon;
    this.lrLat = lrLat;
    this.lrLon = lrLon;

    setMapImage(mapImage);

    this.scrW = width;
    this.scrH = height;
    this.locations = new ArrayList<PAMapLocation>();
  }

  void setView(int x, int y, int w, int h) {
    this.scrX = x;
    this.scrY = y;
    this.scrW = w;
    this.scrH = h;
    println("Creating map buffer " + scrW + "x" + scrH);
    gBuffer = app.createGraphics(scrW, scrH);
    redrawBuffer = true;
  }

  protected void setMapImage(PImage imgMap) {
    this.imgMap = imgMap;
    calculateCoords();
    PApplet.println(
      "ulLat " + this.ulLat
      + "\nulLon " + this.ulLon
      + "\nlrLat " + this.lrLat
      + "\nrlLon " + this.lrLon
      + "\nscaleLat " + scaleLat
      + "\nscaleLon " + scaleLon);
  }

  protected void calculateCoords() {
    this.pixWidth = imgMap.width;
    this.pixHeight = imgMap.height;
    this.scaleLat = (lrLat - ulLat) / (double) pixHeight;
    this.scaleLon = (lrLon - ulLon) / (double) pixWidth;
  }

  double[] pixToGPS(double[] pixCoord) {
    double[] gpsCoord = new double[2];
    gpsCoord[LONGITUDE] = ulLon + (pixCoord[0] * scaleLon);
    gpsCoord[LATITUDE] = ulLat + (pixCoord[1] * scaleLat);
    return gpsCoord;
  }

  double[] gpsToPix(double[] gpsCoord) {
    double[] pixCoord = new double[2];
    pixCoord[0] = (gpsCoord[LONGITUDE] - ulLon) / scaleLon;
    pixCoord[1] = (gpsCoord[LATITUDE] - ulLat) / scaleLat;
    return pixCoord;
  }

  void pixToGPS(PAMapLocation item) {
    double[] pix = new double[2];
    pix[0] = item.pixX;
    pix[1] = item.pixY;
    double[] result = this.pixToGPS(pix);
    item.lat = result[LATITUDE];
    item.lon = result[LONGITUDE];
  }

  void gpsToPix(PAMapLocation item) {
    double[] gps = new double[2];
    gps[LATITUDE] = item.lat;
    gps[LONGITUDE] = item.lon;
    double[] result = this.gpsToPix(gps);
    item.pixX = (int) result[0];
    item.pixY = (int) result[1];
  }

  protected void verifyPosition() {
    if (scrOffsetX < 0) {
      scrOffsetX = 0;
    } else if (scrOffsetX > pixWidth - scrW) {
      scrOffsetX = (int)(pixWidth - scrW);
    }
    if (scrOffsetY < 0) {
      scrOffsetY = 0;
    } else if (scrOffsetY > pixHeight - scrH) {
      scrOffsetY = (int)(pixHeight - scrH);
    }
    
    if (pixWidth  < scrW) scrOffsetX = 0;
    if (pixHeight < scrH) scrOffsetY = 0;
  }

  void pan(float dX, float dY) {
    scrOffsetX -= dX;
    scrOffsetY -= dY;

    verifyPosition();
    redrawBuffer = true;
  }

  int[] getCenterPix() {
    int[] centerPix = new int[2];
    centerPix[0] = (int)(scrOffsetX + (scrW/2.0));
    centerPix[1] = (int)(scrOffsetY + (scrH/2.0));
    return centerPix;
  }

  void centerOnGPS(double lat, double lon) {
    int pixX = (int) ((lon - ulLon) / scaleLon);
    int pixY = (int) ((lat - ulLat) / scaleLat);
    centerOnPix(pixX, pixY);
  }

  void centerOnPix(int x, int y) {
    scrOffsetX = (int)(x - (scrW/2.0));
    scrOffsetY = (int)(y - (scrH/2.0));
    verifyPosition();        
    redrawBuffer = true;
  }
  
  void setToMouse(PAMapLocation item) {
    item.pixX = mouseX - scrX + scrOffsetX;
    item.pixY = mouseY - scrY + scrOffsetY;
    pixToGPS(item);
    redrawBuffer = true;
  }
  
  void setToPix(PAMapLocation item, int pixX, int pixY) {
    item.pixX = pixX;
    item.pixY = pixY;
    pixToGPS(item);
    redrawBuffer = true;
  }
  
  void setToGPS(PAMapLocation item, double latitude, double longitude) {
    item.lat = latitude;
    item.lon = longitude;
    item.pixX = mouseX - scrX + scrOffsetX;
    item.pixY = mouseY - scrY + scrOffsetY;
    gpsToPix(item);
    redrawBuffer = true;
  }

  void draw() {
    if (redrawBuffer) {
      gBuffer.beginDraw();
      gBuffer.background(0);
      gBuffer.imageMode(PApplet.CORNER);
      gBuffer.pushMatrix();
      gBuffer.translate(-scrOffsetX, -scrOffsetY);
      gBuffer.image(imgMap, 0, 0);
      gBuffer.popMatrix();
      drawLocations();
      gBuffer.endDraw();
      imgBuffer = gBuffer.get(0, 0, scrW, scrH);
      redrawBuffer = false;
    }
    app.imageMode(PApplet.CORNER);
    app.image(imgBuffer, scrX, scrY, scrW, scrH);
  }

  void addLocation(PAMapLocation item) {
    locations.add(item);
    redrawBuffer = true;
  }

  PAMapLocation addLocationGPS(String name, double lat, double lon, float radius, color col, PImage image) {
    PAMapLocation newItem = new PAMapLocation(name, lat, lon, radius, col, image);
    gpsToPix(newItem);
    locations.add(newItem);
    redrawBuffer = true;
    return newItem;
  }

  PAMapLocation addLocationPix(String name, int x, int y, float radius, color col, PImage image) {
    PAMapLocation newItem = new PAMapLocation(name, 0, 0, radius, col, image);
    newItem.pixX = x;
    newItem.pixY = y;
    pixToGPS(newItem);
    locations.add(newItem);
    redrawBuffer = true;
    return newItem;
  }

  PAMapLocation getLocationByName(String name) {
    for (PAMapLocation item : this.locations) {
      if (name.equalsIgnoreCase(item.name)) {
        return item;
      }
    }
    return null;
  }

  public void refresh() {
    redrawBuffer = true;
  }

  protected void drawLocations() {
    gBuffer.imageMode(PApplet.CENTER);
    gBuffer.noStroke();
    for (PAMapLocation item : locations) {
      if (item.active) {
        float itemX = item.pixX + this.scrX - this.scrOffsetX;
        float itemY = item.pixY + this.scrY - this.scrOffsetY;
        if (item.image != null) {
          gBuffer.image(item.image, itemX, itemY);
        } else {
          gBuffer.fill(item.col);
          gBuffer.ellipse(itemX, itemY, item.radius *2, item.radius *2);
        }
      }
    }
  }
}

class PAMapLocation {
  String name;
  int pixX = 0;
  int pixY = 0;
  double lat = 0.0f;
  double lon = 0.0f;

  PImage image;
  float radius;
  color col;
  boolean active; 

  PAMapLocation (String name, double lat, double lon, float radius, color col, PImage image) {
    this.lat = lat;
    this.lon = lon;
    this.name = name;
    this.radius = radius;
    this.image = image;
    this.col = col;
    this.active = true;
  }

  void setActive(boolean active) {
    this.active = active;
  }

  boolean isActive() {
    return this.active;
  }

  String toString() {
    return "Map Position " + name + " at (" + pixX + "," + pixY + "):" + radius + "  active: " + active;
  }
}