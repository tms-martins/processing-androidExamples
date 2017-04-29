import android.app.Activity;
import android.content.Context;
import android.speech.tts.TextToSpeech;
import android.speech.tts.TextToSpeech.OnInitListener;
import android.speech.tts.TextToSpeech.Engine;
import android.content.Intent;
import android.os.Bundle;
import java.util.Locale;

import processing.core.PApplet;

public class PATextToSpeech implements TextToSpeech.OnInitListener {
  
  //int PATTS_INTENT_CODE = 0;
  boolean bInitializing = false;
  boolean bReady = false;
  Locale language;
  TextToSpeech tts;
  PApplet app;
  
  
  PATextToSpeech(PApplet app) {
    this.app = app;
    language = Locale.ENGLISH;
  }
  
  PATextToSpeech(PApplet app, Locale language) {
    this.app = app;
    this.language = language;
  }
  
  public void init() {
    if (tts != null || bInitializing) return;
    
    System.out.println("PATextToSpeech: initializing");
    bInitializing = true;
    bReady = false;
    tts = new TextToSpeech(app.getActivity(), this);
  }
  
  public void release() {
    System.out.println("PATextToSpeech: shutting down");
    bReady = false;
    tts.stop();
    tts.shutdown();
    tts = null;
  }
  
  public boolean isInitializing() {
    return bInitializing;
  }
  
  public boolean isReady() {
    return bReady;
  }
  
  public int setPitch(float pitch) {
    return tts.setPitch(pitch);
  }
  
  public int setSpeed(float speed) {
    return tts.setSpeechRate(speed);
  }
  
  public boolean isSpeaking() {
    return tts.isSpeaking();
  }
  
  public int stopSpeaking() {
    if (bReady) return tts.stop();
    return -1;
  }
  
  public int speakNow(String strText) {
    return speak(strText, TextToSpeech.QUEUE_FLUSH);
  }
  
  public int speakAdd(String strText) {
    return speak(strText, TextToSpeech.QUEUE_ADD);
  }
  
  public int speak(String strText, int queueMode) {
    if (!bReady) {
      System.out.println("PATextToSpeech: not ready yet.");
      return -1;
    }
    int result = this.tts.speak(strText, queueMode, null);
    return result;
  }
  
  public void onInit(int status) {
    System.out.println("PATextToSpeech: onInit() event; status is " + status);
    if (status == TextToSpeech.SUCCESS) {
      int result = tts.setLanguage(this.language);
      if (result == TextToSpeech.LANG_MISSING_DATA) {
        System.out.println("PATextToSpeech ERROR: TextToSpeech.LANG_MISSING_DATA");
        System.out.println("You should probably check if your phone has a text-to-speech package installed for the language you are trying to use");
      }
      else if (result == TextToSpeech.LANG_NOT_SUPPORTED) {
        System.out.println("PATextToSpeech ERROR: TextToSpeech.LANG_NOT_SUPPORTED");
        System.out.println("It appears that your text-to-speech package (on device) does not support the language you are trying to use");
      } 
      else {
        bReady = true;
        System.out.println("PATextToSpeech: ready");
      }
    } 
    else {
      System.out.println("PATextToSpeech ERROR: could not initialize TextToSpeech (status code " + status + ")");
    }
    bInitializing = false;
  }
}