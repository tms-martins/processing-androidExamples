/*
 * This sketch provides an example of basic texturing for AR-tracked surfaces.
 * Each surface, represented by an ARTrackable object, is overlaid with a spiderweb texture.
 *
 * You can tap a tracked surface to briefly change its color, applying a red tint to the texture.
 *
 * This example is based on the examples by Andre Colubri. 
 * Be sure to check out Examples > Libraries > AR
 *
 * Tiago Martins 2020
 * https://github.com/tms-martins/processing-androidExamples
*/

import processing.ar.*;

ARTracker tracker;
PImage imgSpiderweb;


void setup() {
  fullScreen(AR);
  tracker = new ARTracker(this);
  tracker.start();
   
  imgSpiderweb = loadImage("spiderweb.png");
  textureMode(NORMAL);
  noStroke();
}


void draw() {
  lights();
  
  for (int i = 0; i < tracker.count(); i++) {
    ARTrackable trackable = tracker.get(i);
    pushMatrix();
    
    // Apply the trackable's transform,
    // from now on we are drawing relative to the center of the plane
    trackable.transform();  
    
    // if the user is selecting this plane on the screen, tint it red
    if (mousePressed && trackable.isSelected(mouseX, mouseY)) {
      fill(255, 0, 0, 150);
    } else {
      fill(255, 150);
    }
    
    // draw the spiderweb texture as a plane of the trackable's length
    drawTexturedPlane(imgSpiderweb, trackable.lengthX(), trackable.lengthZ());
    popMatrix();  
  }    
}


// Utility function to draw a textured plane of length
// lx by lz, centered on the origin (0, 0)
void drawTexturedPlane(PImage texture, float lengthX, float lengthZ) {
  beginShape(QUADS);
  texture(texture);  
  vertex(-lengthX/2, 0, -lengthZ/2,  0, 0);
  vertex(-lengthX/2, 0, +lengthZ/2,  1, 0);
  vertex(+lengthX/2, 0, +lengthZ/2,  1, 1);
  vertex(+lengthX/2, 0, -lengthZ/2,  0, 1);
  endShape();  
}
