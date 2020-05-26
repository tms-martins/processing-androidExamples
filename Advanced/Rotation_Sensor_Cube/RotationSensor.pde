// Very much based on the official example at
// https://android.googlesource.com/platform/development/+/master/samples/ApiDemos/src/com/example/android/apis/os/RotationVectorDemo.java

// In the future it would be great to include functionality to handle the device's rotation, as in
// https://github.com/kplatfoot/android-rotation-sensor-sample

import java.util.Arrays;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;

class RotationSensor implements SensorEventListener {
  SensorManager sensorManager;
  Sensor rotationSensor;
  int sensorType;
  
  float [] rawValues;
  float [] rotationMatrix;
  float [] orientation;
  
  int [] sensorTypePreference =  {
    Sensor.TYPE_ROTATION_VECTOR
  };
  
  // You can instead provide an array of sensor type preferences,
  // so that the object tries to obtain the preferred ones.
  // int [] sensorTypePreference =  {
  //   Sensor.TYPE_ROTATION_VECTOR,
  //   Sensor.TYPE_GAME_ROTATION_VECTOR,
  //   Sensor.TYPE_GEOMAGNETIC_ROTATION_VECTOR
  // };
  
  RotationSensor() {
    rawValues      = new float[4];
    rotationMatrix = new float[16];
    orientation    = new float[3];
    sensorManager = (SensorManager)getContext().getSystemService(Context.SENSOR_SERVICE);
    
    for (int i = 0; i < sensorTypePreference.length; i++) {
      sensorType = sensorTypePreference[i];
      rotationSensor = sensorManager.getDefaultSensor(sensorType);
      if (rotationSensor != null) {
        println("RotationSensor() found sensor: " + rotationSensor.getName());
        break;
      }
    }
    if (rotationSensor == null) {
      println("ERROR RotationSensor(): no rotation sensor found");
    }
  }
  
  void resume() {
    println("RotationSensor.resume()");
    sensorManager.registerListener(this, rotationSensor, 30000);
  }
  
  void pause() {
    println("RotationSensor.pause()");
    sensorManager.unregisterListener(this);
  }
  
  void onSensorChanged(SensorEvent event) {
    if (event.sensor.getType() == sensorType) {
      rawValues = Arrays.copyOf(event.values, rawValues.length);
      
      SensorManager.getRotationMatrixFromVector(rotationMatrix , rawValues);
      SensorManager.getOrientation(rotationMatrix, orientation);
    }
  }
  
  void onAccuracyChanged(Sensor sensor, int accuracy) {
  }
}
