/* 
 * Starting a phone call from within a Processing app on Android.
 * When the call is disconnected, the phone should return to the app.
 * There is a timer to avoid spamming.
 *
 * IMPORTANT: Don't forget to replace the "number" variable with an actual number. 
 *
 * Note: this code could benefit from knowing when the call is over; maybe something useful can be found here
 * http://stackoverflow.com/questions/3153815/how-can-my-android-app-detect-a-dropped-call
 *
 * Code based on the example of making a call from
 * http://forum.processing.org/topic/android-how-to-make-a-processing-telephone-call
 * 
 * This sketch requires the permission CALL_PHONE.
 *
 * Tiago Martins 2017
 * https://github.com/tms-martins/processing-androidExamples
 */

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;


// Insert a valid phone number here 
String phoneNumber = "";

// these will allow us to prevent "spamming" phone calls
float minimumTimeBetweenCalls = 2000; // milliseconds 
float timeOfLastCall = 0;


void setup() {
  fullScreen(P2D);
  orientation(PORTRAIT);
  requestPermission("android.permission.CALL_PHONE", "callRequest");

  // set the text size and drawing parameters
  textSize(displayDensity * 24);
  textAlign(CENTER, CENTER);
  fill(0);
  noStroke();
}


void draw() {
  background(255);

  // calculate how much time has passed since the last call attempt
  float timeSinceLastCall = millis() - timeOfLastCall;

  // if not enough time has passed, tell the user to wait
  // otherwise prompt her/him to tap the screen
  if (timeSinceLastCall < minimumTimeBetweenCalls) {
    float timeRemaining = minimumTimeBetweenCalls - timeSinceLastCall;
    text("Please wait " + nf(timeRemaining, 1, 2) + " seconds", 0, 0, width, height);
  }
  else {
    text("Touch to make a call to\n" + phoneNumber, 0, 0, width, height);
  }
}


void mousePressed() {
  // check if enough time passed since the last call, to avoid spamming
  float timeSinceLastCall = millis() - timeOfLastCall;

  if (timeSinceLastCall > minimumTimeBetweenCalls) {
    timeOfLastCall = millis();
    makeACallTo(phoneNumber);
  }
}


boolean makeACallTo(String number) {
  try {
    Intent callIntent = new Intent(Intent.ACTION_CALL);
    callIntent.setData(Uri.parse("tel:" + number));
    getContext().startActivity(callIntent);
    return true;
  } 
  catch (Exception e) {
    println("ERROR: Call failed, system error message follows...");
    println(e.getMessage());
    return false;
  }
}

void callRequest(boolean granted) {
  if (!granted) {
    println("Cannot make phone call, sorry");   
  }
}