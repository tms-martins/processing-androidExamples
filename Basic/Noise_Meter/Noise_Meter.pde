/*
 * This sketch uses a MediaRecorder object as a noise meter, diplaying amplitude numerically and also graphically (as a bar).
 *
 * The value obtained from the recorder is smoothed out by a simple method, so it decays slowly.
 * The recorder-related variables, objects and functions are in a separate tab, to make them easier to copy onto another sketch.
 *
 * NOTE: startRecorder() should be called from within resume() and stopRecorder() from within pause()
 *
 * Based on code from
 * http://androidexample.com/Detect_Noise_Or_Blow_Sound_-_Set_Sound_Frequency_Thersold/index.php?view=article_discription&aid=108&aaid=130
 *
 * This sketch requires the permission RECORD_AUDIO. 
 * The permission RECORD_AUDIO has to be explicitly requested to the user, by displaying a prompt.
 * This is already handled in the startRecorder() function - see the "Recorder" tab. 
 *
 * Tiago Martins 2017-2019
 * https://github.com/tms-martins/processing-androidExamples
 */
 

void setup() {
  fullScreen();
  orientation(PORTRAIT);
  
  noStroke();
  fill(0);
  textSize(height/20);
  textAlign(CENTER, CENTER);
}

// the recorder object should be checked for and initialized in resume,
// which is called when the app starts but also when its brought forth from a "paused" state
void resume() {
  println("resume... starting recorder");
  startRecorder();
}

// the recorder object should be stopped in pause,
// which is called when the app loses focus
void pause() {
  println("pause... stopping recorder");
  stopRecorder();
}

void draw() {
  updateRecorder();
  
  background(255);
  
  text("Smooth Amplitude:\n" + smoothAmplitude + "\n\nRough Amplitude:\n" + amplitude, width/2, height/2);
 
  // draw two bars to visualize the variation/decay of amplitude more easily,
  // one for the smooth-decaying value and another for the raw value
  
  float smoothBarSize = map (smoothAmplitude, 0, 32000, 0, width);
  float barSize = map (amplitude, 0, 32000, 0, width);
  
  noStroke();
  fill(150);
  
  rect(0, 0, smoothBarSize, 40);
  rect(0, 40, barSize, 40);
}
