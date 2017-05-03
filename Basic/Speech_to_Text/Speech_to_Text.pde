/*
 * This sketch illustrates speech-to-text (speech recognition) on Android. 
 * Tap the screen, and you will be prompted by the Android system for speech recognition.
 * The top result is then displayed on the screen.
 *
 * IMPORTANT: to run this sketch properly, you need a network connection, 
 * because the speech recognition is done by Google's servers.
 * 
 * After creating an object of class PASpeechToText you may call the method recognize(). 
 * This will launch the phone's recognizer, which will prompt you to speak.
 * When the phone's recognizer is done, it will return one (ore more) results to the
 * PASpeechToText object. You should poll the object by calling hasResults(), and then
 * obtain either the first result or the whole list. 
 * You should then call clearResults() on the object so that it will return false
 * the next time you poll it.
 *
 * You also need to listen for and pass "activity requests" to the STT object.
 * See the function onActivityResult(...) below.
 *
 * Tiago Martins 2017
 * https://github.com/tms-martins/processing-androidExamples
 */
 
PASpeechToText stt;

String result = "tap the screen to start";


// this is (for now at least) necessary to pass the results of 
// an activity request back to the PASpeechToText object
void onActivityResult(int requestCode, int resultCode, android.content.Intent data) {
  stt.onActivityResult(requestCode, resultCode, data);
}


void setup() {
  fullScreen(P2D);
  orientation(PORTRAIT);
  
  // initialize the STT object
  stt = new PASpeechToText(this);
  
  // set the text size and drawing parameters
  textSize(displayDensity * 24);
  textAlign(CENTER, CENTER);
  fill(0);
  noStroke();
}


void draw() {
  // check for speech recognition results and store the first result 
  if (stt.hasResults()) {
    result = stt.getFirstResult();
    
    // you can also get all the results as an ArrayList
    // in this case, we will print them to the console
    ArrayList<String> allResults = stt.getResults();
    for (String oneResult : allResults) {
      println(oneResult);
    }
    
    // we are done for now, so we clear the results
    stt.clearResults();
  }
  
  background(255);
  text(result, 0, 0, width, height);
}


void mousePressed() {
  stt.recognize();
  // you can also call recognize(String message);
  // this will display the message in the speech recognition prompt
}