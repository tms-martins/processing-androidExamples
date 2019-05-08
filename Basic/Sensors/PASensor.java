import processing.core.PApplet;

import java.lang.reflect.*;
import java.util.List;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;


/* -------------------------------------------------------------------------------

  The following is a short list of sensors *without* a specific wrapper class,
  along with the sensor values stored in the values array, 
  which can be obtained with getValues(); or getValue() for the first value only.
  
  Sensor.TYPE_LIGHT
    values[0]: Ambient light level in SI lux units
  Sensor.TYPE_PRESSURE
    values[0]: Atmospheric pressure in hPa (millibar)
  Sensor.TYPE_PROXIMITY:  
    values[0]: Proximity sensor distance measured in centimeters
  Sensor.TYPE_RELATIVE_HUMIDITY
    values[0]: Relative ambient air humidity in percent
  Sensor.TYPE_AMBIENT_TEMPERATURE
    values[0]: ambient (room) temperature in degree Celsius

------------------------------------------------------------------------------- */


// ==============================================================================
// == Accelerometer : Sensor.TYPE_ACCELEROMETER =================================
// ==============================================================================

class PASensorAccelerometer extends PASensor {
  
  public PASensorAccelerometer(PApplet parent) {
    super(parent, Sensor.TYPE_ACCELEROMETER);
  }
  
  public float getX() { return values[0]; }
  
  public float getY() { return values[1]; }
  
  public float getZ() { return values[2]; }
}


// ==============================================================================
// == Linear acceleration : Sensor.TYPE_LINEAR_ACCELERATION =====================
// ==============================================================================

class PASensorLinearAccel extends PASensor {
  
  public PASensorLinearAccel(PApplet parent) {
    super(parent, Sensor.TYPE_LINEAR_ACCELERATION);
  }
  
  public float getX() { return values[0]; }
  
  public float getY() { return values[1]; }
  
  public float getZ() { return values[2]; }
}


// ==============================================================================
// == Orientation : Sensor.TYPE_ROTATION_VECTOR =================================
// ==============================================================================

class PASensorOrientation extends PASensor {
  
  public PASensorOrientation(PApplet parent) {
    super(parent, Sensor.TYPE_ROTATION_VECTOR);
  }
  
  public float [] getOrientationAngles() {
    // Rotation matrix based on current readings from accelerometer and magnetometer.
    final float[] rotationMatrix = new float[9];
    SensorManager.getRotationMatrixFromVector(rotationMatrix , this.values);

    // Express the updated rotation matrix as three orientation angles.
    final float[] orientationAngles = new float[3];
    SensorManager.getOrientation(rotationMatrix, orientationAngles);
    
    return orientationAngles;
  }
}


// ==============================================================================
// == Step Detector : Sensor.TYPE_STEP_DETECTOR =================================
// ==============================================================================

class PASensorStepDetector extends PASensor {
  
  public PASensorStepDetector(PApplet parent) {
    super(parent, Sensor.TYPE_STEP_DETECTOR);
  }
}


// ==============================================================================
// == Step Counter : Sensor.TYPE_STEP_COUNTER ===================================
// ==============================================================================

class PASensorStepCounter extends PASensor {
  
  public PASensorStepCounter(PApplet parent) {
    super(parent, Sensor.TYPE_STEP_COUNTER);
  }
  
  public int getStepCount() {
    return (int)values[0];
  }
}


// ==============================================================================
// == Sensor (generic) ==========================================================
// ==============================================================================

public class PASensor {
  
  protected static int MAX_NUM_FIELDS = 6;
  
  protected Sensor  sensor;
  protected int     type;
  protected boolean isSupported;
  protected boolean isRunning;
  protected float[] values;
  
  protected PApplet parent;
  protected Context context;
  protected SensorManager sensorManager;  
  
  protected Method sensorEventMethod;
  protected SensorEventListener sensorEventListener;
  
  public PASensor (PApplet parent, int type) {
    this.parent   = parent;
    this.type     = type;
    this.context  = parent.getActivity();
    this.values   = new float[this.MAX_NUM_FIELDS];
    sensorManager = (SensorManager) this.context.getSystemService(Context.SENSOR_SERVICE);
    
    List<Sensor> sensors = sensorManager.getSensorList(type);
    if (sensors.size() == 0) {
      this.isSupported = false;
      System.out.println("PASensor WARNING: this type of sensor isn't supported on your device - " + getStringTypeFromIntType(type) + " (" + type + ")");
      return;
    }
    else {
      this.sensor      = sensors.get(0);
      this.isSupported = true;
    }
    
    sensorEventListener = new PASensorEventListener();
  }
  
  public boolean isSupported() {
    return this.isSupported;
  }
  
  public boolean isRunning() {
    return this.isRunning;
  }
  
  public int getType() {
    return this.type;
  }
  
  public String getStringType() {
    if (this.sensor != null)
      return this.sensor.getStringType();
    else
      return getStringTypeFromIntType(this.type);
  }
  
