/*
 * This sketch illustrates how to find faces on a selfie camera. 
 *
 * It uses a KetaiFaceDetector object from the Ketai library.
 * It also flips the selfie-camera image so that it can be passed 
 * to the face detector in the correct orientation
 * and drawn in mirrored mode for the user.
 * 
 * We also make use of a letterboxing utility to make sure that the selfie
 * image fills up the screen.
 *
 * Finding faces in this way can be rather slow, so we only do it
 * every 500 milliseconds (1/2 second).
 * The Android camera does have an integrated face-finder, but this
 * isn't available via the Ketai library.
 *
 * This sketch requires the permission CAMERA.
 * The Ketai library will prompt the user to explicitly allow the app to use the camera.
 *
 * Tiago Martins 2020
 * https://github.com/tms-martins/processing-androidExamples
 */


import ketai.camera.*;
import ketai.cv.facedetector.*;

KetaiCamera cam;

KetaiSimpleFace[] faces = new KetaiSimpleFace[0];
final static int MAX_FACES = 5;

LetterboxParams letterboxParams;

PGraphics imageSelfie;
boolean isMirrored = true;

boolean doFindFaces = false;
float timeLastFind = 0;

//PImage imageHeart;


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
  
  letterboxParams = new LetterboxParams();
  
  //imageHeart = loadImage("heart.png");
}


void draw() {
  background(0);
  
  boolean isCamReady = (cam != null && cam.isStarted());
  
  if (millis() - timeLastFind > 500) {
    timeLastFind = millis();
    doFindFaces = true;
  }
  
  if (!isCamReady) {
    fill(255);
    text("Tap to start the camera", width/2, height/2);
  }
  else {
    flipCameraImage();
    
    if (doFindFaces) {
      doFindFaces = false;
      faces = KetaiFaceDetector.findFaces(imageSelfie, MAX_FACES);
    }
  
    pushMatrix();
    // Apply the letterbox transforms and draw the selfie image
    translate(letterboxParams.offsetX, letterboxParams.offsetY);
    scale(letterboxParams.scale);
    image(imageSelfie, 0, 0);
    // While the letterbox transforms are applied, draw the location and eye-distance of found faces 
    noFill();
    stroke(255, 0, 255);
    for (int i=0; i < faces.length; i++) {
      ellipse(faces[i].location.x, faces[i].location.y, faces[i].distance, faces[i].distance);
    }
    popMatrix();
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
    letterboxParams.calculate(imageSelfie.width, imageSelfie.height, width, height);
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


// Utility class which calculates and stores the parameters for letterboxing (offset and scale).
// Before drawing the letterboxed element, first translate and then scale the renderer
// using the parameters provided by the LetterboxParams object.
class LetterboxParams {
  float scale;
  float offsetX;
  float offsetY;
  
  LetterboxParams () {
  }
  
  LetterboxParams (float elementW, float elementH, float displayAreaW, float displayAreaH) {
    calculate(elementW, elementH, displayAreaW, displayAreaH);
  }
  
  void calculate (float elementW, float elementH, float displayAreaW, float displayAreaH) {
    float scaleX = displayAreaW / elementW;
    float scaleY = displayAreaH / elementH;
    scale = min(abs(scaleX), abs(scaleY));
    offsetX = (displayAreaW - (elementW * scale)) / 2.0;
    offsetY = (displayAreaH - (elementH * scale)) / 2.0;
  }
}
