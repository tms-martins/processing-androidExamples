/*
 * This sketch plays increasingly persistent barking sounds until it detects a loud noise.
 *
 * A bar representing the "nervousness" increasingly fills the screen. After a third is filled
 * single barks will occasionally be played. After two-thirds of the screen are filled, multiple
 * barks will be played.
 *
 * A darker bar on the top of the screen indicates the loudness of the detected noise.
 * If a loud noise is detected, the "nervousness" is reset and a whining sound is played.
 *
 * Beware that as a result, the sketch may detect the loudness of its own sounds, and reset itself.
 * Turning the media volume down may suffice. You are, of course, encouraged to try other input methods 
 * or find creative solutions for the issue.
 *
 * This sketch requires the permissions RECORD_AUDIO and WAKE_LOCK.
 * The permission RECORD_AUDIO has to be explicitly requested to the user, by displaying a prompt.
 * This is already handled in the startRecorder() function - see the "Recorder" tab. 
 *
 * Tiago Martins 2017/2018
 * https://github.com/tms-martins/processing-androidExamples
 */


// There certainly are ways to avoid the repetition, especially if you want
// to have more than two different barks; but this one is used for simplicity's sake.
PAAudioPlayer player_bark_short_1;
PAAudioPlayer player_bark_short_2;
PAAudioPlayer player_bark_long_1;
PAAudioPlayer player_bark_long_2;
PAAudioPlayer player_whine_1;

float nervousness = 0;
float max_nervousness = 100;
float increase_nervousness = 0.1;


void setup() {
  fullScreen();
  orientation(PORTRAIT);
  frameRate(30);
  
  // create the audio player for each sound
  player_bark_short_1 = new PAAudioPlayer();
  player_bark_short_2 = new PAAudioPlayer();
  player_bark_long_1  = new PAAudioPlayer();
  player_bark_long_2  = new PAAudioPlayer();
  player_whine_1      = new PAAudioPlayer();
  
  // load the audio files
  player_bark_short_1.loadFile(this, "Dog_Bark_Short_01.mp3");
  player_bark_short_2.loadFile(this, "Dog_Bark_Short_02.mp3");
  player_bark_long_1.loadFile (this, "Dog_Bark_Long_01.mp3");
  player_bark_long_2.loadFile (this, "Dog_Bark_Long_02.mp3");
  player_whine_1.loadFile     (this, "Dog_Whine_01.mp3");
}


// the recorder object should be checked for and initialized in resume
// which is called when the app starts but also when its brought forth from a "paused" state
void resume() {
  println("resume... starting recorder");
  startRecorder();
  
  println("Wake-locking");
  WakeLock_lock(PowerManager.SCREEN_DIM_WAKE_LOCK);
}


void pause() {
  println("Wake-unlocking");
  WakeLock_unlock();
  
  println("pause... stopping recorder");
  stopRecorder();
}


void draw() {
  // this has to be called for the audio recorder to do its job properly
  updateRecorder();
  
  // increase and limit the nervousness
  nervousness += increase_nervousness;
  if (nervousness > max_nervousness) {
    nervousness = max_nervousness;
  }
  
  // these will help to decide if a barking sound is played, and which sound
  float chance_of_barking = random(100);
  float which_bark = random(100);
  
  // low nervousness means no barking
  if (nervousness < max_nervousness * 1/3) {
    // no barking
  }
  // middle nervousness means there is some chance of barking, and short barks
  else if (nervousness < max_nervousness * 2/3) {    
    if (chance_of_barking > 97) {
      if (which_bark < 50) {
        player_bark_short_1.play();
        println("Bark 1");
      }
      else {
        player_bark_short_2.play();
        println("Bark 2");
      }
    }
  }
  // high nervousness means a bigger chance of barking, and long barks
  else {
    if (chance_of_barking > 94) {
      if (which_bark < 50) {
        player_bark_long_1.play();
        println("Long 1");
      }
      else {
        player_bark_long_2.play();
        println("Long 2");
      }
    }
  }
  
  background(255);
  noStroke();
  
  // draw a bar for nervousness, taking up the screen's height and growing from left to right
  fill(200);
  float width_nervousness = map(nervousness, 0, max_nervousness, 0, width); 
  rect(0, 0, width_nervousness, height);
  
  // draw a bar to visualize the variation/decay of amplitude more easily
  float width_amplitude = map (smoothAmplitude, 0, 32000, 0, width);
  fill(150);
  rect(0, 0, width_amplitude, height/20);
  
  // draw the status/info text
  textAlign(CENTER, CENTER); 
  textSize(width/20);
  fill(0);
  String message = "Nervousness:\n" + (int)nervousness + "\nSmooth Amplitude:\n" + smoothAmplitude + "\nRough Amplitude:\n" + amplitude;
  text(message, width/2, height/2);
 
  // when a loud sound is detected, reset nervousness and play a whine
  if(smoothAmplitude > 18000 && nervousness > max_nervousness * 1/3) {
    nervousness = 0;
    player_whine_1.play();
  }
  
}