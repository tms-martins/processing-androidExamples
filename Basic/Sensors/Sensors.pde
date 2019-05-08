/*
 * This sketch provides a basic example of using sensors in Android Mode.
 *
 * You can access the values of different sensors via a set of "wrapper" classes, defined in PASensor.java. 
 * The generic wrapper PASensor lets you create and access values of any sensor type defined in android.hardware.Sensor.
 * Some types of sensor (accelerometer,  orientation, steps) have specific "wrapper-classes":
 * PASensorStepCounter, PASensorStepDetector, PASensorOrientation, PASensorAccelerometer, PASensorLinearAccel
 * 
 * Tiago Martins 2019
 * https://github.com/tms-martins/processing-androidExamples
 */

// The following import is necessary only when you are using the generic PASensor class
// to create sensors by type, so that you can use the type constants - for instance Sensor.TYPE_LIGHT
import android.hardware.Sensor;


// The following sensors have specific classes, with utility functions
PASensorStepCounter   stepCounter;
PASensorStepDetector  stepDetector;
PASensorOrientation   orientation;
PASensorAccelerometer accelerometer;
PASensorLinearAccel   linearAccel;

// The following sensors will be created using the generic PASensor class
PASensor light;
PASensor pressure;
PASensor proximity;
PASensor humidity;
PASensor temperature;

// We store a reference to all sensors in a list
// so we can turn them all on/off when the sketch resumes/pauses
ArrayList<PASensor> allSensors;

float padding = 10;


void setup() {
  orientation(PORTRAIT);
  textFont(createFont("Monospaced", 12 * displayDensity));
  
  padding *= displayDensity;
  
  allSensors = new ArrayList<PASensor>();

  // create sensors which have a specific wrapper

  stepCounter = new PASensorStepCounter(this);
  stepCounter.start();
  allSensors.add(stepCounter);
  
  stepDetector = new PASensorStepDetector(this);
  stepDetector.setSensorEventMethod("stepDetected");  // when a step is detected, call stepDetected() (see below)
  stepDetector.start();
  allSensors.add(stepDetector);
  
  orientation = new PASensorOrientation(this);
  orientation.start();
  allSensors.add(orientation);
  
  accelerometer = new PASensorAccelerometer(this);
  accelerometer.start();
  allSensors.add(accelerometer);
  
  linearAccel = new PASensorLinearAccel(this);
  linearAccel.start();
  allSensors.add(linearAccel);
  
  // create sensors using the generic PASensor wrapper, by passing the sensor type
  
  light = new PASensor(this, Sensor.TYPE_LIGHT);
  light.start();
  allSensors.add(light);
  
  pressure = new PASensor(this, Sensor.TYPE_PRESSURE);
  pressure.start();
  allSensors.add(pressure);

  proximity = new PASensor(this, Sensor.TYPE_PROXIMITY);
  proximity.start();
  allSensors.add(proximity);
  
  humidity = new PASensor(this, Sensor.TYPE_RELATIVE_HUMIDITY);
  humidity.start();
  allSensors.add(humidity);
  
  temperature = new PASensor(this, Sensor.TYPE_AMBIENT_TEMPERATURE);
  temperature.start();
  allSensors.add(temperature);
}


// we told our step detector to call this function when a step is detected
void stepDetected() {
  println("Step at " + nf(millis()/1000.0, 0, 2) + " seconds");
}


void draw() {
  background(0);
  fill(255);
  
  // For all sensors: 
  //  - we can get the values as a float array by calling getValues()
  //  - or just the first value as a float by calling getValue()
  // For the accelerometer and linear acceleration:
  //  - we can get the x, y and z components as floats by calling getX(), getY() and getZ()
  // For the orientation sensor
  //  - getValues() returns orientation as a quaternion of Euler angles (which we probably won't use)
  //  - instead, we can get orientation angles in radians as an array of floats (azimuth, pitch, roll) by calling getOrientationAngles() 
  
  float [] orientationAngles = orientation.getOrientationAngles();
  float azimuth = orientationAngles[0]; // heading, direction 
  float pitch   = orientationAngles[1]; // pitch forward/backward
  float roll    = orientationAngles[2]; // roll sideways, lefth/right
  
  // display sensor info as text
  // if a sensor is available, the text is preceded by an "O", otherwise an "X"
  
  String message = "";
  message += (stepCounter.isSupported()   ? "O":"X") + " Steps: " + stepCounter.getStepCount() + "\n";
  message += (orientation.isSupported()   ? "O":"X") + " Azim./Pitch/Roll: " + nf(azimuth, 0, 2) + " " + nf(pitch, 0, 2) + " " + nf(roll, 0, 2) + "\n";
  message += (accelerometer.isSupported() ? "O":"X") + " Accel. (x/y/z): " + nfp(accelerometer.getX(), 0, 2) + " " + nfp(accelerometer.getY(), 0, 2) + " " + nfp(accelerometer.getZ(), 0, 2) + "\n";
  message += (linearAccel.isSupported()   ? "O":"X") + " Linear (x/y/z): " + nfp(linearAccel.getX(), 0, 2) + " " + nfp(linearAccel.getY(), 0, 2) + " " + nfp(linearAccel.getZ(), 0, 2) + "\n";
  message += (light.isSupported()         ? "O":"X") + " Light: " + nf(light.getValue(), 0, 2) + " lux\n";
  message += (pressure.isSupported()      ? "O":"X") + " Pressure: " + nf(pressure.getValue(), 0, 2) + " hPa\n";
  message += (proximity.isSupported()     ? "O":"X") + " Proximity: " + nf(proximity.getValue(), 0, 2) + " cm\n";
  message += (humidity.isSupported()      ? "O":"X") + " Humidity: " + nf(humidity.getValue(), 0, 2) + " perc.\n";
  message += (temperature.isSupported()   ? "O":"X") + " Temperature: " + nf(temperature.getValue(), 0, 2) + " deg. C";
  
  text(message, padding, padding, width - (2*padding), height - (2*padding));
}


void pause() {
  println("pause()");
  if (allSensors != null) {
    for (PASensor sensor : allSensors) {
      sensor.stop();
    }
  }
}


void resume() {
  println("resume()");
    if (allSensors != null) {
    for (PASensor sensor : allSensors) {
      sensor.start();
    }
  }
}
