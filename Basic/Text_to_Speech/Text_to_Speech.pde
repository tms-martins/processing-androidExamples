/*
 * This sketch illustrates text-to-speech (TTS, speech synthesis) on Android. 
 * Tap the screen when prompted and the TTS engine will say "Hello World". 
 * The voice's speed and pitch will change depending on the location of touch (vertical and horizontal, respectively).
 * 
 * Your phone should have the text-to-speech data for the relevant language installed.
 * Otherwise, the sketch will not work at all. Keep an eye on the console output.
 *
 * After calling setup() on an object of class PATextToSpeech, it can be used to
 * - speak a sentence, using speakNow()
 * - queue a sentence, using speakAdd()
 * - you can change the speed and pitch of the voice using setSpeed() and setPitch()
 * - you can check if something is being spoken with isSpeaking() and stop it with stopSpeaking()
 *
 * The PATextToSpeech object contains an android.speech.tts.TextToSpeech object:
 * http://developer.android.com/reference/android/speech/tts/TextToSpeech.html
 *
 * The TTS object PATextToSpeech is loosely based on the following tutorial:
 * https://www.tutorialspoint.com/android/android_text_to_speech.htm
 *
 * Tiago Martins 2017/2018
 * https://github.com/tms-martins/processing-androidExamples
 */

import android.content.Intent;


// Reference to the text-to-speech object, which is initialized in resume() and released in pause()
PATextToSpeech tts;


void setup() {
  fullScreen();
  orientation(PORTRAIT);
  
  // initialize the TTS object
  tts = new PATextToSpeech(this);
  tts.init();
  // You can set the language for speech synthesis
  // by providing an ISO 639 language code 
  // tts.init("de");
  
  // You can list available voices by calling
  // tts.listAvailableVoices();
  // ...and pick one voice from the list by it's index
  // tts.setVoiceByIndex(1);

  // set the text size and drawing parameters
  textSize(24 * displayDensity);
  textAlign(CENTER, CENTER);
  fill(0);
  noStroke();
}


void draw() {
  background(255);

  // display a message, depending on the current state of the TTS object

  String message = "Tap to make me talk";

  if (!tts.isReady()) {
    message = "initializing...";
  } else if (tts.isSpeaking()) {
    message = "busy...";
  }

  text(message, 20, 20, width-40, height-40);
}


void mousePressed() {
  if (tts.isSpeaking()) return;

  // say "hello world" when the screen is tapped, setting the pitch and speed 
  // according to mouseY and mouseX, respectively

  float pitch = map(mouseY, 0, height, 2, 0);
  tts.setPitch(pitch);

  float speed = map(mouseX, 0, width, 0, 2);
  tts.setSpeed(speed);

  tts.speakNow("Hello World");
}


void resume() {
  // we check if the TTS was constructed (i.e., not null)
  // because resume() may be called before setup()
  if (tts != null) {
    tts.init();
  }
}


void pause() {
  // we check if the TTS was constructed (i.e., not null) 
  // because pause() may be called before setup() 
  // (for instance, if you run it from processing and the phone's screen is off)
  if (tts != null) {  
    tts.release();
  }
}
