/*
 * This sketch illustrates how to do very basic audio synthesis with Android. 
 *
 * It uses an AudioTrack object to play a sine wave, by writing directly to the object's audio buffer.
 * Since the buffer can be quite large, this process is quite slow on most phones.
 *
 * The tone is controlled by setting the "frequency" variable 
 * (in this case, during draw(), nased on the mouse's vertical position).
 *
 * Synth-related variables, objects and functions are in a separate tab "Synth" which can easily be copied to another sketch.
 *
 * Tiago Martins 2017
 * https://github.com/tms-martins/processing-androidExamples
 */
 
void setup() {
  size(displayWidth, displayHeight, P2D);
  orientation(PORTRAIT);
  
  setupTrack();
}

void draw() {
  frequency = map(mouseY, 0, height, 7000, 300);
  updateTrack();
}


void pause() {
  println("pause()");
  audioTrack.stop();
  super.pause();
}

void resume() {
  println("resume()");
  setupTrack();
  super.resume();
}

void stop() {
  println("stop()");
  super.stop();
}