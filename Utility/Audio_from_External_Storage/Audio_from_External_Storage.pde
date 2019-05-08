/*
 * This sketch shows how to use an included PAAudioPlayer class to load and play audio files from external storage.
 *
 * If your program uses a lot of sounds and/or big sound files, including them in the data folder will make the 
 * application bigger. It will take more time to install; and changing the sounds implies re-compiling and re-installing.
 *
 * - Load a sound from a folder in the external storage using loadFileSDCard()
 * - Play and replay the file from the start using play().
 * - To play other files (or the same file) at the same time, you need more PAAudioPlayer objects.
 * - Many other functions are inherited from class MediaPlayer:
 *   http://developer.android.com/reference/android/media/MediaPlayer.html
 *
 * For this example to work, make sure you have a sound file named "Hello_World.wav" inside a folder "Processing" in your phone's storage.
 * These can be found inside this sketch's folder.
 * Since different users of an Android system have different emulated storage locations, files created while your
 * phone is mounted as media device may not be visible to the app, depending on their location.
 * This sketch requires the permission WRITE_EXTERNAL_STORAGE, which has to be explicitly requested with requestPermission()
 *
 * Tiago Martins 2017-2019
 * https://github.com/tms-martins/processing-androidExamples
 */
 
// the permission to be explicitly requested
final static String permissionWriteStorage = "android.permission.WRITE_EXTERNAL_STORAGE";

PAAudioPlayer player;

void setup() {
  orientation(PORTRAIT);
  
  // set the text size and drawing parameters
  textSize(height/30);
  textAlign(CENTER, CENTER);
  fill(0);
  noStroke();
  
  // create the player object
  player = new PAAudioPlayer();

  // request external storage permission and then load the audio file 
  requestPermission(permissionWriteStorage, "loadAudioFromStorage");
}

void loadAudioFromStorage(boolean permissionGranted) {
  if (!permissionGranted) {
    println("ERROR: you must grant the app permission to access external storage.");
    return;
  }
  
  player.loadFileFromStorage("Processing/Hello_World.wav");
}

void draw() {
  background(255);
  
  String message = "Tap to play";
  
  if (player.isPlaying())
    message = "Playing...";
  else if (!player.isLoaded)
    message = "No audio loaded";
  
  text(message, 10, 10, width-20, height-20);
}

void mousePressed() {
  player.play();
}
