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
 * Tiago Martins 2017-2019
 * https://github.com/tms-martins/processing-androidExamples
 */


long count = 0; 

boolean isThreadCreated = false;


void setup() {
  orientation(PORTRAIT);
  
  // set the text size and drawing parameters
  textSize(height/30);
  textAlign(CENTER, CENTER);
  fill(0);
  noStroke();
  
  println("Processing setup() count: " + count);
}


// This function will be called by a thread, which runs in parallel and independently of the app being paused.
// WARNING: Do not use drawing functions in here.
void threadUpdate() {
  while (true) {
    count++;
    
    // let the thread sleep for 30 msec, so other threads can run
    // this may cause an exception, which must be caught
    try {
      Thread.sleep(30);
    } catch (Exception e) {
      println("Thread exception: " + e.getMessage());
    }
  }
}


// draw() is only called if the app is running in the foreground
void draw() {
  background(255);
  text("Counting: " + count + "\nApp started " + nf(millis()/1000.0, 0, 2) + " seconds ago", 10, 10, width-20, height-20);
}


void start() {
  println("start() count: " + count);
  
  // create the thread if it doesn't already exist
  if (!isThreadCreated) {
    println("creating thread");
    thread("threadUpdate");
    isThreadCreated = true;
  }
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
