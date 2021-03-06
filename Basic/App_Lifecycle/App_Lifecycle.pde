/*
 * This sketch illustrates that the app isn't necessarily destroyed when losing focus.
 * The app may just be "paused" in the background, and global variables (such as "count") keep their data.
 *
 * Typically, pressing the "back" button on the phone will stop the app
 * (data stored in variables will be lost; and the setup function will be called again next time).
 * Other actions (home button, for instance) will typically just "pause" the app.
 * If other apps are used in the meantime, your app may be stopped by the Android system to free up memory.
 *
 * It also shows that "setup()" is only called if the app is started anew
 * (after being stopped and removed from memory by the Android OS).
 *
 * And it also shows that the app won't keep running the draw() function when it's paused/stopped 
 * (and that's why the value of "count" won't increase).
 *
 * The "life-cycle" of an Activity is described in:
 * https://developer.android.com/reference/android/app/Activity#ActivityLifecycle
 *
 * Tiago Martins 2017-2020
 * https://github.com/tms-martins/processing-androidExamples
 */

long count = 0;
 
void setup() {
  fullScreen();
  orientation(PORTRAIT);
  
  // set the text size and drawing parameters
  textSize(26 * displayDensity);
  textAlign(CENTER, CENTER);
  fill(0);
  noStroke();
  
  println("setup() count: " + count);
}

// draw is only called if the app is running in the foreground
void draw() {
  count++;
  
  background(255);
  text("Counting: " + count + "\nApp started " + nf(millis()/1000.0, 0, 2) + "\nseconds ago", 10, 10, width-20, height-20);
}

void resume() {
  println("resume() count: " + count);
}

void pause() {
  println("pause() count: " + count);
}
