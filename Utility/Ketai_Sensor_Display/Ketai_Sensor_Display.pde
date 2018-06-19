/*
 * This sketch is used to show all available sensors on a device via the Ketai library.
 * It checks which sensors are available and displays their data as a horizontal bar graph.
 * Geolocation (e.g. GPS) is not included.
 *
 * Tiago Martins 2017/2018
 * https://github.com/tms-martins/processing-androidExamples
 */

import ketai.sensors.*; 


// Ketai sensor reference
KetaiSensor sensor;

// availability of each sensor, false by default

boolean isAccelerometerAvailable = false;
boolean isLinearAccelerationAvailable = false;
boolean isSignificantMotionAvailable = false;

boolean isGyroscopeAvailable = false;
boolean isRotationVectorAvailable = false;
boolean isGameRotationAvailable = false;

boolean isMagneticFieldAvailable = false;
boolean isOrientationAvailable = false;
boolean isGeomagneticRotationVectorAvailable = false;

boolean isProximityAvailable = false;
boolean isLightAvailable = false;

boolean isPressureAvailable = false;
boolean isTemperatureAvailable = false;
boolean isAmbientTemperatureAvailable = false;
boolean isRelativeHumidityAvailable = false;

boolean isStepDetectorAvailable = false;
boolean isStepCounterAvailable = false;

// variables to hold data from each sensor

PVector dataAccel   = new PVector();
PVector dataLinear  = new PVector();
PVector dataGravity = new PVector();
float   dataMotion  = 0.0;

PVector dataGyro    = new PVector();
PVector dataRot     = new PVector();
PVector dataGameRot = new PVector(); 

PVector dataMagnet  = new PVector();
PVector dataOrient  = new PVector();
PVector dataGeomag  = new PVector();

float dataProx      = 0.0;
float dataLight     = 0.0;
float dataPressure  = 0.0;
float dataTemp      = 0.0;
float dataAmbTemp   = 0.0;
float dataHumidity  = 0.0;

int dataSteps       = 0;
int dataTotalSteps  = 0;

float dataHeart     = 0;

// variables for calculating the height of each bar and text size

int numberOfBars = 0;
int barHeight = 0;
int fontHeight = 10;


void setup() {
  fullScreen();
  orientation(PORTRAIT);

  // initialize the sensor
  sensor = new KetaiSensor(this);
  sensor.start();
  
  // this will print a list of hardware, but not necessarily all accessible values or functions
  sensor.list();
  
  // check the available sensors
  checkSensors();
  
  // set the text size and drawing parameters
  noStroke();
  textSize(fontHeight);
  textAlign(LEFT, CENTER);
}

void draw() {
  background(255);
  drawSensorData();
}