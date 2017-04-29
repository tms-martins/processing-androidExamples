/*
 * This tab contains all the event handlers called by the Ketai sensor object.
 * On each handler, the sensor values are stored in our own global variables.
 */

void onAccelerometerEvent(float x, float y, float z) { //  x,y,z force in m/s2
  dataAccel.x = x;
  dataAccel.y = y;
  dataAccel.z = z;
}

void onLinearAccelerationEvent(float x, float y, float z) { // x,y,z acceleration force in m/s^2, minus gravity
  dataLinear.x = x;
  dataLinear.y = y;
  dataLinear.z = z;
}

void onGravityEvent(float x, float y, float z) { // x,y,z rotation in m/s^s
  dataGravity.x = x;
  dataGravity.y = y;
  dataGravity.z = z;
}

void onGyroscopeEvent(float x, float y, float z) { // x,y,z rotation in rads/sec
  dataGyro.x = x;
  dataGyro.y = y;
  dataGyro.z = z;
}

void onRotationVectorEvent(float x, float y, float z) { // x,y,z rotation vector values
  dataRot.x = x;
  dataRot.y = y;
  dataRot.z = z;
}

void onGameRotationEvent(float x, float y, float z) { // ?
  dataGameRot.x = x;
  dataGameRot.y = y;
  dataGameRot.z = z;
}

void onMagneticFieldEvent(float x, float y, float z) { // x,y,z geomagnetic field in uT
  dataMagnet.x = x;
  dataMagnet.y = y;
  dataMagnet.z = z;
}

void onOrientationEvent(float x, float y, float z) { // x,y,z rotation in degrees
  dataOrient.x = x;
  dataOrient.y = y;
  dataOrient.z = z;
}

void onGeomagneticRotationVectorEvent(float x, float y, float z) { //
  dataGeomag.x = x;
  dataGeomag.y = y;
  dataGeomag.z = z;
}

void onProximityEvent(float d) { // d distance from sensor (typically 0,1)
  dataProx = d;
}

void onLightEvent(float d) { // d illumination from sensor in lx
  dataLight = d;
}

void onPressureEvent(float p) { // p ambient pressure in hPa or mbar
  dataPressure = p;
}

void onTemperatureEvent(float t) { // t temperature in degrees in degrees Celsius
  dataTemp = t;
}

void onAmibentTemperatureEvent(float t) { // ["ambient" is misspelled] same as temp above (newer API)
  dataAmbTemp = t;
}

void onRelativeHumidityEvent(float h) { // h ambient humidity in percentage
  dataHumidity = h;
}

void onSignificantMotionEvent() { // trigger for when significant motion has occurred
  dataMotion = 100;
}

void onStepDetectorEvent() { // called on every step detected
  dataSteps++;
}

void onStepCounterEvent(float s) { // s is the step count since device reboot, is called on new step
  dataTotalSteps = (int)s;
}

void onHeartRateEvent(float r) { // returns current heart rate in bpm
  dataHeart = r;
}