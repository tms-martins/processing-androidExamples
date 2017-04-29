/*
 * You can write all your data-processing needs in the update() method on the main sketch;
 * or replace the call to update() in the run() function to whatever suits your needs.
 *
 * WARNING: Do not use drawing functions in the update() function or anywhere on this class! Only data-processing stuff.
 *
 * This will be executed even when the app is in background 
 * (but not if it's killed because, for example, you start some other app which needs more memory).
 */

class UpdateThread extends Thread {
  boolean bRunning = false;
  boolean proceed = true;
  
  public void run() {
    println("UpdateThread started"); 
    bRunning = true;
    while (proceed) {
      update();
      try {
        sleep(200);
      } catch (Exception e) {
        println("UpdateThread was interrupted while sleeping...?");
        println(e.getMessage());
      }
    }
    System.out.println("UpdateThread stopped");
    bRunning = false;
  }
  
  public void kill() {
    proceed = false;
    while (bRunning) {
      try {
        sleep(100);
      } catch (Exception e) {
        println("UpdateThread was interrupted while sleeping...?");
        println(e.getMessage());
      }
    }
  }
}