/* 
 * This sketch triggers the phone's vibrator when the screen is tapped.
 * 
 * It obtains Vibrator object as a system service, through getSystemService().
 * Once you have the object you can trigger vibration lasting for a span of time (in milliseconds) or use a specific pattern:
 *
 * vibrate(long milliseconds)           Turn the vibrator on.
 * vibrate(long[] pattern, int repeat)  Vibrate with a given pattern.
 * 
 * Documentation of the Vibrator class can be found at
 * http://developer.android.com/reference/android/os/Vibrator.html
 *
 * This sketch requires the permission VIBRATE.
 *
 * Tiago Martins 2017-2020
 * https://github.com/tms-martins/processing-androidExamples
 */

import android.content.Context;
import android.os.Vibrator;


// reference to the Vibrator object
Vibrator buzz;


void setup() {
  fullScreen();
  orientation(PORTRAIT);
  
  // obtain a Vibrator object by requesting it as a system service
  buzz = (Vibrator)getActivity().getSystemService(Context.VIBRATOR_SERVICE);
  
  // set the text size and drawing parameters
  textSize(24 * displayDensity);
  textAlign(CENTER, CENTER);
  noStroke();
  fill(255);
}

void draw() {
  background(0);
  text("Touch the screen\nto vibrate.", 0, 0, width, height); 
}

void mousePressed() {
  // calculate the duration depending on touch
  float durationMillis = map(mouseX, 0, width, 10, 700);
  println("Vibrating for " + (int)durationMillis + " milliseconds");  
  
  // This call is deprecated (i.e. it will stop existing in a future version of the Android SDK)
  // but this one still works, and allows older devices to be supported too.
  buzz.vibrate((long)durationMillis);
}
