/*
 * This sketch exemplifies a basic location map, without resort to Google Maps or Play services.
 *
 * The location is obtained through the Ketai library.
 * When the automatic location is disabled, the user's position can be set by tapping on the map. 
 *
 * This sketch requires the permissions ACCESS_COARSE_LOCATION and ACCESS_FINE_LOCATION.
 *
 * Tiago Martins 2017
 * tms[dot]martins[at]gmail[dot]com
 */

import ketai.sensors.*; 

// the location object, which must be initialized inside resume()
KetaiLocation location;

// local variables for location data and state
double longitude, latitude, altitude, accuracy;
String provider = "none";
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
  size(displayWidth, displayHeight, P2D);

  // load the map image, pass it together with the corner's GPS coordinates to initialize the map
  mapImage = loadImage("Map_Linz_Downtown.jpg");
  map = new PAMap(this, mapImage, 
    upperLeftLatitude, 
    upperLeftLongitude, 
    lowerRightLatitude, 
    lowerRightLongitude);

  // sets the on-screen display area of the map                     
  map.setView(0, 0, width, height);

  // set the location of points-of-interst in GPS coordinates and use a colored circle to display
  pestsaule   = map.addLocationGPS("Pestsaule", 48.30584, 14.286455, 20, color(#00FF00), null);
  pfarrkirche = map.addLocationGPS("Pfarrkirche", 48.306223, 14.288728, 50, color(#0000FF), null);

  // set the user's location in pixels, and use an image to display
  imageUser = loadImage("pin.png");
  userLocation = map.addLocationPix("User", 200, 200, 20, 0, imageUser);
}

void draw() {
  String message = "Tap to enable automatic location";
  
  // when using location data, the sketch automatically sets the user's position and centers the map
  // the display message is also more detailed
  if (usingLocation) {
    map.setToGPS(userLocation, latitude, longitude);
    map.centerOnGPS(latitude, longitude);
    
    message = latitude + " ; " + longitude + "\nAccuracy: " + (int)accuracy + " m (" + provider + ")";
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

// the KetaiLocation object must be initialized on resume() instead of setup()
void resume() {
  location = new KetaiLocation(this);
}

// called by the Ketai library when the location is updated
void onLocationEvent(Location _location)
{
  // DEBUG: uncomment to print out the location object
  // println("onLocation event: " + _location.toString()); 

  // copy the updated location data to our local variables
  longitude = _location.getLongitude();
  latitude  = _location.getLatitude();
  altitude  = _location.getAltitude();
  accuracy  = _location.getAccuracy();
  provider  = _location.getProvider();
}