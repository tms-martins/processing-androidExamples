import android.content.Context;
import android.app.ActivityManager;

int getMaxMemorySizeMB() {
  ActivityManager activityManager = (ActivityManager)getActivity().getSystemService(Context.ACTIVITY_SERVICE);
  if (activityManager == null) {
    return -1;
  }
  return activityManager.getMemoryClass();
}

int getMaxLargeMemorySizeMB() {
  ActivityManager activityManager = (ActivityManager)getActivity().getSystemService(Context.ACTIVITY_SERVICE);
  if (activityManager == null) {
    return -1;
  }
  return activityManager.getLargeMemoryClass();
}

int getUsedMemorySizeMB() {

    long freeSize = 0L;
    long totalSize = 0L;
    long usedSize = -1L;
    try {
        Runtime info = Runtime.getRuntime();
        freeSize = info.freeMemory();
        totalSize = info.totalMemory();
        usedSize = totalSize - freeSize;
    } catch (Exception e) {
        e.printStackTrace();
    }
    return floor(usedSize/1048576);
}