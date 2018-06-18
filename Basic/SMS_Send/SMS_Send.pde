/*
 * This sketch illustrates sending SMS messages from within an Android/Processing app.
 * There is a timer to avoid spamming.
 *
 * IMPORTANT: Don't forget to replace the "number" variable with an actual number. 
 *
 * Based on the code for sending SMS from
 * http://forum.processing.org/topic/is-access-to-sms-available
 *
 * This sketch requires the permissions SEND_SMS and READ_PHONE_STATE.
 * The permissions SEND_SMS and READ_PHONE_STATE have to be explicitly requested to the user, by displaying a prompt.
 *
 * Tiago Martins 2017/2018
 * https://github.com/tms-martins/processing-androidExamples
 */

import android.telephony.SmsManager;
import java.util.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;


// strings representing the permissions to be requested
static final String permissionSendSMS        = "android.permission.SEND_SMS";
static final String permissionReadPhoneState = "android.permission.READ_PHONE_STATE";

// Insert a valid phone number here
String phoneNumber = ""; 

// The message content, to which a date/time will be appended before sending
String messageText = "Hello World! This SMS was sent through Processing for Android";

// these will allow us to prevent "spamming" messages
float minimumTimeBetweenSms = 3000; // milliseconds 
float timeOfLastSms = 0;


void setup() {
  fullScreen();
  orientation(PORTRAIT);

  // set the text size and drawing parameters
  textSize(height/30);
  textAlign(CENTER, CENTER);
  fill(0);
  noStroke();
  
  // request permissions explicitly
  requestPermission(permissionSendSMS, "permissionSendSMSGranted");
  requestPermission(permissionReadPhoneState, "permissionReadPhoneStateGranted");
}


void permissionSendSMSGranted(boolean granted) {
  println("permissionSendSMSGranted(): " + granted);
}

void permissionReadPhoneStateGranted(boolean granted) {
  println("permissionReadPhoneStateGranted(): " + granted);
}


void draw() {
  background(255);
  
  // calculate how much time has passed since the last SMS was sent
  float timeSinceLastSms = millis() - timeOfLastSms;
  
  // if not enough time has passed, tell the user to wait
  // otherwise prompt her/him to tap the screen
  if (timeSinceLastSms < minimumTimeBetweenSms) {
    float timeRemaining = minimumTimeBetweenSms - timeSinceLastSms;
    text("Please wait " + nf(timeRemaining, 1, 2) + " seconds", 0, 0, width, height); 
  }
  else {
    text("Touch to send an SMS to\n" + phoneNumber, 0, 0, width, height);
  }  
}


void mousePressed() {
  // check if enough time passed since the last SMS, to avoid spamming
  float timeSinceLastSms = millis() - timeOfLastSms;
  
  if (timeSinceLastSms > minimumTimeBetweenSms) {
    timeOfLastSms = millis();
    
    // compose a message including the time and date
    DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
    Date date = new Date();
    String messageDate = dateFormat.format(date);
    String message = messageText + " on " + messageDate;
    
    // send the message using the SmsManager class
    println("Sending message <" + messageText + "> to " + phoneNumber);
    SmsManager.getDefault().sendTextMessage(phoneNumber, null, message, null, null);
  }
}