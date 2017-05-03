/*
 * This sketch illustrates when several functions of the Activity super class are called. 
 * Additionally, this sketch uses a thread which keeps running and updating "count" even
 * when the app is "paused" (in which case the draw() function isn't being called).
 * 
 * Typically, pressing the "back" button on the phone will stop the app
 * (data stored in variables will be lost; and the setup function will be called again next time).
 * Other actions (home button, for instance) will typically just "pause" the app.
 * If other apps are used in the meantime, your app may be stopped by the Android system to free up memory.
 *
 * The "life-cycle" of an Activity is described in:
 * http://developer.android.com/reference/android/app/Activity.html 
 *
 * Tiago Martins 2017
 * https://github.com/tms-martins/processing-androidExamples
 */


UpdateThread updateThread;
long count = 0; 


void setup() {
  fullScreen(P2D);
  orientation(PORTRAIT);
  
  
  // set the text size and drawing parameters
  textSize(displayDensity * 30);
  textAlign(CENTER, CENTER);
  fill(0);
  noStroke();
  
  println("Processing setup() count: " + count);
}


// This function will be called by the thread, which runs in parallel and independently of the app being paused.
// WARNING: Do not use drawing functions in here, only data-processing stuff.
void update() {
  count++;  
}


// draw() is only called if the app is running in the foreground
void draw() {
  background(255);
  text("Counting: " + count + "\nApp started " + nf(millis()/1000.0, 0, 2) + " seconds ago", 0, 0, width, height);
}


void onStart() {
  super.onStart();
  // check if the thread object exists; if not, create one and start it
  if (updateThread == null) {
    updateThread = new UpdateThread();
    updateThread.start();
  }
  println("onStart() count: " + count);
}


void onResume() {
  super.onResume();
  println("onResume() count: " + count);
}


void onPause() {
  super.onPause();
  println("onPause() count: " + count);
}


void onStop() {
  println("onStop() count: " + count);
  super.onStop(); 
}