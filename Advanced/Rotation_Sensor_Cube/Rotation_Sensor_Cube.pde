/*
 * This sketch illustrates using the motion sensors to draw a texture cube (a die)
 * attempting to keep the cube's orientation as the device is turned.
 * You can examine all six faces by rotating the device around.
 *
 * The app uses the device's rotation vector sensor, which is wrapped up in class RotationSensor.
 * The sensor class and functions for drawing the textured cube are in separate tabs, 
 * so they can easily be copied onto another sketch.
 *
 * It would be great if the RotationSensor object (or the sketch's logic)
 * would seamlessly support portrait orientation. You are very welcome to add that!
 *
 * WARNING: Some (older) devices don't seem to support the lights() function. 
 * Try commenting out lights() if the app is crashing.
 *
 * Tiago Martins 2020
 * https://github.com/tms-martins/processing-androidExamples
 */

RotationSensor rotationSensor;

float values[];

void setup() {
  fullScreen(P3D);
  orientation(LANDSCAPE);
  
  // load all six images for the cube's faces
  loadCubeFaceImages();
  
  textSize(18 * displayDensity);
  textAlign(LEFT, CENTER);
  
  // initialize the rotation sensor, if necessary
  // (we check, just in case the app's resume() has been called before)
  if (rotationSensor == null) {
    rotationSensor = new RotationSensor();
    rotationSensor.resume();
  }
}

void draw() {
  background(255);
  fill(0);
  
  if (rotationSensor != null) {
    // compose and draw text for the orientation values
    String message = 
      "Azimuth: " + nf(rotationSensor.orientation[0], 0, 2) + "\n" +
      "Pitch: "   + nf(rotationSensor.orientation[1], 0, 2) + "\n" +
      "Roll: "    + nf(rotationSensor.orientation[2], 0, 2);
    text(message, 20, 20, width -40, height -40);
    
    // draw three arrows corresponding to the previous three values
    noStroke();
    fill(0);
    float spacing = height/4;
    float currX = width-150;
    float currY = spacing;
    for (int i = 0; i < 3; i++) {
      pushMatrix();
      translate(currX, currY);
      rotate(rotationSensor.orientation[i]);
      scale(10);
      arrow();
      popMatrix();
      currY += spacing;
    }
    
    lights();
    pushMatrix();
    
    // move the scene's origin to the center and 10 units away from the camera
    translate(width/2, height/2, 10);
    scale(min(width, height)/4);
    // perform the necessary rotations in an exact order
    rotateZ((rotationSensor.orientation[1]-PI));
    rotateX((rotationSensor.orientation[2]-HALF_PI));
    rotateY(rotationSensor.orientation[0]);
    // draw the cube
    drawTexturedCube();
    
    popMatrix();
  }
}

void resume() {
  println("resume()");
  if (rotationSensor == null) {
    rotationSensor = new RotationSensor();
  }
  rotationSensor.resume();
}

void pause() {
  println("pause()");
  if (rotationSensor != null) {
    rotationSensor.pause();
  }
}

// utility function to draw an arrow pointing up wards
// with a size of 5x10 pixels
void arrow() {
  beginShape();
  vertex( 0.0,  5.0);
  vertex( 2.5, -5.0);
  vertex( 0.0, -2.5);
  vertex(-2.5, -5.0);
  endShape(CLOSE);
}
