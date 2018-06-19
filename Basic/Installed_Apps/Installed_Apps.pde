/*
 * This sketch lists all the apps installed on the device.
 *
 * The functions for listing installed apps are implemented in a separate tab 
 * so they may easily be copied onto another sketch.
 *
 * Tiago Martins 2017/2018
 * https://github.com/tms-martins/processing-androidExamples
 */


ArrayList<String> appsList;


void setup() {
  fullScreen();
  orientation(PORTRAIT);
  
  // obtain a list of installed apps
  // you can also use getAllAppsList() for a full list including system apps
  appsList = getUserAppsList(); 
  
  // print all items in the list 
  for (String appName : appsList) {
    println(appName);
  }
  
  // set the text size and drawing parameters
  textSize(height/30);
  textAlign(CENTER, CENTER);
  fill(0);
  noStroke();
}


void draw() {
  background(255);
  text("Found " + appsList.size() + " apps\n(user-installed)", 0, 0, width, height);
}