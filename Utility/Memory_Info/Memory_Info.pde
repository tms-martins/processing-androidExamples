/*
 * This sketch retrieves the memory used by the app, as well as the maximum amount of memory which can be used.
 *
 * Android apps have a limit on how much memory they can take up. The exact number is device dependent.
 *
 * This amount of memory can be extended by adding
 *   android:largeHeap="true" 
 * to the "application" tag/element in the Adroid manifest file 
 * (generated in the sketch's folder after the first time you compiled/ran the sketch)
 * Large apps are usually divided into parts, but in Processing we are "stuck" to a monolithic app.
 *
 * The utility functions for memory querying are in a separate tab, 
 * so they may easily be copied onto another sketch.
 *
 * Tiago Martins 2017
 * https://github.com/tms-martins/processing-androidExamples
 */


String memoryInfoString = "nothing yet...";


void setup() {
  orientation(PORTRAIT);
  fullScreen(P2D);
  
  // obtain memory info
  int usedMemory = getUsedMemorySizeMB();
  int maxMemory = getMaxMemorySizeMB();
  int maxLargeMemory = getMaxLargeMemorySizeMB();
 
  // compose a written report, which will be printed to the console and drawn on screen 
  memoryInfoString = "App is using " + usedMemory + " MB (already)\n";
  memoryInfoString += "of a maximum of " + maxMemory + " MB\n";
  memoryInfoString += "which can be extended to " + maxLargeMemory + " MB\n";
  println(memoryInfoString);
  
  // set the text size and drawing parameters
  textSize(displayDensity * 30);
  textAlign(CENTER, CENTER);
  fill(0);
  noStroke();
}

void draw() {
  background(255);
  text(memoryInfoString, 0, 0, width, height);
}