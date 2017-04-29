// checks which sensors are available and calculates how many bars are shown, the height of each bar and font size
void checkSensors() {
  
  numberOfBars = 0;
  
  if (sensor.isAccelerometerAvailable()) {
    isAccelerometerAvailable = true;
    numberOfBars += 3;
  }
  
  if (sensor.isLinearAccelerationAvailable()) {
    isLinearAccelerationAvailable = true;
    numberOfBars += 6; // includes 3 values for gravity
  }
  
  if (sensor.isSignificantMotionAvailable()) {
    isSignificantMotionAvailable = true;
    numberOfBars += 1;
  }
  
  if (sensor.isGyroscopeAvailable()) {
    isGyroscopeAvailable = true;
    numberOfBars += 3;
  }
  
  if (sensor.isRotationVectorAvailable()) {
    isRotationVectorAvailable = true;
    numberOfBars += 3;
  }
  
  if (sensor.isGameRotationAvailable()) {
    isGameRotationAvailable = true;
    numberOfBars += 3;
  }
  
  if (sensor.isMagenticFieldAvailable()) {
    isMagneticFieldAvailable = true;
    numberOfBars += 3;
  }
  
  if (sensor.isOrientationAvailable()) {
    isOrientationAvailable = true;
    numberOfBars += 3;
  }
  
  if (sensor.isGeomagneticRotationVectorAvailable()) {
    isGeomagneticRotationVectorAvailable = true;
    numberOfBars += 3;
  }
  
  if (sensor.isProximityAvailable()) {
    isProximityAvailable = true;
    numberOfBars += 1;
  }
  
  if (sensor.isLightAvailable()) {
    isLightAvailable = true;
    numberOfBars += 1;
  }
  
  if (sensor.isPressureAvailable()) {
    isPressureAvailable = true;
    numberOfBars += 1;
  }
  
  if (sensor.isTemperatureAvailable()) {
    isTemperatureAvailable = true;
    numberOfBars += 1;
  }
  if (sensor.isAmbientTemperatureAvailable()) {
    isAmbientTemperatureAvailable = true;
    numberOfBars += 1;
  }
  
  if (sensor.isRelativeHumidityAvailable()) {
    isRelativeHumidityAvailable = true;
    numberOfBars += 1;
  }
  
  if (sensor.isStepDetectorAvailable()) {
    isStepDetectorAvailable = true;
    numberOfBars += 2;  // includes heart rate, according to Ketai documentation
  }
  
  if (sensor.isStepCounterAvailable()) {
    isStepCounterAvailable = true;
    numberOfBars += 1;
  }
  
  barHeight = height / numberOfBars;
  fontHeight = barHeight * 3/4;
  if (fontHeight > height/20) fontHeight = height/20;
  println("Values: " + numberOfBars + "  Bar Height: " + barHeight + "  Font Height: " + fontHeight); 
}


// draws a single bar at the specified height, mapping a range of sensor values (min, max) to the screen width
// title - the text to be displayed (sensor value will be appended)
// posY - the vertical position of the bar (top)
// value - the sensor value to be displayed
// min, max - range of sensor values corresponding to an empty bar and a full bar, respectively
void drawBar(String title, int posY, float value, float min, float max) {
  fill(180);
  float barWidth = map(value, min, max, 0, width);
  rect(0, posY, barWidth, barHeight);  
  fill(0);
  text(title + ": " + nf(value, 0, 1), fontHeight/2, posY, width, barHeight);
}

