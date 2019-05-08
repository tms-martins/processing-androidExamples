import processing.core.PApplet;

import java.lang.reflect.*;
import java.util.List;

import android.os.Bundle;
import android.content.Context;
import android.location.LocationManager;
import android.location.LocationListener;
import android.location.Location;
import android.location.Criteria;

public class PALocationManager implements LocationListener {
  
  protected PApplet parent;
  protected boolean hasPermission;
  
  protected LocationManager  locationManager;
  protected LocationListener locationListener;
  protected String           locationProvider;
  protected Location         location;
  
  protected Method locationUpdateMethod;
  
  public PALocationManager (PApplet parent) {
    this.parent      = parent;
    locationProvider = "none";
    locationListener = this;
    location         = new Location("default");
  }
  
  public void setLocationUpdateMethod(String methodName) {
    try {
      locationUpdateMethod = parent.getClass().getMethod(methodName, new Class[] {});
    } catch (Exception e) {
      System.out.println("PALocationManager.setLocationUpdateMethod() WARNING: parent has no method " + methodName + "()");
    }
  }
  
  public String getProvider() {
    return locationProvider;
  }
  
  public double getLatitude() {
    return location.getLatitude();
  }
  
  public double getLongitude() {
    return location.getLongitude();
  }
  
  public double getAltitude() {
    return location.getAltitude();
  }
  
  public float getAccuracy() {
    return location.getAccuracy();
  }
  
  public float getSpeed() {
    return location.getSpeed();
  }
  
  //public float getSpeedAccuracy() {
  //  return location.getSpeedAccuracyMetersPerSecond();
  //}
  
  public Location getLocation() {
    return location;
  }
  
  public void start() {
    if (!hasPermission) {
      parent.requestPermission("android.permission.ACCESS_FINE_LOCATION", "onPermissionResult", this);
      return;
    }
    
    locationManager = (LocationManager) parent.getSurface().getContext().getSystemService(Context.LOCATION_SERVICE);
      
    String provider = selectProvider();
    
    if (provider != null) {
      locationProvider = provider;
      Location lastKnownLocation = locationManager.getLastKnownLocation(locationProvider);

      if (lastKnownLocation != null) {
        location = new Location(lastKnownLocation);
        PApplet.println("PALocationManager.start(): last known location from provider " + locationProvider + " is:");
        PApplet.println(location.toString());
        onLocationChanged(location);
      }
      else {
        PApplet.println("PALocationManager.start() WARNING: couldn't retrieve last known location from provider " + locationProvider);
      }
      
      locationManager.requestLocationUpdates(locationProvider, (long)2500, (float)0.1, locationListener);
    }
  }  
  
  public void stop() {
    locationManager.removeUpdates(locationListener);
  }
  
  public void onPermissionResult(boolean granted) {
    hasPermission = granted;
    if (!hasPermission) {
      PApplet.println("PALocationManager.onPermissionResult() WARNING: User did not grant location permission.");
    }
    else {
      start();
    }
  }
  
  public void onLocationChanged(Location location) {
    PApplet.println("PALocationManager.onLocationChanged(): " + location.toString());
    this.location = new Location(location);
    
    // if an event handler was specified, try to call it on the parent
    if (locationUpdateMethod != null) {
      try {
        locationUpdateMethod.invoke(parent, new Object[] {});
      } catch (Exception e) {
        System.out.println("PALocationManager.onLocationChanged() ERROR: exception when invoking location update method on parent:");
        System.out.println(e.getMessage());
        e.printStackTrace();
        locationUpdateMethod = null;
      }
    }
  }
  
  public void onProviderDisabled(String provider) {
    PApplet.println("PALocationManager.onProviderDisabled(): " + provider);
  }
  
  public void onProviderEnabled(String provider) {
    PApplet.println("PALocationManager.onProviderEnabled: " + provider);
  }
  
  public void onStatusChanged(String provider, int status, Bundle extras) {
    // This method was deprecated in API level Q. This callback will never be invoked.
  }
  
  protected String selectProvider() {
    String selectedProvider = null;
    
    PApplet.println("PALocationManager: listing location providers ");
    List<String> providersList = locationManager.getAllProviders();
    for (String provider : providersList)
      PApplet.println(provider);
    
    selectedProvider = locationManager.getBestProvider(new Criteria(), true);
    
    if (selectedProvider == null) {
      PApplet.println("PALocationManager.selectProvider() ERROR: no location provider selected; perhaps you are missing the necessary permissions?");
    }
    else {
      PApplet.println("PALocationManager.selectProvider(): selected " + selectedProvider);
    }
    
    return selectedProvider;
  }
}
