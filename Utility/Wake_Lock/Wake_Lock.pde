/*
 * This sketch makes use of a wake-lock to keep the device's screen on and bright while running.
 * The wake lock's imports, objects and methods are implemented in a separate tab, so that they can be copied to another sketch.
 *
 * The wake-lock functions should be called on pause() and resume(), otherwise 
 * the screen may stay on and bright (and wasting battery) while the app is paused.
 *
 * You may also call WakeLock_lock() with a parameter specifying the type of wake lock (see the link below).
 * These include PARTIAL_WAKE_LOCK, SCREEN_DIM_WAKE_LOCK, SCREEN_BRIGHT_WAKE_LOCK, FULL_WAKE_LOCK.
 * You have to use the class' name PowerManager before the flag, for instance: WakeLock_lock(PowerManager.FULL_WAKE_LOCK);
 *
 * Based on the PowerManager example from
 * http://developer.android.com/reference/android/os/PowerManager.html
 *
 * This sketch requires the permission WAKE_LOCK 
 *
 * Tiago Martins 2017-2020
 * https://github.com/tms-martins/processing-androidExamples
 */


void setup() {
  fullScreen();
  orientation(PORTRAIT);
  
  textAlign(CENTER, CENTER);
  fill(0);
  textSize(22 * displayDensity);
}

void draw() {
  background(255);
  text("The screen will stay on while the app is running. The screen's brightness may dim after a while to save battery.", 20, 20, width-40, height-40);
}

void pause() {
  println("Wake-unlocking");
  WakeLock_unlock();
}

void resume() {
  println("Wake-locking");
  WakeLock_lock();
} 
