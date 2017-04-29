import android.content.Context;
import android.os.PowerManager;

PowerManager powerManager;
PowerManager.WakeLock wakeLock;

void WakeLock_lock() {
  WakeLock_lock(PowerManager.FULL_WAKE_LOCK);
}

void WakeLock_lock(int lockTypeFlag) {
  if (wakeLock == null) {
    println("obtaining PowerManager object");
    powerManager = (PowerManager) getActivity().getSystemService(Context.POWER_SERVICE);
    if (powerManager == null) {
      println("ERROR: PowerManager object is null");
      return;
    }
    println("obtaining WakeLock object");
    wakeLock = powerManager.newWakeLock(lockTypeFlag, "My Processing Sketch");
  }
  wakeLock.acquire();
}

void WakeLock_unlock () {
  if (wakeLock != null) {
    wakeLock.release();
  }
}