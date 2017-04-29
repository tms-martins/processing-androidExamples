import java.util.List;
import android.content.pm.PackageManager;
import android.content.pm.PackageInfo;
import android.content.pm.ApplicationInfo;

ArrayList<String> getAllAppsList() {
  ArrayList<String> result = new ArrayList<String>();

  PackageManager packageManager = getActivity().getPackageManager(); 

  List<ApplicationInfo> applications = packageManager.getInstalledApplications(0);
  for (ApplicationInfo appInfo : applications) {
    // You can obtain the app's icon as a Drawable (which you would then have to convert to PImage to draw)
    // Drawable packageIcon = packageManager.getApplicationIcon(appInfo);
    String packageLabel = String.valueOf(packageManager.getApplicationLabel(appInfo));
    result.add(packageLabel);
  }
  return result;
}

ArrayList<String> getUserAppsList() {
  ArrayList<String> result = new ArrayList<String>();

  int flags = PackageManager.GET_META_DATA | 
    PackageManager.GET_SHARED_LIBRARY_FILES |     
    PackageManager.GET_UNINSTALLED_PACKAGES;

  PackageManager packageManager = getActivity().getPackageManager(); 

  List<ApplicationInfo> applications = packageManager.getInstalledApplications(flags);
  for (ApplicationInfo appInfo : applications) {
    if ((appInfo.flags & ApplicationInfo.FLAG_SYSTEM) == 1) {
      // System application
    } else {
      // You can obtain the app's icon as a Drawable (which you would then have to convert to PImage to draw)
      // Drawable packageIcon = packageManager.getApplicationIcon(appInfo);
      String packageLabel = String.valueOf(packageManager.getApplicationLabel(appInfo));
      result.add(packageLabel);
    }
  }
  return result;
}