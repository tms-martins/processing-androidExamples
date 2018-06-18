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
 * The permission CALL_PHONE has to be explicitly requested to the user, by displaying a prompt.
 *
 * Tiago Martins 2017/2018
 * https://github.com/tms-martins/processing-androidExamples
 */

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;


// string representing the permission to be requested
static final String permissionCallPhone = "android.permission.CALL_PHONE";

// Insert a valid phone number here 
String phoneNumber = "";

// these will allow us to prevent "spamming" phone calls
float minimumTimeBetweenCalls = 2000; // milliseconds 
float timeOfLastCall = 0;


void setup() {
  fullScreen();
  orientation(PORTRAIT);

  // set the text size and drawing parameters
  textSize(height/30);
  textAlign(CENTER, CENTER);
  fill(0);
  noStroke();
  
  // request the user's permission to make calls
  requestPermission(permissionCallPhone, "permissionCallPhoneGranted");
}


void permissionCallPhoneGranted(boolean granted) {
  println("permissionCallPhoneGranted(): " + granted);
}


void draw() {
  background(255);

  // calculate how much time has passed since the last call attempt
  float timeSinceLastCall = millis() - timeOfLastCall;

  // if not enough time has passed, tell the user to wait
  // otherwise prompt her/him to tap the screen
  if (timeSinceLastCall < minimumTimeBetweenCalls) {
    float timeRemaining = minimumTimeBetweenCalls - timeSinceLastCall;
    text("Please wait " + nf(timeRemaining, 1, 2) + " seconds", 10, 10, width-20, height-20);
  }
  else {
    text("Touch to make a call to\n" + phoneNumber, 10, 10, width-20, height-20);
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
  if (!hasPermission(permissionCallPhone)) {
    println("ERROR: no permission to make a call");
    return false;
  }
  
  try {
    Intent callIntent = new Intent(Intent.ACTION_CALL);
    callIntent.setData(Uri.parse("tel:" + number));
    startActivity(callIntent);
    return true;
  } 
  catch (Exception e) {
    println("ERROR: Call failed, system error message follows...");
    println(e.getMessage());
    return false;
  }
}