// draws the bars for each sensor on screen; called during draw()
void drawSensorData() {
  
  // current Y-position for drawing bars, will be incremented each time we draw a bar
  int currY = 0;
  
  if (isAccelerometerAvailable) {
    drawBar("Accel X", currY, dataAccel.x, -10, 10);
    currY += barHeight;  
    drawBar("Accel Y", currY, dataAccel.y, -10, 10);
    currY += barHeight;  
    drawBar("Accel Z", currY, dataAccel.z, -10, 10);
    currY += barHeight;  
  }
  
  if (isLinearAccelerationAvailable) {
    drawBar("Linear Accel X", currY, dataLinear.x, -10, 10);
    currY += barHeight;  
    drawBar("Linear Accel Y", currY, dataLinear.y, -10, 10);
    currY += barHeight;  
    drawBar("Linear Accel Z", currY, dataLinear.z, -10, 10);
    currY += barHeight;  
    drawBar("Gravity X", currY, dataGravity.x, -10, 10);
    currY += barHeight;  
    drawBar("Gravity Y", currY, dataGravity.y, -10, 10);
    currY += barHeight;  
    drawBar("Gravity Z", currY, dataGravity.z, -10, 10);
    currY += barHeight;  
  }
  
  if (isSignificantMotionAvailable) {
    drawBar("Motion", currY, dataMotion, 0, 100);
    currY += barHeight;  
    dataMotion -= 0.5; 
    if (dataMotion < 0) dataMotion = 0;
  }
  
  if (isGyroscopeAvailable) {
    drawBar("Gyro X", currY, dataGyro.x, -5, 5);
    currY += barHeight;  
    drawBar("Gyro Y", currY, dataGyro.y, -5, 5);
    currY += barHeight;  
    drawBar("Gyro Z", currY, dataGyro.z, -5, 5);
    currY += barHeight;  
  }
  
  if (isRotationVectorAvailable) {
    drawBar("Rotation X", currY, dataRot.x, -1, 1);
    currY += barHeight;  
    drawBar("Rotation Y", currY, dataRot.y, -1, 1);
    currY += barHeight;  
    drawBar("Rotation Z", currY, dataRot.z, -1, 1);
    currY += barHeight;
  }
  
  if (isGameRotationAvailable) {
    drawBar("Game Rot. X", currY, dataGameRot.x, -1, 1);
    currY += barHeight;  
    drawBar("Game Rot. Y", currY, dataGameRot.y, -1, 1);
    currY += barHeight;  
    drawBar("Game Rot. Z", currY, dataGameRot.z, -1, 1);
    currY += barHeight;
  }
  
  if (isMagneticFieldAvailable) {
    drawBar("Magn. Field X", currY, dataMagnet.x, -100, 100);
    currY += barHeight;  
    drawBar("Magn. Field Y", currY, dataMagnet.y, -100, 100);
    currY += barHeight;  
    drawBar("Magn. Field Z", currY, dataMagnet.z, -100, 100);
    currY += barHeight;
  }
  
  if (isOrientationAvailable) {
    drawBar("Orient. X", currY, dataOrient.x,    0, 360); // seems to only get positive numbers
    currY += barHeight;  
    drawBar("Orient. Y", currY, dataOrient.y, -180, 180);
    currY += barHeight;  
    drawBar("Orient. Z", currY, dataOrient.z, -180, 180);
    currY += barHeight;
  }
  
  if (isGeomagneticRotationVectorAvailable) {
    drawBar("Geomag. X", currY, dataGeomag.x, -1, 1);
    currY += barHeight;  
    drawBar("Geomag. Y", currY, dataGeomag.y, -1, 1);
    currY += barHeight;  
    drawBar("Geomag. Z", currY, dataGeomag.z, -1, 1);
    currY += barHeight;
  }
  
  if (isProximityAvailable) {
    drawBar("Proximity", currY, dataProx, 0, 10);
    currY += barHeight;
  }
  
  if (isLightAvailable) {
    drawBar("Light", currY, dataLight, 0, 600);
    currY += barHeight;
  }
  
  if (isPressureAvailable) {
    drawBar("Pressure", currY, dataPressure, 10, 150);
    currY += barHeight;
  }
  
  if (isTemperatureAvailable) {
    drawBar("Temp.", currY, dataTemp, -10, 50);
    currY += barHeight;
  }
  
  if (isAmbientTemperatureAvailable) {
    drawBar("Amb. Temp.", currY, dataAmbTemp, -10, 50);
    currY += barHeight;
  }
  
  if (isRelativeHumidityAvailable) {
    drawBar("Humidity", currY, dataHumidity, 0, 100);
    currY += barHeight;
  }
  
  if (isStepDetectorAvailable) {
    drawBar("Steps", currY, dataSteps, 0, 300);
    currY += barHeight;
  }
  
  if (isStepCounterAvailable) {
    drawBar("Total Steps", currY, dataTotalSteps, 0, 600);
    currY += barHeight;
  }
  
  if (isStepDetectorAvailable) {
    drawBar("Heart Rate", currY, dataHeart, 0, 200);
    currY += barHeight;
  }
}