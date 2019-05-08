/*
 * This sketch displays the map of a location, and triggers an audio sample depending on the user's
 * proximity to a defined target. As the player moves closer to the target, the audio sample will play
 * louder and more often.
 *
 * By default, tapping the map will set the user's position, and dragging will move the map.
 * Tapping the text rectangle below the map will enable/disable the use of automatic location.
 * When enabled, you won't be able to set the user's position or move the map (this is done automatically based on location coordinates).
 *
 * The sketch makes use of a PAMap object to display a map image and relevant locations,
 * a PAAudioPlayer object to load and play an audio sample and the Ketai library to retrieve the user's location. 
 *
 * This sketch requires the permissions ACCESS_COARSE_LOCATION and ACCESS_FINE_LOCATION.
 * The permission ACCESS_COARSE_LOCATION is explicitly requested when creating the KetaiLocation object.
 *
 * Tiago Martins 2017-2019
 * https://github.com/tms-martins/processing-androidExamples
 */

import ketai.sensors.*; 

// the location object, which must be initialized inside resume()
KetaiLocation ketaiLocationService;

// local variables for location data and state
double longitude, latitude, altitude, accuracy;
String provider = "none";
boolean usingLocationService = false;

// map object and image 
PAMap map;
PImage mapImage;

// coordinates for the map image's corners, used by the map to convert positions between pixels and GPS coordinates
double upperLeftLatitude   = 48.307537;
double upperLeftLongitude  = 14.283981;
double lowerRightLatitude  = 48.304310;
double lowerRightLongitude = 14.293026;

// important locations on the map, and an image for the user's "avatar"
PAMapLocation targetLocation;
PAMapLocation userLocation;
PImage imageUser;

// current distance from user to target location, and mapping range between distance and the sound's volume 
float distanceToTarget = 1000.0;
float minDistance      =   20.0;
float maxDistance      = 1000.0; 

// audio player objects and playback timing variables 
PAAudioPlayer audioSonar;
int timeLastPlayed   = 0;
int minTimePlayerRepeat = 1000;
int maxTimePlayerRepeat = 5000;

// GUI message
String message = "setting up";

void setup() {
  fullScreen();
  orientation(PORTRAIT);
  
  // load the map image, pass it together with the corner's GPS coordinates to initialize the map
  mapImage = loadImage("Map_Linz_Downtown.jpg");
  map = new PAMap(this, mapImage, 
                      upperLeftLatitude,
                      upperLeftLongitude,
                      lowerRightLatitude,
                      lowerRightLongitude);
                      
  // sets the on-screen display area of the map                    
  map.setView(0, 0, width, height);
  
  // set the user's location in pixels, and use an image to display
  imageUser = loadImage("pin.png");
  userLocation = map.addLocationPix("User", 200, 200, 20, 0, imageUser);
  
  // set the target's location in GPS coordinates and use a colored circle to display
  targetLocation = map.addLocationGPS("Pestsaule", 48.30584, 14.286455, 20, color(#00FF00), null);

  // initialize the audio player
  audioSonar = new PAAudioPlayer();
  audioSonar.loadFile(this, "sonar.mp3");
}

void draw() {
  // when using location data, the sketch automatically sets the user's position and centers the map
  if (usingLocationService) {
    map.setToGPS(userLocation, latitude, longitude);
    map.centerOnGPS(latitude, longitude);
  }
  
  // calculate the distance (in pixels) between user and target
  distanceToTarget = dist(userLocation.pixX, userLocation.pixY, targetLocation.pixX, targetLocation.pixY); 
  
  // calculate the volume of the audio based on the distance between user and target 
  float audioVolume = map(distanceToTarget, minDistance, maxDistance, 1.0, 0.0);
  audioVolume = constrain(audioVolume, 0.0, 1.0);
  
  // set the time for repeating the audio sample based on the distance between user and target
  int timePlayerRepeat = (int)map(distanceToTarget, minDistance, maxDistance, minTimePlayerRepeat, maxTimePlayerRepeat);
  timePlayerRepeat = constrain(timePlayerRepeat, minTimePlayerRepeat, maxTimePlayerRepeat);
  
  message = "Location: ";
  
  // compose the location part of the message depending on the use/state of the location service
  if (!usingLocationService) {
    message += "disabled (tap here to enable)";
  }
  else if (provider == "none" || accuracy == 0.0) {
    message += "no signal";
  }
  else {
    message += provider + ", accuracy: " + nf((float)accuracy, 0, 2) + "\nlon/lat: " + (float)longitude + " ; " + (float)latitude;
  }
  
  // add distance, audio volume and play time to the GUI message
  message += "\nDistance: " + (int)distanceToTarget + "\nVolume: " + nf(audioVolume, 0, 2) + "\nTime: " + timePlayerRepeat;
  
  // if the user is close enough to the target and the audio isnt playing for a while, set the volume and trigger the sample
  if (distanceToTarget <= maxDistance) {
    int currentTime = millis();
    if (currentTime - timeLastPlayed > timePlayerRepeat) {
      timeLastPlayed = currentTime;
     
      audioSonar.setVolume(audioVolume, audioVolume);
      audioSonar.play();
    }
  }
  
  // clear the background and draw the map
  background(0); 
  map.draw();
  
  // draw a transparent white rectangle on the lower 5th of the screen 
  noStroke();
  fill(255, 190);
  rect(0, height * 4/5, width, height /5);
  fill(0);
  
  // draw a status message within the rectangle 
  textAlign(LEFT, CENTER);
  textSize(height/35);
  text(message, 10, height * 4/5, width, height /5);
}

// when not using the location, pan the map by dragging the "mouse"
void mouseDragged() {
  if (!usingLocationService) {
    map.pan(mouseX - pmouseX, mouseY - pmouseY);
  }
}

// tapping on the lower 5th of the screen enables/disables the use of the location service;
// when disabled, tapping on the map will set the user's location
void mousePressed() {
  if (mouseY > height *4/5) {
    usingLocationService = !usingLocationService;
  }
  else if (!usingLocationService) {
    map.setToMouse(userLocation);
  }
}

// the KetaiLocation object must be initialized on resume() instead of setup()
void resume() {
  ketaiLocationService = new KetaiLocation(this);
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
