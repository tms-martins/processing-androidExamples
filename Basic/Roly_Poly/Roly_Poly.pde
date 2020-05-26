/*
 * This sketch illustrates using the motion sensors to draw a 2D object
 * attempting to keep the objects's orientation as the device is tilted sideways.
 * Tilting the device up/down also scales the image.
 *
 * The app uses data from the accelerometer. When stable, values from the accelerometer 
 * can reliably indicate the pull of gravity (and thus, the way down). 
 * When the device is being manipulated this method is less reliable.
 *
 * Image source: pngimage.net "totoro png 3"
 * href="https://pngimage.net/totoro-png-3/
 *
 * Tiago Martins 2017-2020
 * https://github.com/tms-martins/processing-androidExamples
 */

import ketai.sensors.*;

// reference to the ketai library sensor
KetaiSensor sensor;

// stores the status and values of acceleration
boolean hasAccel = false;
float accelX, accelY, accelZ;

// reference to the image to be displayed
PImage imageRolyPoly;

// the anchor points for rotating the image, in pixels
int imageAnchorX;
int imageAnchorY;

// rotation and scale of the displayed image
float objectAngle = 0;
float objectScale = 1;


void setup() {
  fullScreen();
  orientation(PORTRAIT);

  // load the image to display
  imageRolyPoly = loadImage("totoro.png");
  
  // set the rotation's anchor points
  imageAnchorX = imageRolyPoly.width/2;
  imageAnchorY = 580;

  // initialize the ketai sensor object
  sensor = new KetaiSensor(this);
  sensor.start();
  
  // check if an accelerometer is available
  hasAccel = sensor.isAccelerometerAvailable();
  if (!hasAccel) {
    println("ERROR: no accelerometer available!");
  }
  
  // set the text size and drawing parameters
  textSize(height/30);
  textAlign(CENTER, CENTER);
  fill(0);
  noStroke();
}


void draw() {
  background(#7ebde1);
  
  // if there's no accelerometer just draw a warning text and return
  if (!hasAccel) {
    text("Accelerometer not found!", 0, 0, width, height);
    return;
  }
  
  // estimate angle based on acceleration
  if (accelZ > -8 && accelZ < 8) {
    objectAngle = atan2(accelX, accelY);
  }
  
  // determine scale based on acceleration
  if (accelZ > -10) {
    objectScale = map(accelZ, -10, 10, 1.5, 0.5);
  }
  
  // move the scene's origin to the center,
  // rotate and scale, and draw the object
  pushMatrix();
  translate(width/2, height/2);
  rotate(objectAngle);
  scale(objectScale);
  image(imageRolyPoly, -imageAnchorX, -imageAnchorY);
  popMatrix();
}


// this function is called by the ketai sensor, on which we store sensor values
void onAccelerometerEvent(float x, float y, float z)
{
  accelX = x;
  accelY = y;
  accelZ = z;
}
