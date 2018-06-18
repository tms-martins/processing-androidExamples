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
 * Tiago Martins 2017/2018
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
  
  // create a font and set the drawing parameters, which will be used during draw()
  textFont(createFont("Arial", height/30));
  textAlign(CENTER, CENTER);
  noStroke();
  fill(255);
}

void draw() {
  background(0);
  text("Touch the screen\nto vibrate.", 0, 0, width, height); 
}

void mousePressed() {
  // vibrate once, for a quarter of a second
  buzz.vibrate(250);
}