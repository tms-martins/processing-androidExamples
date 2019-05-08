/*
 * This sketch shows how to use an included PAAudioPlayer class to load and play audio files from the sketch's data folder.
 *
 * - Load a file from the sketch's data folder using loadFile() (you have to pass "this" as first parameter)
 * - Play and replay the file from the start using play().
 * - To play other files (or the same file) at the same time, you need more PAAudioPlayer objects.
 * - Many other functions are inherited from class MediaPlayer:
 *   http://developer.android.com/reference/android/media/MediaPlayer.html
 *
 * Tiago Martins 2017-2019
 * https://github.com/tms-martins/processing-androidExamples
 */

PAAudioPlayer player;

void setup() {
  orientation(PORTRAIT);
  
  // set the text size and drawing parameters
  textSize(height/30);
  textAlign(CENTER, CENTER);
  fill(0);
  noStroke();
  
  // create the player object and load a file
  player = new PAAudioPlayer();
  player.loadFile(this, "Hello_World.wav");
}

void draw() {
  background(255);
  
  String message = "Tap to play";
  
  if (player.isPlaying())
    message = "Playing...";
  
  text(message, 10, 10, width-20, height-20);
}

void mousePressed() {
  player.play();
}
