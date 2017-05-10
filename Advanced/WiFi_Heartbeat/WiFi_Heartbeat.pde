/*
 * This sketch causes the device to vibrate rythmically depending on the total amount of WiFi signal strengths.
 *
 * It uses a WiFiScanner object to scan for networks. When finished scanning, this object calls a wifiScanFinished() function 
 * which must be defined and implemented in the sketch. The sketch calculates the total amount of signal strengths and
 * sets the time between vibrations accordingly.
 *
 * Make sure the device's WiFi is turned on.
 *
 * This sketch requires the permissions ACCESS_WIFI_STATE, CHANGE_WIFI_STATE and VIBRATE.
 *
 * Tiago Martins 2017
 * https://github.com/tms-martins/processing-androidExamples
 */

// time for each cycle of vibration, in milliseconds
int timeVibrateOn = 50;
int timeVibrateOff = 900;

// whether the vibrator is currently on, and a timestamp of the last vibration's start 
boolean vibrateOn = false;
int timeLastVibrate = 0;

// an object for scanning wifi and an object to store results
WiFiScanner wifiScanner;
ArrayList<WiFiListItem> wifiNetworks;

// total of signal strengths and timestamp of the last scan
int signalTotal = 0;
int timeLastScanFinished = 0;

// UI message
String message = "Nothing yet...";

void setup() {
  size(displayWidth, displayHeight, P2D);
  orientation(PORTRAIT);
  
  initBuzz();
  
  wifiNetworks = new ArrayList<WiFiListItem>();
  wifiScanner = new WiFiScanner();
  wifiScanner.init();
  
  textAlign(LEFT, TOP);
}

void draw() {
  updateNetworkScan();
  updateHeartbeat();
  
  int txtSize = width/20;
  
  // clear the background and set the text/shape properties
  background(255);
  textSize(txtSize);
  fill(0);
  noStroke();
  
  // display the UI message 
  text(message + "\nHeart On/Off: " + timeVibrateOn + "/" + timeVibrateOff + "\n Signal Total: " + signalTotal, 20, 20);
  
  // calculate an adequate height and size for bars
  int currentHeight = 5 * txtSize;
  int barHeight = 5 + txtSize;
  
  // draw a bar for each item on the networks list
  for(WiFiListItem item : wifiNetworks) {
    fill(160);
    float barWidth = map(item.level, -100, -10, 30, width);
    rect(0, currentHeight, barWidth, barHeight);
    fill(0);
    text(item.name + " : " + item.level, 10, currentHeight);
    currentHeight += barHeight;    
  }
}

// this function is called periodically to trigger wifi scanning; to save battery 
// you can adjust the comparison value to 10000 (10 seconds) or even more.
void updateNetworkScan() {
  int timeSinceLastScan = millis() - timeLastScanFinished;
  
  if (!wifiScanner.isScanning() && timeSinceLastScan > 3000) {
    message = "Scanning...";
    wifiScanner.scan();
  }
}

// this function is called periodically to turn the vibrator on and off 
// based on the timeVibrateOn and timeVibrateOff variables
void updateHeartbeat() {
  if (millis() - timeLastVibrate > timeVibrateOn + timeVibrateOff) {
    timeLastVibrate = millis();
    buzz.vibrate(timeVibrateOn);
  }
}

// this function is called by the WiFiScanner object when a scan is finished;
// we retrieve a list of WiFiListItem objects, calculate their total signal value 
// and set the hearteat timing accordingly
void wifiScanFinished() {
  message = "Scan Finished";
  timeLastScanFinished = millis();
  wifiNetworks = wifiScanner.getItems();
  int newTotal = 0;
  for (WiFiListItem item : wifiNetworks) {
    newTotal += (100 + item.level); // adding 100 makes the value positive
  }
  signalTotal = newTotal;
  // the vibration timing is mapped from the total signal strength
  // feel free to adjust the ranges at your own liking
  timeVibrateOff = (int)map(signalTotal, 50, 200, 1000, 300);  
  timeVibrateOff = (int)constrain(timeVibrateOff, 300, 1000); 
}