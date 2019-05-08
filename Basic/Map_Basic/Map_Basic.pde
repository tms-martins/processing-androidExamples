/*
 * This sketch exemplifies a basic location map, without resort to Google Maps or Play Services.
 *
 * By default, tapping the map will set the user's position, and dragging will move the map.
 * Tapping the text rectangle below the map will enable/disable the use of automatic location.
 * When enabled, you won't be able to set the user's position or move the map (this is done automatically based on location coordinates).
 *
 * The sketch uses a custom map object PAMap, declared in a separate tab so it can easily be copied and used in another sketch.
 * You can add and change the user's location or other points-of-interest (POI) in GPS coordinates or pixel coordinates. 
 * To create the map you need an image where North is up, and the GPS coordinates of the corners which you can find
 * using Google Maps or Google Earth, for instance.
 *
 * The wrapper class for the location manager is in the file PALocationManager.java, 
 * which can easily be copied and used in another sketch.
 *
 * This sketch requires the permissions ACCESS_COARSE_LOCATION and ACCESS_FINE_LOCATION.
 * The permission ACCESS_COARSE_LOCATION is explicitly requested by the PALocationManager.
 *
 * Tiago Martins 2017-2019
 * https://github.com/tms-martins/processing-androidExamples
 */

// the location manager (wrapper)
PALocationManager location;

// when not using live location we can instead tap the map
boolean usingLocation = false;

// map object and image 
PAMap map;
PImage mapImage;

// coordinates for the map image's corners, used by the map to convert positions between pixels and GPS coordinates
double upperLeftLatitude = 48.307537;
double upperLeftLongitude = 14.283981;
double lowerRightLatitude = 48.304310;
double lowerRightLongitude = 14.293026;

// POIs (points of interest) on the map, and an image for the user's "avatar"
PAMapLocation pestsaule;
PAMapLocation pfarrkirche;
PAMapLocation userLocation;
PImage imageUser;


void setup() {
  orientation(PORTRAIT);

  // load the map image, pass it together with the corner's GPS coordinates to initialize the map
  mapImage = loadImage("Map_Linz_Downtown.jpg");
  map = new PAMap(this, mapImage, 
    upperLeftLatitude, 
    upperLeftLongitude, 
    lowerRightLatitude, 
    lowerRightLongitude);

  // sets the on-screen display area of the map (in this case, the whole screen)                     
  map.setView(0, 0, width, height);

  // set the location of points-of-interst in GPS coordinates and use a colored circle to display
  pestsaule   = map.addLocationGPS("Pestsaule", 48.30584, 14.286455, 20, color(#00FF00), null);
  pfarrkirche = map.addLocationGPS("Pfarrkirche", 48.306223, 14.288728, 50, color(#0000FF), null);

  // set the user's location in pixels, and use an image to display
  imageUser = loadImage("pin.png");
  userLocation = map.addLocationPix("User", 200, 200, 20, 0, imageUser);
  
  // create and start the location manager
  location = new PALocationManager(this);
  location.start();
}


// when the app loses focus, stop the location manager
void pause() {
  println("pause()");
  if (location != null) location.stop();
}


// when the app regains focus, start the location manager
void resume() {
  println("resume()");
  if (location != null) location.start();
}


void draw() {
  String message = "Tap to enable automatic location";
  
  // when using location data, the sketch automatically sets the user's position and centers the map
  // the display message is also more detailed
  if (usingLocation) {
    double latitude  = location.getLatitude();
    double longitude = location.getLongitude();
    
    map.setToGPS(userLocation, latitude, longitude);
    map.centerOnGPS(latitude, longitude);
    
    message = latitude + " ; " + longitude + "\nAccuracy: " + (int)location.getAccuracy() + " m (" + location.getProvider() + ")";
  }

  // clear the background and draw the map
  background(0); 
  map.draw();

  // draw a transparent white rectangle on the lower part of the screen 
  noStroke();
  fill(255, 190);
  rect(0, height * 7/8, width, height /8);
  fill(0);

  // draw a status message within the rectangle 
  textAlign(CENTER, CENTER);
  textSize(height/35);
  text(message, 10, height * 7/8, width, height /8);
}


// when not using the location, pan the map by dragging the "mouse"
void mouseDragged() {
  if (!usingLocation) {
    map.pan(mouseX - pmouseX, mouseY - pmouseY);
  }
}


// tapping on the lower 8th of the screen enables/disables the use of the location service;
// when disabled, tapping on the map will set the user's location
void mousePressed() {
  if (mouseY > height *7/8) {
    usingLocation = !usingLocation;
  } else if (!usingLocation) {
    map.setToMouse(userLocation);
  }
}
