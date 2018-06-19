/* 
 * This sketch illustrates receiving SMS messages within the app.
 *
 * For the receiver to register new messages, the app has to be in focus.
 * Received messages will still show up on the phone's SMS list (that is, they aren't hijacked by the app).
 * The SmsReceiver class is in a separate tab, so it can be easily copied to another sketch.
 * 
 * Code based on the example of receiving SMS from
 * http://mobdev.olin.edu/mobdevwiki/FrontPage/Tutorials/SMS%20Messaging
 * and registering a receiver from
 * http://stackoverflow.com/questions/4805269/programmatically-register-a-broadcast-receiver
 *
 * This sketch requires the permission RECEIVE_SMS.
 * The permission RECEIVE_SMS has to be explicitly requested to the user, by displaying a prompt.
 *
 * Tiago Martins 2017/2018
 * https://github.com/tms-martins/processing-androidExamples
 */


// string representing the permission to be requested
static final String permissionReceiveSMS = "android.permission.RECEIVE_SMS";

// reference to the receiver object
SmsReceiver smsReceiver;

// on-screen message
String screenText = "No messages received yet";


void setup() {
  fullScreen();
  orientation(PORTRAIT);
  
  // explicitly request permission to receive SMS
  requestPermission(permissionReceiveSMS);
  
  // initialize the receiver object
  println("SETUP: creating and registering receiver");
  smsReceiver = new SmsReceiver();
  smsReceiver.register();
  
  // set the text size and drawing parameters
  textSize(height/30);
  textAlign(CENTER, CENTER);
  fill(0);
  noStroke();
}


void draw() {
  // check if the receiver has a new message
  if (smsReceiver.hasNewMessage()) {
    
    // get the message and set the screen text    
    SmsMessage sms = smsReceiver.getNewMessage();
    screenText = "Message from:\n" + sms.getDisplayOriginatingAddress() + "\n\n" + sms.getDisplayMessageBody();
    screenText += "\n\n(tap the screen to clear)";
    
    // print a list of all messages so far to the console
    println("Messages Received so far:");
    ArrayList<SmsMessage> allMessages = smsReceiver.getAllMessages();
    for (SmsMessage message : allMessages) {
      println("From: " + message.getDisplayOriginatingAddress() + " Text: " + message.getDisplayMessageBody()); 
    } 
  }
  
  background(255);
  text(screenText, 10, 10, width-20, height-20);
}


void mousePressed() {
  // reset the screen text
  screenText = "Waiting for new messages...";
}


void resume() {
  // we check if the receiver is initialized (i.e., not null)
  // because resume() may be called before setup()
  if (smsReceiver != null) {
    println("RESUME: registering receiver");
    smsReceiver.register();
  }
}


void pause() {
  // we check if the receiver is initialized (i.e., not null) 
  // because pause() may be called before setup() (for instance, if you run it from processing and the phone's screen is off)
  if (smsReceiver != null) {
    println("PAUSE: un-registering receiver");
    smsReceiver.unregister();
  }
}