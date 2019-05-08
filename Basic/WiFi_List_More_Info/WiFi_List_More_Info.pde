/*
 * This example scans for and displays WiFi networks and their signal strengths.
 * It also prints some more info about each scan result.
 *
 * It uses an object of class WiFiList, specified in a separate tab.
 * After creating the WiFIList object, you must call its init() function.
 * To scan/refresh the network list, use scan().
 * Once scanning is complete, the WiFIList object will call the sketch's wifiScanFinished() function.
 * This is a good opportunity to obtain (a copy of) the list of ScanResult objects through getNetworkList().  
 * 
 * The description of ScanResult objects (containing information about each network) can be found here
 * https://developer.android.com/reference/android/net/wifi/ScanResult.html
 *
 * WARNING: the WiFiList object isn't completely thread-safe, especially regarding concurrent modification of the "items" ArrayList
 *
 * WiFiList class code based on 
 * http://karanbalkar.com/2014/05/display-list-of-wifi-networks-in-android/
 * and special thanks to Julian Reil
 *
 * This sketch requires the permissions ACCESS_COARSE_LOCATION, ACCESS_WIFI_STATE and CHANGE_WIFI_STATE. 
 * The permission ACCESS_COARSE_LOCATION has to be explicitly requested to the user, by displaying a prompt.
 *
 * Tiago Martins 2017-2019
 * https://github.com/tms-martins/processing-androidExamples
 */
 
 
final static String permissionCoarseLocation = "android.permission.ACCESS_COARSE_LOCATION";

WiFiList wifiList;
ArrayList<ScanResult> wifiNetworks;

// we will calculate and store an adequate font size
int fontSize;

String message = "Tap to scan";


void setup() {
  orientation(PORTRAIT);
  
  requestPermission(permissionCoarseLocation);
  
  // create and initialize the WiFiList object
  wifiList = new WiFiList();
  wifiList.init();
  
  // get a list of WiFi networks
  // this list will be empty, but at least the variable wifiNetworks will have something valid, instead of null
  wifiNetworks = wifiList.getNetworkList();
  
  // calculate a font size (we will need to keep it in a variable for later use)
  fontSize = height/30;
  
  // set the text size and drawing parameters
  textSize(fontSize);
  textAlign(LEFT, TOP);
  noStroke();
}


void draw() {
  background(255);  
  
  fill(0);
  text(message, 10, 10);
  
  int currentHeight = 3 * fontSize;
  int barHeight = 5 + fontSize;
  
  // draw a bar representing the signal strengths for each network
  for(ScanResult item : wifiNetworks) {
    fill(200);
    float barWidth = map(item.level, -100, -10, 30, width);
    rect(0, currentHeight, barWidth, barHeight);
    fill(0);
    text(item.SSID + " : " + item.level, 10, currentHeight);
    currentHeight += barHeight;    
  }
}


// start scanning when the screen is tapped
void mousePressed() {
  if (!wifiList.isScanning()) {
    message = "Scanning...";
    wifiList.scan();
  }
}


// this function is called when the WiFiList object is done scanning
void wifiScanFinished() {
  message = "Scan Finished";
  wifiNetworks = wifiList.getNetworkList();
  for(ScanResult item : wifiNetworks) {
    printInfo(item);
  }
}


void printInfo(ScanResult item) {
  println("Name: " + item.SSID + " ---------------------");
  println("BSSID: " + item.BSSID);
  println("level: " + item.level);
  println("frequency: " + item.frequency);
}
