/*
 * This sketch scans for Bluetooth devices and displays a list of results, when the screen is tapped.
 *
 * The sketch uses the Ketai library by Daniel Sauter.
 * It is based on the example BluetoothCursors by Daniel Sauter/j.duran, 2012
 *
 * This sketch requires the permissions BLUETOOTH and BLUETOOTH_ADMIN
 *
 * Tiago Martins 2017
 * https://github.com/tms-martins/processing-androidExamples
 */

//required for BT enabling on startup
import android.content.Intent;
import android.os.Bundle;

import ketai.net.bluetooth.*;


KetaiBluetooth bt;

String  screenText = "Tap to scan";
boolean devicesUpdated = true;


void setup() {
  fullScreen(P2D);
  orientation(PORTRAIT);

  // start the Bluetooth object
  bt.start();
  
  // set the text size and drawing parameters
  textSize(displayDensity * 24);
  println(displayDensity);
  textAlign(LEFT, TOP);
  noStroke();
  fill(0);
}


void draw() {
  if (bt.isDiscovering()) {
    devicesUpdated = false;
  } else if (!devicesUpdated) {
    // if the bluetooth stopped scanning/discovering, update the devices list
    println("Updating device list");
    devicesUpdated = true;
    screenText = "";
    ArrayList<String> deviceNames = bt.getDiscoveredDeviceNames();
    for (String name : deviceNames) {
      screenText += name + "\n";
      println("Added " + name);
    }
    screenText += "... tap to scan again";
  }

  // clear the background and draw text on screen
  background(255);
  float x = displayDensity * 24;
  float y = 2 * x;
  text(screenText, x, y);
}


void mousePressed() {
  // if Bluetooth isn't scanning, start scanning
  if (!bt.isDiscovering()) {
    screenText = "Scanning...";
    bt.discoverDevices();
  }
}


// The following code is required to enable bluetooth at startup.
void onCreate(Bundle savedInstanceState) {
  bt = new KetaiBluetooth(this);
}


// The following code is also required to enable bluetooth at startup.
void onActivityResult(int requestCode, int resultCode, Intent data) {
  bt.onActivityResult(requestCode, resultCode, data);
}