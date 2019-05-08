/*
 * This sketch plays increasingly persistent barking sounds until the device is tapped or moved.
 *
 * A bar representing the "nervousness" increasingly fills the screen. 
 * After a third of the screen is filled single barks will occasionally be played. 
 * After two-thirds of the screen are filled, multiple barks will be played.
 *
 * A darker bar on the top of the screen indicates the device's total acceleration.
 * If this total is far from the gravity acceleration (9.8 m/s2) the "nervousness" is reset and a whining sound is played.
 *
 * This sketch requires the permission WAKE_LOCK.
 *
 * Tiago Martins 2017-2019
 * https://github.com/tms-martins/processing-androidExamples
 */


// The object representing the sensor
PASensorAccelerometer sensor;

// There certainly are ways to avoid the repetition, especially if you want
// to have more than two different barks; but this one is used for simplicity's sake.
PAAudioPlayer soundBarkShort1;
PAAudioPlayer soundBarkShort2;
PAAudioPlayer soundBarkLong1;
PAAudioPlayer soundBarkLong2;
PAAudioPlayer soundWhine1;

boolean isBarking = false;
boolean isMotion  = false;

float nervousness = 0;
float maxNervousness = 100;
float increaseNervousness = 0.2;


void setup() {
  fullScreen();
  orientation(PORTRAIT);
  frameRate(30);
  
  // create and start the sensor
  // the sensor should also be started/stopped on resume/pause (see below)
  sensor = new PASensorAccelerometer(this);
  sensor.start();
  
  // create the audio player for each sound
  soundBarkShort1 = new PAAudioPlayer();
  soundBarkShort2 = new PAAudioPlayer();
  soundBarkLong1  = new PAAudioPlayer();
  soundBarkLong2  = new PAAudioPlayer();
  soundWhine1     = new PAAudioPlayer();
  
  // load the audio files
  soundBarkShort1.loadFile(this, "Dog_Bark_Short_01.mp3");
  soundBarkShort2.loadFile(this, "Dog_Bark_Short_02.mp3");
  soundBarkLong1.loadFile (this, "Dog_Bark_Long_01.mp3");
  soundBarkLong2.loadFile (this, "Dog_Bark_Long_02.mp3");
  soundWhine1.loadFile    (this, "Dog_Whine_01.mp3");
}


void resume() {
  println("Wake-locking");
  WakeLock_lock(PowerManager.SCREEN_DIM_WAKE_LOCK);
  
  if (sensor != null) sensor.start();
}


void pause() {
  println("Wake-unlocking");
  WakeLock_unlock();
  
  if (sensor != null) sensor.stop();
}


void draw() {
  // get the sensor values and calculate the total acceleration
  float accelX = sensor.getX();
  float accelY = sensor.getY();
  float accelZ = sensor.getZ();
  float accelTotal = sqrt((accelX*accelX) + (accelY*accelY) + (accelZ*accelZ)); 
  
  // check if there is significant motion
  if (accelTotal > 10.5 || accelTotal < 9.5) 
    isMotion = true;
  else 
    isMotion = false;
  
  // increase and limit the nervousness
  nervousness += increaseNervousness;
  if (nervousness > maxNervousness) {
    nervousness = maxNervousness;
  }
  
  // these will help to decide if a barking sound is played, and which sound
  float chanceOfBarking = random(100);
  float whichBark = random(100);
  
  // low nervousness means no barking
  if (nervousness < maxNervousness * 1/3) {
    // no barking
    isBarking = false;
  }
  // middle nervousness means there is some chance of barking, and short barks
  else if (nervousness < maxNervousness * 2/3) {
    isBarking = true;
    if (chanceOfBarking > 97) {
      if (whichBark < 50) {
        soundBarkShort1.play();
        println("Bark 1");
      }
      else {
        soundBarkShort2.play();
        println("Bark 2");
      }
    }
  }
  // high nervousness means a bigger chance of barking, and long barks
  else {
    isBarking = true;
    if (chanceOfBarking > 94) {
      if (whichBark < 50) {
        soundBarkLong1.play();
        println("Long 1");
      }
      else {
        soundBarkLong2.play();
        println("Long 2");
      }
    }
  }
    
  background(255);
  noStroke();
  
  // draw a bar for nervousness, taking up the screen's height and growing from left to right
  fill(200);
  float width_nervousness = map(nervousness, 0, maxNervousness, 0, width); 
  rect(0, 0, width_nervousness, height);
  
  // draw a bar to visualize the acceleration
  float width_accel = map (accelTotal, 0, 20, 0, width);
  fill(150);
  rect(0, 0, width_accel, height/20);
  
  // draw a vertical line over the acceleration bar, to visualize the total acceleration at rest
  // (i.e. 9.8 m/s2 corresponding to the gravity pull)
  float rest_line_x = map(9.8, 0, 20, 0, width);
  stroke(0);
  line(rest_line_x, 0, rest_line_x, height/20);
  
  // draw the status/info text
  textAlign(CENTER, CENTER); 
  textSize(width/20);
  fill(0);
  String message = "Nervousness:\n" + (int)nervousness + "\nTotal Accel:\n" + nf(accelTotal, 0, 2);
  text(message, width/2, height/2);
 
  // when motion is detected, if barking, reset nervousness and play a whine
  if(isMotion && isBarking) {
    nervousness = 0;
    soundWhine1.play();
  }
  
}
