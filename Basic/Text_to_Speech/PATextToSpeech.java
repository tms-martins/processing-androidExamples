import android.app.Activity;
import android.content.Context;
import android.speech.tts.TextToSpeech;
import android.speech.tts.TextToSpeech.OnInitListener;
import android.speech.tts.TextToSpeech.Engine;
import android.speech.tts.Voice;
import android.content.Intent;
import android.os.Bundle;
import java.util.Locale;
import java.util.Set;

import processing.core.PApplet;

public class PATextToSpeech implements TextToSpeech.OnInitListener {
  
  //int PATTS_INTENT_CODE = 0;
  boolean bInitializing = false;
  boolean bReady = false;
  Locale locale;
  TextToSpeech tts;
  PApplet app;
  boolean shouldListAvailableVoices = false;
  int newVoiceIndex = -1;
  
  
  PATextToSpeech(PApplet app) {
    this.app = app;
    locale = Locale.getDefault();
  }
  
  // make sure to provide an ISO 639 two-letter language code
  public void init(String languageCode) {
    if (tts != null || bInitializing) {
      System.out.println("Warning PATextToSpeech.init(): object is already initialized");
      return;
    }
    
    String [] languages = Locale.getISOLanguages();
    boolean isValidLanguageCode = false;
    
    for (String code : languages) {
      if (languageCode.equalsIgnoreCase(code)) {
        isValidLanguageCode = true;
        break;
      }
    }
    
    if (isValidLanguageCode) {
      Locale newLocale = new Locale(languageCode);
      this.locale = newLocale;
      System.out.println("PATextToSpeech: language set to: " + locale.getDisplayLanguage() + " (" + locale.toLanguageTag() + ")");
    }
    else {
      System.out.println("Warning PATextToSpeech: the language code \"" + languageCode + "\" is unknown. Please refer to the list of ISO 639 language codes.");
    }
    
    init();
  }
  
  public void init() {
    if (tts != null || bInitializing) {
      System.out.println("Warning PATextToSpeech.init(): object is already initialized");
      return;
    }
    
    System.out.println("PATextToSpeech: initializing");
    bInitializing = true;
    bReady = false;
    tts = new TextToSpeech(app.getActivity(), this);
    System.out.println("PASpeechToText: initialized for language: " + locale.getDisplayLanguage());
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
  
  public void listAvailableVoices() {
    System.out.println("PATextToSpeech.listAvailableVoices() ===================");
    if (!bReady) {
      shouldListAvailableVoices = true;
      return;
    }
    
    Set<Voice> availableVoices = tts.getVoices();
    int voiceIndex = 0;
    System.out.println("PASpeechToText: listing available voices (" + availableVoices.size() + ")");
    for (Voice voice : availableVoices) {
      System.out.println("[" + voiceIndex + "] " + voice.getLocale().getDisplayLanguage() + " \"" + voice.getName() + "\"");
      voiceIndex++;
    }
    shouldListAvailableVoices = false;
  }
  
  public void setVoiceByIndex(int index) {
    if (!bReady) {
      newVoiceIndex = index;
      return;
    }
    if (index < 0) {
      System.out.println("ERROR PASpeechToText.setVoiceByIndex(): invalid index for chosen voice " + index);
      return;
    }
    Set<Voice> availableVoices = tts.getVoices();
    if (index >= availableVoices.size()) {
      System.out.println("ERROR PASpeechToText.setVoiceByIndex(): invalid index for chosen voice " + index + " (there are only " + availableVoices.size() + " available voices)");
      return;
    }
    Object[] voicesArray = availableVoices.toArray(); 
    Voice chosenVoice = (Voice)voicesArray[index];
    System.out.println("PASpeechToText: setting voice [" + index + "] " + chosenVoice.getLocale().getDisplayLanguage() + " \"" + chosenVoice.getName() + "\""); 
    int result = tts.setVoice(chosenVoice);
    if (result != TextToSpeech.SUCCESS) {
      System.out.println("ERROR PASpeechToText.setVoiceByIndex(): could not set the selected voice (but I don't know exactly why)");
      return;
    }
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
      int result = tts.setLanguage(this.locale);
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
        if (shouldListAvailableVoices) {
          listAvailableVoices();
        }
        else {
          System.out.println("TOTALLY NOPE");
        }
        if (newVoiceIndex >= 0) {
          setVoiceByIndex(newVoiceIndex);
          newVoiceIndex = -1;
        }
      }
    } 
    else {
      System.out.println("PATextToSpeech ERROR: could not initialize TextToSpeech (status code " + status + ")");
    }
    bInitializing = false;
  }
}
