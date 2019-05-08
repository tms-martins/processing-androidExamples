/*
 * This sketch illustrates using the motion sensors to draw a 2D object
 * attempting to keep the objects's orientation as the device is tilted sideways.
 * Tilting the device up/down also scales the image.
 *
 * The app uses data from the accelerometer. When stable, values from the accelerometer 
 * can reliably indicate the pull of gravity (and thus, the way down). 
 * When the device is being manipulated this method is less reliable.
 * This could also be done with the "roll" value of the orientation sensor - you are free to give it a try ;) 
 *
 * The wrapper classes for sensors of different types are in the file PASensor.java, 
 * which can easily be copied and used in another sketch.
 *
 * Tiago Martins 2017-2019
 * https://github.com/tms-martins/processing-androidExamples
 */


// object representing the accelerometer sensor
PASensorAccelerometer sensor;

// reference to the image to be displayed
PImage imageRolyPoly;

// rotation and scale of the displayed image
float objectAngle = 0;
float objectScale = 1;


void setup() {
  orientation(PORTRAIT);
  textFont(createFont("Monospaced", 18 * displayDensity));
  textAlign(LEFT, TOP);

  // load the image to display
  imageRolyPoly = loadImage("BB8.png");

  // initialize the sensor object
  sensor = new PASensorAccelerometer(this);
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
  background(#FAFFAD);
  
  // get the sensor values
  float accelX = sensor.getX();
  float accelY = sensor.getY();
  float accelZ = sensor.getZ();
  
  // estimate angle based on acceleration
  if (accelZ > -8 && accelZ < 8) {
    objectAngle = atan2(accelX, accelY);
  }
  
  // determine scale based on acceleration
  if (accelZ > -10) {
    objectScale = map(accelZ, -10, 10, 1.5, 0.5);
  }
  
  // move the scene's origin to the center; then rotate, scale, and draw the object
  
  pushMatrix();
  translate(width/2, height/2);
  rotate(objectAngle);
  scale(objectScale);
  image(imageRolyPoly, -imageRolyPoly.width/2, -imageRolyPoly.height/2);
  popMatrix();
  
  // Display a message with the acceleration values
  
  fill(0);
  String message = "";
  message += "X: " + nfp(accelX, 0, 2) + " m/s2\n";
  message += "Y: " + nfp(accelY, 0, 2) + " m/s2\n";
  message += "Z: " + nfp(accelZ, 0, 2) + " m/s2";
  text(message, 10 * displayDensity, 10 * displayDensity);
}
