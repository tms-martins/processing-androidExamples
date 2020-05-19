/*
 * This example scans for and displays WiFi networks and their signal strengths.
 *
 * It uses an object of class WiFiList, specified in a separate tab.
 * After creating the WiFIList object, you must call its init() function.
 * To scan/refresh the network list, use scan().
 * Once scanning is complete, the WiFIList object will call the sketch's wifiScanFinished() function.
 * This is a good opportunity to obtain the list of WiFi networks through getItemsSortedBySignal().
 * Before that however, you may want to remove stale items (that haven't been see for a while) using removeOld().
 *
 * WiFiList class code based on
 * http://karanbalkar.com/2014/05/display-list-of-wifi-networks-in-android/
 * and special thanks to Julian Reil
 *
 * This sketch requires the permissions ACCESS_COARSE_LOCATION, ACCESS_WIFI_STATE and CHANGE_WIFI_STATE.
 * The permission ACCESS_COARSE_LOCATION has to be explicitly requested to the user, by displaying a prompt.
 * 
 * Tiago Martins 2017-2020
 * https://github.com/tms-martins/processing-androidExamples
 */


final static String permissionCoarseLocation = "android.permission.ACCESS_COARSE_LOCATION";

WiFiList wifiList;
ArrayList<WiFiListItem> wifiNetworks;

// we will calculate and store an adequate font size
int fontSize;

String message = "Tap to scan";

void setup() {
  fullScreen();
  orientation(PORTRAIT);

  requestPermission(permissionCoarseLocation);

  // create and initialize the WiFiList object
  wifiList = new WiFiList();
  wifiList.init();

  // get a list of WiFi networks
  // this list will be empty, but at least the variable wifiNetworks will have something valid, instead of null
  wifiNetworks = wifiList.getItems();

  // calculate a font size (we will need to keep it in a variable for later use)
  fontSize = (int)(18 * displayDensity);

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
  for(WiFiListItem item : wifiNetworks) {
    fill(160);
    float barWidth = map(item.signal, -100, -10, 30, width);
    rect(0, currentHeight, barWidth, barHeight);
    fill(0);
    text(item.name + " : " + item.signal, 10, currentHeight);
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
  message = "Scan finished\n(tap to scan again)";
  // remove items that haven't been seen for 20 seconds or more
  wifiList.removeOld(20000);
  // retrieve the list of wifi networks, sorted by signal strength
  wifiNetworks = wifiList.getItemsSortedBySignal();
  // you could also just retrieve the unsorted list like this
  // wifiList.getItems();
}
