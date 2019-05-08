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
 * Note that this is very "hacky" and slow, although it could be useful to sonify sensor data.
 *
 * Tiago Martins 2017-2019
 * https://github.com/tms-martins/processing-androidExamples
 */
 
void setup() {
  orientation(PORTRAIT);
  
  setupTrack();
}

void draw() {
  frequency = map(mouseY, 0, height, 7000, 300);
  updateTrack();
}


void pause() {
  println("pause()");
  
  // it can be the case that pause() is called before setup() or resume()
  // so we should check if the audioTrack object has been initialized 
  if (audioTrack != null)
    audioTrack.stop();
}

void resume() {
  println("resume()");
  setupTrack();
}

void stop() {
  println("stop()");
  super.stop();
}
