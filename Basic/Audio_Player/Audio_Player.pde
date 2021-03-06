/*
 * This sketch show how to use an included PAAudioPlayer class to load and play audio files.
 * Specifically, this example plays a file from the sketch's data folder (bundled as a resource when the app is installed on the phone)
 *
 * - Load a file: 
 *   - from the sketch's data folder using loadFile() (you have to pass "this" as first parameter)
 *   - from a path relative to the root of the SD card using loadFileSDCard()
 *   - from a complete path using loadFileFullPath()
 * - Play and replay the file from the start using play().
 * - To play other files (or the same file) at the same time, you need more PAAudioPlayer objects.
 * - Many other functions are inherited from class MediaPlayer:
 *   http://developer.android.com/reference/android/media/MediaPlayer.html
 *
 * The PAAudioPlayer makes use of the Android MediaPlayer object, which is better for playing long streams - e.g. audio tracks.
 * If you want to play several short sounds (for a UI, game or instrument) then a SoundPool might be e better choice.
 * 
 * If you are loading the audio file from external storage, then
 * this sketch requires the permission WRITE_EXTERNAL_STORAGE, which has to be explicitly requested with requestPermission()
 *
 * Tiago Martins 2017-2020
 * https://github.com/tms-martins/processing-androidExamples
 */

PAAudioPlayer player;

void setup() {
  fullScreen();
  orientation(PORTRAIT);
  
  // create the player object and load a file
  player = new PAAudioPlayer();
  player.loadFile(this, "Hello_World.wav");
  
  // ...or we can load them from a storage location (don't forget to check the permission WRITE_EXTERNAL_STORAGE)
  // player.loadFileSDCard("Processing/Hello_World.wav");
  // which is roughly equivalent to 
  // player.loadFileFullPath("/sdcard/Processing/Hello_World.wav");
}

void draw() {
  // nothing to do here
}

void mousePressed() {
  player.play();
}
