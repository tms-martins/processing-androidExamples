/*
 * This app simply illustrates that the sketch is re-started if you tilt the phone (changing the orientation).
 *
 * To prevent this, call orientation(PORTRAIT) or orientation(LANDSCAPE).
 * Your sketch will always be shown with the same orientation, 
 * and so it won't be restarted when someone tilts the screen. 
 * 
 * Tiago Martins 2017/2018
 * https://github.com/tms-martins/processing-androidExamples
 */
 
void setup() {
  fullScreen();

  // un-commenting the next line will prevent the sketch from re-starting when the phone is tilted
  // orientation(PORTRAIT); 
  // another possibility is 
  // orientation(LANDSCAPE);
  
  textSize(height/30);
  textAlign(CENTER, CENTER);
  
  println("setup() called, display size: " + width + "x" + height);
}

void draw() {
  background(0);
  fill(255);
  text("App started " + nf(millis()/1000.0, 0, 2) + " seconds ago\nDisplay size: " + width + "x" + height, 10, 10, width-20, height-20);
}