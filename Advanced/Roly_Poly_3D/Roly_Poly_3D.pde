/*
 * This sketch illustrates using the motion sensors to draw a texture cube (a die)
 * attempting to keep the cube's orientation as the device is turned.
 * You can examine all six faces by rotating the device around.
 *
 * The app preferentially uses data calculated by the android system (combining accelerometer,
 * gyroscope and magnetometer data). If that isn't possible, it uses only the accelerometer,
 * in which case rotation around the vertical axis will have no effect.
 *
 * The wrapper classes for sensors of different types are in the file PASensor.java, 
 * which can easily be copied and used in another sketch.
 *
 * Functions for drawing the textured cube are in a separate tab, so they can easily be copied onto another sketch.
 *
 * WARNING: Some devices don't seem to support the lights() function. Try commenting out line 76 if the app is crashing.
 *
 * Tiago Martins 2018-2019
 * https://github.com/tms-martins/processing-androidExamples
 */


// Objects representing the sensors we will be using
PASensorOrientation   orientation;
PASensorAccelerometer accelerometer;


void setup() {
  // select the P3D renderer
  fullScreen(P3D);
  orientation(PORTRAIT);

  // load all six images for the cube's faces
  loadCubeFaceImages();

  // create the sensor objects
  orientation   = new PASensorOrientation(this);
  accelerometer = new PASensorAccelerometer(this);

  // Check available sensors, and start the ones we use
  if (orientation.isSupported()) {
    println("Using 3D orientation.");
    orientation.start();
  }
  else if (accelerometer.isSupported()) {
    println("Using accelerometer; rotation around the vertical axis won't have any effect.");
    accelerometer.start();
  }
  else {
    println("No accelerometer found, this sketch won't work properly.");
  }
}


// when the app loses focus, stop the sensor
void pause() {
  println("pause()");
  if (orientation != null && orientation.isSupported()) 
    orientation.stop();
  else if (accelerometer != null && accelerometer.isSupported()) 
    accelerometer.stop();
}


// when the app regains focus, start the sensor
void resume() {
  println("resume()");
  if (orientation != null && orientation.isSupported()) 
    orientation.start();
  else if (accelerometer != null && accelerometer.isSupported()) 
    accelerometer.start();
}


void draw() {
  background(0);
  lights();        // sets default lighting, so the 3D objects (i.e. the cube) are lit and shaded

  pushMatrix();
  
  // move the scene's origin to the screen center, and 10 units away from the camera
  translate(width/2, height/2, 10);
  
  // rotate the scene depending on the sensor used
  if (orientation.isSupported()) {
    // we can get orientation angles in radians, as an array of floats (azimuth, pitch, roll) by calling getOrientationAngles() 
    float [] orientationAngles = orientation.getOrientationAngles();    
    float azimuth = orientationAngles[0]; // heading, direction 
    float pitch   = orientationAngles[1]; // pitch forward/backward
    float roll    = orientationAngles[2]; // roll sideways, left/right
    
    rotateY(-roll);
    rotateX(-pitch);
    rotateZ(-azimuth);
  }
  else {
    // use the acceleration components on the three axes to calculate a rotation angle (arc-tangent function)
    rotateZ(atan2(accelerometer.getX(), accelerometer.getY()));
    rotateX(atan2(accelerometer.getY(), accelerometer.getZ()));
  }
  
  // scale the scene so the cube will take up some of the screen
  scale(width/4);
  
  // draw the cube
  drawTexturedCube();
 
  popMatrix();
}
