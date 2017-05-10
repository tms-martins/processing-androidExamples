/*
 * This sketch shows how to load an image from external storage, instead of the sketch's data folder.
 *
 * If your program uses a lot of images and/or big images, including them in the data folder will make the 
 * application bigger; it will take more time to install and changing the image implies re-compiling and re-installing.
 *
 * For this example make sure you have an image named "moon.png" inside a folder "Processing" in your phone's storage.
 * Since different users of an Android system have different emulated storage locations, files created while your
 * phone is mounted as media device may not be visible to the app, depending on their location.
 *
 * IMPORTANT: If the image isn't found, you may get an error message like:
 *   "File ... contains a path separator"
 * However this may be misleading, as path separators seem to work fine when the image is at the expected location.
 *
 * This sketch requires the permission WRITE_EXTERNAL_STORAGE
 *
 * Tiago Martins 2017
 * https://github.com/tms-martins/processing-androidExamples
 */
  
import android.os.Environment;
  
// strings used to compose the full filename, with path and name separate for convenience
String imagePath = "Processing/";
String imageName = "moon.png";

// the path to the phone's storage, which we will obtain via the Android system
String storagePath;

// reference for the loaded image
PImage img;


void setup() {
  size(displayWidth, displayHeight, P2D);
  orientation(PORTRAIT);
  
  // retrieve the path to the phone's storage root, via the Android system
  storagePath = Environment.getExternalStorageDirectory().getPath() + "/";
  println("External storage path:  " + storagePath);
  
  // try loading the image using the storage path, specified directory and filename
  try {
    img = loadImage(storagePath + imagePath + imageName);
  } catch (IllegalArgumentException e) {
    println("ERROR: Could not find file!");
    println(e.getMessage());
  }
  
  // set the text size and drawing parameters
  textSize(height/30);
  textAlign(CENTER, CENTER);
  imageMode(CENTER);
  fill(0);
  noStroke();
}

void draw() {
  background(255);
  
  // draw the image, if one was loaded; otherwise complain about it
  if (img != null) {
    image(img, width/2, height/2);
  }
  else {
    text("Could not find image: " + storagePath + imagePath + imageName, 0, 0, width, height);
  }
}