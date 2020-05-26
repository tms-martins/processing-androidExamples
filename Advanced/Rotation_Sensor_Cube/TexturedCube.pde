/*
 * based on:
 * https://processing.org/examples/texturecube.html
 */
 
PImage [] cubeFaceImages = new PImage [6];

void loadCubeFaceImages() {
  for (int i = 0; i < 6; i++) {
    String filename = "DieFace0" + (i + 1) + ".png";
    println("Loading: " + filename);
    cubeFaceImages[i] = loadImage(filename);
  }
}

void drawTexturedCube() {
  textureMode(NORMAL);
  noStroke();
  
  beginShape();
  texture(cubeFaceImages[0]);
  // +Z "front" face
  vertex(-1, -1,  1, 0, 0);
  vertex( 1, -1,  1, 1, 0);
  vertex( 1,  1,  1, 1, 1);
  vertex(-1,  1,  1, 0, 1);
  endShape();
  
  beginShape();
  texture(cubeFaceImages[1]);
  // -Z "back" face
  vertex( 1, -1, -1, 0, 0);
  vertex(-1, -1, -1, 1, 0);
  vertex(-1,  1, -1, 1, 1);
  vertex( 1,  1, -1, 0, 1);
  endShape();
  
  beginShape();
  texture(cubeFaceImages[2]);
  // +Y "bottom" face
  vertex(-1,  1,  1, 0, 0);
  vertex( 1,  1,  1, 1, 0);
  vertex( 1,  1, -1, 1, 1);
  vertex(-1,  1, -1, 0, 1);
  endShape();
  
  beginShape();
  texture(cubeFaceImages[3]);
  // -Y "top" face
  vertex(-1, -1, -1, 0, 0);
  vertex( 1, -1, -1, 1, 0);
  vertex( 1, -1,  1, 1, 1);
  vertex(-1, -1,  1, 0, 1);
  endShape();
  
  beginShape();
  texture(cubeFaceImages[4]);
  // +X "right" face
  vertex( 1, -1,  1, 0, 0);
  vertex( 1, -1, -1, 1, 0);
  vertex( 1,  1, -1, 1, 1);
  vertex( 1,  1,  1, 0, 1);
  endShape();
  
  beginShape();
  texture(cubeFaceImages[5]);
  // -X "left" face
  vertex(-1, -1, -1, 0, 0);
  vertex(-1, -1,  1, 1, 0);
  vertex(-1,  1,  1, 1, 1);
  vertex(-1,  1, -1, 0, 1);
  endShape();
}
