/*
 * This sketch draws a 3D compass arrow which always points North.
 *
 * The compass arrow is rotated depending on the device's orientation in 3D space, based on sensor data.
 * Orientation is obtained via a PASensorOrientation object, which is based on Android's rotation vector.
 * This is typically not a single sensor but rather a combination of data from available sensors on the device. 
 * 
 * Tiago Martins 2019
 * https://github.com/tms-martins/processing-androidExamples
 */


// The object representing the sensor
PASensorOrientation sensor;


void setup() {
  // We will be drawing in 3D, so we need to set the renderer (default is 2D)
  fullScreen(P3D);
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
  lights();        // sets default lighting, so the 3D objects (i.e. the arrow) are lit and shaded
  
  // we can get orientation angles in radians, as an array of floats (azimuth, pitch, roll) by calling getOrientationAngles() 
  float [] orientationAngles = sensor.getOrientationAngles();
  
  float azimuth = orientationAngles[0]; // heading, direction 
  float pitch   = orientationAngles[1]; // pitch forward/backward
  float roll    = orientationAngles[2]; // roll sideways, left/right
  
  // Draw an arrow, rotated according to the device's orientation
  
  fill(255);
  noStroke();  
  pushMatrix();
  translate(width/2, height/2);
  // order of rotation is important
  // in openGL we usually have to think "backwards"
  rotateY(-roll);
  rotateX(-pitch);
  rotateZ(-azimuth);
  drawArrow3D(min(width, height)/3);  
  popMatrix();
  
  // Display the azimuth, pitch and roll as a text
  
  fill(255);
  String message = "";
  message += "Azimuth " + nfp(azimuth, 0, 2) + " rad\n";
  message += "Pitch   " + nfp(pitch,   0, 2) + " rad\n";
  message += "Roll    " + nfp(roll,    0, 2) + " rad";
  text(message, 10 * displayDensity, 10 * displayDensity);
}


// Utility function to draw a 3D compass arrow
void drawArrow3D(float size) {
  float thickness = size/10.0;
  float half_size = size/2.0;
  
  beginShape();
  vertex(         0,     -size, 0);
  vertex( half_size,      size, 0);
  vertex(         0, half_size, 0);
  vertex(-half_size,      size, 0);
  endShape(CLOSE);
  
  beginShape(QUAD_STRIP);
  vertex(         0,     -size,          0);
  vertex(         0,     -size, -thickness);
  vertex( half_size,      size,          0);
  vertex( half_size,      size, -thickness);
  vertex(         0, half_size,          0);
  vertex(         0, half_size, -thickness);
  vertex(-half_size,      size,          0);
  vertex(-half_size,      size, -thickness);
  vertex(         0,     -size,          0);
  vertex(         0,     -size, -thickness);
  endShape();
  
  beginShape();
  vertex(         0,     -size, -thickness);
  vertex( half_size,      size, -thickness);
  vertex(         0, half_size, -thickness);
  vertex(-half_size,      size, -thickness);
  endShape(CLOSE);
}