  public Sensor getAndroidSensor() {
    return this.sensor;
  }
  
  public float[] getValues() {
    return this.values;
  }
  
  public float getValue() {
    return this.values[0];
  }
  
  public static boolean isSupportedType(PApplet parent, int sensorType) {
    SensorManager sensorManager = (SensorManager) parent.getActivity().getSystemService(Context.SENSOR_SERVICE);
    List<Sensor> sensors = sensorManager.getSensorList(sensorType);
    return sensors.size() > 0;
  }
  
  public void setSensorEventMethod(String methodName) {
    try {
      sensorEventMethod = parent.getClass().getMethod(methodName, new Class[] {});
    } catch (Exception e) {
      System.out.println("PASensor.setSensorEventMethod() WARNING: parent has no method " + methodName + "()");
    }
  }
  
  public boolean start() {
    if (!isRunning) {
      isRunning = sensorManager.registerListener(this.sensorEventListener, this.sensor, SensorManager.SENSOR_DELAY_GAME);
    }
    return isRunning;
  }
  
  public void stop() {
    if (isRunning) {
      sensorManager.unregisterListener(sensorEventListener);
      isRunning = false;
    }
  }
  
  static String getStringTypeFromIntType(int type) {
    if (type < 0 || type >= typeStringTable.length) 
      return STRING_TYPE_UNKNOWN;
    
    String stringType = typeStringTable[type];
    if (stringType == null) 
      return STRING_TYPE_UNKNOWN;
    
    return stringType;
  }
  
  // Nested class for sensor event handling
  protected class PASensorEventListener implements SensorEventListener {
  
    public void onAccuracyChanged(Sensor sensor, int accuracy) {
      // ignored for now
    }

    public void onSensorChanged(SensorEvent event) {
      int numValues = event.values.length;
      // make sure we have the correct array size to store values 
      if (values.length != numValues) values = new float[numValues];
      // copy the values over to our array
      for (int i = 0; i < numValues; i++) {
        values[i] = event.values[i];
      } 
      // if an event handler was specified for this sensor, try to call it on the parent
      if (sensorEventMethod != null) {
        try {
          sensorEventMethod.invoke(parent, new Object[] {});
        } catch (Exception e) {
          System.out.println("PASensorEventListener.onSensorChanged() ERROR: exception when invoking sensor event method on parent:");
          System.out.println(e.getMessage());
          e.printStackTrace();
          sensorEventMethod = null;
        }
      }
    }
  };
  
  protected static String STRING_TYPE_UNKNOWN = "unknow sensor type";
  
  // used to map sensor types to type-strings, for convenience
  protected static String[] typeStringTable = {
    null,
    Sensor.STRING_TYPE_ACCELEROMETER,
    Sensor.STRING_TYPE_MAGNETIC_FIELD,
    Sensor.STRING_TYPE_ORIENTATION,     // deprecated, use SensorManager.getOrientation()
    Sensor.STRING_TYPE_GYROSCOPE,
    Sensor.STRING_TYPE_LIGHT,
    Sensor.STRING_TYPE_PRESSURE,
    Sensor.STRING_TYPE_TEMPERATURE,     // deprecated, use TYPE_AMBIENT_TEMPERATURE 
    Sensor.STRING_TYPE_PROXIMITY,
    Sensor.STRING_TYPE_GRAVITY,
    Sensor.STRING_TYPE_LINEAR_ACCELERATION,
    Sensor.STRING_TYPE_ROTATION_VECTOR,
    Sensor.STRING_TYPE_RELATIVE_HUMIDITY,
    Sensor.STRING_TYPE_AMBIENT_TEMPERATURE,
    Sensor.STRING_TYPE_MAGNETIC_FIELD_UNCALIBRATED,
    Sensor.STRING_TYPE_GAME_ROTATION_VECTOR,
    Sensor.STRING_TYPE_GYROSCOPE_UNCALIBRATED,
    Sensor.STRING_TYPE_SIGNIFICANT_MOTION,
    Sensor.STRING_TYPE_STEP_DETECTOR,
    Sensor.STRING_TYPE_STEP_COUNTER,
    Sensor.STRING_TYPE_GEOMAGNETIC_ROTATION_VECTOR,
    Sensor.STRING_TYPE_HEART_RATE,
    null,
    null,
    null,
    null,
    null,
    null,
    Sensor.STRING_TYPE_POSE_6DOF,
    Sensor.STRING_TYPE_STATIONARY_DETECT,
    Sensor.STRING_TYPE_MOTION_DETECT,
    Sensor.STRING_TYPE_HEART_BEAT,
    null,
    null,
    Sensor.STRING_TYPE_LOW_LATENCY_OFFBODY_DETECT,
    Sensor.STRING_TYPE_ACCELEROMETER_UNCALIBRATED,
    null,
  };
  
  
}
