import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.os.Bundle;
import android.speech.RecognizerIntent;
import java.util.ArrayList;
import java.util.Locale;

import processing.core.PApplet;

public class PASpeechToText {
  
  private int PASTT_INTENT_CODE = 0;
  private boolean bHasResults = false;
  private ArrayList<String> results; 
  private PApplet app;
  private Locale locale;
  private int maxResults = 10;

  public PASpeechToText(PApplet app) {
    this.app = app;
    results = new ArrayList();
    locale = Locale.getDefault();
    System.out.println("PASpeechToText: initialized with default language: " + locale.getDisplayLanguage());
  }
  
  // make sure to provide an ISO 639 two-letter language code
  public boolean setLanguage(String languageCode) {
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
      System.out.println("PASpeechToText: language set to: " + locale.getDisplayLanguage() + " (" + locale.toLanguageTag() + ")");
      return true;
    }
    else {
      System.out.println("ERROR PASpeechToText: the language code \"" + languageCode + "\" is unknown. Please refer to the list of ISO 639 language codes.");
      return false;
    }
  }
  
  public void setmaxResults(int maxResults) {
    if (maxResults > 0) {
      this.maxResults = maxResults;
    }
  }

  public void recognize() {
    this.recognize("Text To Speech Demo (" + locale.getDisplayLanguage() + ")");
  }

  public void recognize(String strMessage) {
    clearResults();
    PASTT_INTENT_CODE = (int)app.random(9999);
    System.out.println("PASpeechToText: launching speech recognition intent; language set to " + locale.getDisplayLanguage());
    Intent intent = new Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH);
    intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM);
    intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE, locale.toLanguageTag());
    intent.putExtra(RecognizerIntent.EXTRA_MAX_RESULTS, maxResults);
    intent.putExtra(RecognizerIntent.EXTRA_PROMPT, strMessage);
    app.getActivity().startActivityForResult(intent, PASTT_INTENT_CODE);
  }
  
  public boolean hasResults() {
    return bHasResults;
  }
  
  public void clearResults() {
    bHasResults = false;
    results.clear();
  }
  
  public ArrayList<String> getResults() {
    if (!bHasResults) return null;
    return results;
  }
  
  public String getFirstResult() {
    if (!bHasResults) return null;
    if (results.size() == 0) return "?";
    return (String)results.get(0);
  }

  public void onActivityResult(int requestCode, int resultCode, Intent data) {
    if (requestCode == PASTT_INTENT_CODE && resultCode == Activity.RESULT_OK) {
      System.out.println("PASpeechToText: activity result received");
      ArrayList<String> listResults = data.getStringArrayListExtra(RecognizerIntent.EXTRA_RESULTS);
      for (String s : listResults) {
        this.results.add(s);
      }
      bHasResults = true;
      System.out.println("PASpeechToText: got " + results.size() + " results");
    }
  }
}
