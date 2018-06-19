/*
 * This sketch illustrates when several functions of the Android Activity class are called. 
 * It also shows that the app won't keep running the draw() function when it's paused/stopped 
 * (and that's why the value of "count" won't increase).
 *
 * Typically, pressing the "back" button on the phone will stop the app
 * (data stored in variables will be lost; and the setup function will be called again next time).
 * Other actions (home button, for instance) will typically just "pause" the app.
 * If other apps are used in the meantime, your app may be stopped by the Android system to free up memory.
 *
 * The "life-cycle" of an Activity is described in:
 * http://developer.android.com/reference/android/app/Activity.html 
 *
 * Tiago Martins 2017/2018
 * https://github.com/tms-martins/processing-androidExamples
 */

long count = 0;
 
void setup() {
  fullScreen();
  orientation(PORTRAIT);
  
  // set the text size and drawing parameters
  textSize(height/30);
  textAlign(CENTER, CENTER);
  fill(0);
  noStroke();
  
  println("Processing setup() count: " + count);
}

// draw is only called if the app is running in the foreground
void draw() {
  count++;
  
  background(255);
  fill(0);
  text("Counting: " + count + "\nApp started " + nf(millis()/1000.0, 0, 2) + " seconds ago", 10, 10, width-20, height-20);
}

void start() {
  println("start() count: " + count);
}

void resume() {
  println("resume() count: " + count);
}

void pause() {
  println("pause() count: " + count);
}

void stop() {
  println("stop() count: " + count);
}