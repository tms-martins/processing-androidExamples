/*
 * This sketch makes use of a wake-lock to keep the device's screen on and bright while running.
 * The wake lock's imports, objects and methods are implemented in a separate tab, so that they can be copied to another sketch.
 *
 * The wake-lock functions should be called on pause() and resume(), otherwise 
 * the screen may stay on and bright (and wasting battery) while the app is paused.
 *
 * You may also call WakeLock_lock() with a parameter specifying the type of wake lock (see the link below).
 * These include PARTIAL_WAKE_LOCK, SCREEN_DIM_WAKE_LOCK, SCREEN_BRIGHT_WAKE_LOCK, FULL_WAKE_LOCK.
 * You have to use the class' name PowerManager before the flag, for instance: WakeLock_lock(PowerManager.SCREEN_DIM_WAKE_LOCK);
 *
 * Based on the PowerManager example from
 * http://developer.android.com/reference/android/os/PowerManager.html
 *
 * This sketch requires the permission WAKE_LOCK 
 *
 * Tiago Martins 2017-2019
 * https://github.com/tms-martins/processing-androidExamples
 */


void setup() {
  fullScreen();
  orientation(PORTRAIT);
  
  textAlign(CENTER, CENTER);
  fill(0);
  textSize(height/30);
}

void draw() {
  background(255);
  text("The screen will stay on and bright while the app is running", 10, 10, width-20, height-20);
}

void pause() {
  println("Wake-unlocking");
  WakeLock_unlock();
}

void resume() {
  println("Wake-locking");
  WakeLock_lock();
} 
