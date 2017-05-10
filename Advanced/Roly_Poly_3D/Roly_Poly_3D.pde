/*
 * This sketch illustrates using the motion sensors to draw a texture cube (a die)
 * attempting to keep the cube's orientation as the device is turned.
 * You can examine all six faces by rotating the device around.
 *
 * The app preferentially uses data calculated by the android system (combining accelerometer,
 * gyroscope and magnetometer data). If that isn't possible, it uses only the accelerometer,
 * in which case rotation around the vertical axis will have no effect.
 *
 * Functions for drawing the textured cube are in a separate tab, so they can easily be copied onto another sketch.
 *
 * WARNING: Some devices don't seem to support the lights() function. Try commenting out line 59 if the app is creashing.
 *
 * Tiago Martins 2017
 * https://github.com/tms-martins/processing-androidExamples
 */

import ketai.sensors.*;

// reference to the ketai library sensor
KetaiSensor sensor;

// stores the status and values of orientation
boolean hasOrientation  = false;
float orientX, orientY, orientZ;

// stores the status and values of acceleration
boolean hasAcceleration = false;
float accelX, accelY, accelZ;


void setup() {
  size(displayWidth, displayHeight, P3D);
  orientation(PORTRAIT);

  // load all six images for the cube's faces
  loadCubeFaceImages();

  // initialize the sensor object
  sensor = new KetaiSensor(this);
  sensor.start();

  // determine available sensors
  hasOrientation = sensor.isOrientationAvailable();
  hasAcceleration = sensor.isAccelerometerAvailable();

  // report on available sensors
  if (!hasOrientation) {
    println("No orientation data found, using accelerometer");
  }
  if (!hasAcceleration) {
    println("ERROR: No accelerometer found!");
  }
}


void draw() {
  background(0);
  lights();

  pushMatrix();
  // move the scene's origin to the center and 10 units away from the camera
  translate(width/2, height/2, 10);
  // rotate the scene depending on the sensor used
  if (hasOrientation) {
    rotateX(radians(-orientY) - HALF_PI);
    rotateY(radians(orientX+orientZ) - HALF_PI);
    rotateZ(radians(orientZ));
  } 
  else if (hasAcceleration) {
    rotateZ(atan2(accelX, accelY));
    rotateX(atan2(accelY, accelZ));
  }
  // scale the scene so the cube will take up some of the screen
  scale(width/4);
  // draw the cube
  drawTexturedCube();
  popMatrix();
}


// this function is called by the ketai sensor, on which we store sensor values
void onAccelerometerEvent(float x, float y, float z) {
  accelX = x;
  accelY = y;
  accelZ = z;
}


// this function is called by the ketai sensor, on which we store sensor values
void onOrientationEvent(float x, float y, float z) {
  orientX = x;
  orientY = y;
  orientZ = z;
}