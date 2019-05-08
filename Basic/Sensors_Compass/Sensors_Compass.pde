/*
 * This sketch draws a compass arrow which always points North.
 *
 * The compass arrow is rotated depending on the device's orientation, based on sensor data.
 * Orientation is obtained via a PASensorOrientation object, which is based on Android's rotation vector.
 * This is typically not a single sensor but rather a combination of data from available sensors on the device. 
 * 
 * Tiago Martins 2019
 * https://github.com/tms-martins/processing-androidExamples
 */


// The object representing the sensor
PASensorOrientation sensor;


void setup() {
  orientation(PORTRAIT);
  textFont(createFont("Monospaced", 18 * displayDensity));
  textAlign(LEFT, TOP);

  // create and start the sensor
  // the sensor should also be started/stopped on resume/pause (see below)
  sensor = new PASensorOrientation(this);
  sensor.start();
}


// when the app loses focus, stop the sensor
void pause() {
  println("pause()");
  if (sensor != null) sensor.stop();
}


// when the app regains focus, start the sensor
void resume() {
  println("resume()");
  if (sensor != null) sensor.start();
}


void draw() {
  background(0);
  
  // we can get orientation angles in radians, as an array of floats (azimuth, pitch, roll) by calling getOrientationAngles() 
  float [] orientationAngles = sensor.getOrientationAngles();
  
  float azimuth = orientationAngles[0]; // heading, direction 
  float pitch   = orientationAngles[1]; // pitch forward/backward
  float roll    = orientationAngles[2]; // roll sideways, left/right
  
  // Draw an arrow, rotated according to the device's azimuth
  
  fill(#8EFFE2);
  noStroke();  
  pushMatrix();
  translate(width/2, height/2);
  rotate(-azimuth);
  drawArrow(min(width, height)/2);  
  popMatrix();
  
  // Display the azimuth, pitch and roll as a text 
  
  fill(255);
  String message = "";
  message += "Azimuth " + nfp(azimuth, 0, 2) + " rad\n";
  message += "Pitch   " + nfp(pitch,   0, 2) + " rad\n";
  message += "Roll    " + nfp(roll,    0, 2) + " rad";
  text(message, 10 * displayDensity, 10 * displayDensity);
}


// Utility function to draw a 2D compass arrow
void drawArrow(float size) {
  beginShape();
  vertex(0, -size);
  vertex(size/2, size);
  vertex(0, size/2);
  vertex(-size/2, size);
  endShape(CLOSE);
}
