/*
 * This sketch illustrates using the motion sensors to draw a texture cube (a die)
 * attempting to keep the cube's orientation as the device is turned.
 * You can examine all six faces by rotating the device around.
 *
 * The app preferentially uses data calculated by the android system (combining accelerometer,
 * gyroscope and magnetometer data). If that isn't possible, it uses only the accelerometer,
 * in which case rotation around the vertical axis will have no effect.
 *
 * There are better ways to obtain the device's rotation - e.g. "rotation vector" sensor.
 * These require matrix calculations with quaternions, but the Ketai library only gives us three values.
 *
 * Functions for drawing the textured cube are in a separate tab, so they can easily be copied onto another sketch.
 *
 * WARNING: Some (older) devices don't seem to support the lights() function. Try commenting out line 71 if the app is crashing.
 *
 * Tiago Martins 2017-2020
 * https://github.com/tms-martins/processing-androidExamples
 */

import ketai.sensors.*;

// reference to the ketai library sensor
KetaiSensor sensor;

// stores the status and values of orientation
boolean hasOrientation  = false;
float orientX, orientY, orientZ;

// stores the status and values of rotation
boolean hasRotation  = false;
float rotX, rotY, rotZ;

// stores the status and values of acceleration
boolean hasAcceleration = false;
float accelX, accelY, accelZ;


void setup() {
  // select the P3D renderer
  fullScreen(P3D);
  orientation(PORTRAIT);

  // load all six images for the cube's faces
  loadCubeFaceImages();

  // initialize the sensor object
  sensor = new KetaiSensor(this);
  sensor.start();

  // determine available sensors
  hasOrientation  = sensor.isOrientationAvailable();
  hasRotation = sensor.isOrientationAvailable();
  hasAcceleration = sensor.isAccelerometerAvailable();

  // report on available sensors
  if (!hasOrientation) {
    println("No orientation data found, using rotation");
  }
  else if (!hasRotation) {
    println("No rotation data found, using accelerometer");
  }
  else if (!hasAcceleration) {
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
  else if (hasRotation) {
    rotateX(radians(-rotY) - HALF_PI);
    rotateY(radians(rotX+rotZ) - HALF_PI);
    rotateZ(radians(rotZ));
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
void onOrientationEvent(float x, float y, float z) {
  orientX = x;
  orientY = y;
  orientZ = z;
}


// this function is called by the ketai sensor, on which we store sensor values
void onRotationVectorEvent(float x, float y, float z) { // ?
  rotX = x;
  rotY = y;
  rotZ = z;
}


// this function is called by the ketai sensor, on which we store sensor values
void onAccelerometerEvent(float x, float y, float z) {
  accelX = x;
  accelY = y;
  accelZ = z;
}
