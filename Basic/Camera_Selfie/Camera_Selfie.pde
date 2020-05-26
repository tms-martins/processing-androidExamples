/*
 * This sketch illustrates how to use/display the selfie camera. 
 *
 * Since the Ketai library only gives us landscape camera previews,
 * we flip the camera image so that it can be drawn in the 
 * correct orientation (and mirrored) for the user.
 *
 * We also make use of a letterboxing utility to make sure that 
 * the selfie image fills up the screen.
 *
 * This sketch requires the permission CAMERA.
 * The Ketai library will prompt the user to explicitly allow the app to use the camera.
 *
 * Tiago Martins 2020
 * https://github.com/tms-martins/processing-androidExamples
 */


import ketai.camera.*;

KetaiCamera cam;

// A PGraphics object is like an off-screen canvas onto which we can draw to. 
// It can also be used anywhere like a PImage.
PGraphics imageSelfie;
boolean isMirrored = true;


void setup() {
  fullScreen();
  orientation(PORTRAIT);
  
  println("Display  size: " + displayWidth + "x" + displayHeight);
  println("Viewport size: " + width + "x" + height);
  println("Disp. density: " + displayDensity);

  // Let's ask for a camera with a low resolution
  // so that the sketch runs at a decent speed.
  cam = new KetaiCamera(this, 320, 240, 20);
  
  // Switch to the selfie camera
  if (cam.getNumberOfCameras() > 1) {
    int camId = (cam.getCameraID() + 1 ) % cam.getNumberOfCameras();
    println("Switching to camera: " + camId);
    cam.setCameraID(camId);
  }
  else {
    println("WARNING: there only seems to be one camera on this device");
  } 
  
  textAlign(CENTER, CENTER);
  textSize(displayDensity * 25);
}


void draw() {
  background(0);
  
  boolean isCamReady = (cam != null && cam.isStarted());
    
  if (isCamReady) {   
    // flip the camera image unto the imageSelfie object
    flipCameraImage();
    // draw the image, letterboxed to fill up the whole screen
    letterboxImage(imageSelfie, 0, 0, width, height);
    // ...otherwise you could also just draw it like this:
    // image(imageSelfie, 0, 0);
  }
  else {
    fill(255);
    text("Tap to start the camera", width/2, height/2);
  } 
}


// Pressing the mouse starts/stops the camera
void mousePressed() {
  if (!cam.isStarted()) {
    cam.start();
  }
  else {
    cam.stop();
  }
}


// Required by the Ketai library to update the camera preview
void onCameraPreviewEvent() {
  cam.read();
}


// Utility function to flip the camera image.
// The camera image is drawn onto an of-screen canvas (PGraphics object)
// using transforms to rotate, mirror and reposition the image accordingly. 
void flipCameraImage() {
  if (imageSelfie == null) {
    imageSelfie = createGraphics(cam.height, cam.width);
    println("Camera open as:    " + cam.width + "x" + cam.height);
    println("Canvas created as: " + imageSelfie.width + "x" + imageSelfie.height);
  }
  imageSelfie.beginDraw();
  imageSelfie.background(255, 0, 255);
  imageSelfie.pushMatrix();
  if (isMirrored) {
    imageSelfie.scale(-1, 1);
    imageSelfie.rotate(-HALF_PI);
    imageSelfie.translate(-cam.width, -cam.height);
  }
  else {
    imageSelfie.rotate(-HALF_PI);
    imageSelfie.translate(-cam.width, 0);
  }
  imageSelfie.image(cam, 0, 0);
  imageSelfie.popMatrix();
  imageSelfie.endDraw();
}


// Utility function to draw a letterboxed image - i.e. scaling the image
// to the desired area without changing its aspect ratio.
void letterboxImage(PImage img, float x, float y, float w, float h) {
  
  // calculate the scale and offset of the letterboxed image
  float scaleX = w / img.width;
  float scaleY = h / img.height;
  float letterboxScale = min(scaleX, scaleY);
  float letterboxOffsetX = (w - (img.width  * letterboxScale)) / 2.0;
  float letterboxOffsetY = (h - (img.height * letterboxScale)) / 2.0;
  
  // draw the letterboxed image  
  pushMatrix();
  translate(x + letterboxOffsetX, y + letterboxOffsetY);
  scale(letterboxScale);
  image(img, 0, 0);
  popMatrix();
}
