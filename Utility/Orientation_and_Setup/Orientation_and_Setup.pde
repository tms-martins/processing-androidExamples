/*
 * This app simply illustrates that the sketch is re-started if you tilt the phone (changing the orientation).
 * Re-starting may also cause the app to crash.
 *
 * To prevent this, call orientation(PORTRAIT) or orientation(LANDSCAPE).
 * Your sketch will always be shown with the same orientation, 
 * and so it won't be restarted when someone tilts the screen. 
 * 
 * Tiago Martins 2017
 * https://github.com/tms-martins/processing-androidExamples
 */
 
void setup() {
  // un-commenting the next line will prevent the sketch from re-starting when the phone is tilted
  // orientation(PORTRAIT); 
  // another possibility is 
  // orientation(LANDSCAPE);
  
  // this is necessary otherwise the app will start at 100x100 pixels; 
  // we use P2D for compatibility with older devices
  size(displayWidth, displayHeight, P2D);
  
  textFont(createFont("system", 20));
  textAlign(CENTER, CENTER);
  println("Hello World, setup() called");
}

void draw() {
  background(0);
  fill(255);
  text("App started " + nf(millis()/1000.0, 0, 2) + " seconds ago\nScreen size: " + width + "x" + height, 0, 0, width, height);
}