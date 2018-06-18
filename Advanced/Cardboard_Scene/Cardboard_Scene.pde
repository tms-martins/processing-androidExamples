/*
 * Renders a 3D scene in stereo (two viewports) and controls the camera using the phone's sensors.
 * This is meant for Cardboard goggles, but you can still use it in wihout: just set STEREO_RENDER to false.
 *
 * The sketch will work better with a gyroscope-enabled device.
 * If it doesn't find a gyro, it will use the accelerometer and compass instead (it smooths the values first).
 * When using the compass, you should tap the screen to center the view.
 * The compass code isn't complete (it needs to handle abrupt transitions from 0 to 360 degress).
 * Also some devices do not have a compass, so you will only be able to look up and down.
 *
 * Draw your 3D scene within drawScene() and make sure to use the PGraphics object passed as parameter,
 * so that your scene will be rendered to the twin 3D viewports.
 *
 * Based on code from
 * http://www.scottlittle.org/?p=46
 * Scott Little 2015, GPLv3
 *
 * This sketch requires the permission WAKE_LOCK 
 *
 * Tiago Martins 2017/2018
 * https://github.com/tms-martins/processing-androidExamples
 */


//import android.os.Bundle;
//import android.view.WindowManager;
import ketai.sensors.*; 

boolean showDebugText = true;
boolean gyroAvailable = false;

KetaiSensor sensor;

float gyroX;
float gyroY;
float gyroZ; 

float accelX;
float accelY;
float accelZ;

float orientX;
float orientY;
float orientZ;

float centerOrientX = 0;


void setup() {
  fullScreen(P3D);                          //used to set P3D renderer
  orientation(LANDSCAPE);                   //on some devices, causes crashing if not started in this orientation (why?)
  
  sensor = new KetaiSensor(this);
  sensor.start();
  gyroAvailable = sensor.isGyroscopeAvailable();

  setupViewports();  
  setupScene();
}

void draw() {
  updateCameraPosition();
  drawViewports();

  if (!gyroAvailable && showDebugText) {
    fill(0);
    textSize(width/30);
    textAlign(LEFT, TOP);
    String message = "Accel " + nf(accelX, 0, 2) + " " + nf(accelY, 0, 2) + " " + nf(accelZ, 0, 2) + "   ";
    message += "Orien " + (int)orientX + " " + (int)orientY + " " + (int)orientZ + "\n";
    message += "Avg AccelZ " + nf(averageAccelZ, 0, 2) + "  Avg OrientX " + (int)averageOrientX + "  center " + (int)centerOrientX + "\n";
    text(message, 20, 20);
  }
}


// DRAW YOUR STUFF HERE!
void drawScene(PGraphics g) {  
  drawAxes(g);
  drawObjects(g);
}

void updateCameraPosition() {
  if (gyroAvailable) {
    panX = panX - (gyroX*10);
    panY = panY + (gyroY*10);
  } else {
    updateOrientXAverage();
    updateAccelZAverage();
    panX = (averageOrientX-180-centerOrientX) * 15;
    panY = averageAccelZ * 35;
  }
}

void mousePressed() {
  if (!gyroAvailable) {
    centerOrientX = averageOrientX - 180;
  }
}

void onGyroscopeEvent(float x, float y, float z) {
  gyroX = x;
  gyroY = y;
  gyroZ = z;
}

void onAccelerometerEvent(float x, float y, float z) {
  accelX = x;
  accelY = y;
  accelZ = z;
}
void onOrientationEvent(float x, float y, float z) {
  orientX = x;
  orientY = y;
  orientZ = z;
}

void pause() {
  println("Wake-unlocking");
  WakeLock_unlock();
}

void resume() {
  println("Wake-locking");
  WakeLock_lock();
} 