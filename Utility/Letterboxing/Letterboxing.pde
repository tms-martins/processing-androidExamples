/*
 * This sketch provides an example of how to draw letterboxed elements, i.e.
 * scaling them to the desired area without changing their aspect ratio.
 *
 * You can tap and drag, or change the device's orientation while 
 * the sketch is running to see the results.
 *
 * Letterboxing is done with the help of a LetterboxParams object, 
 * which calculates and stores the parameters for letterboxing (offset and scale).
 * Before drawing the letterboxed element, first translate and then scale the renderer
 * using the parameters provided by the LetterboxParams object.
 *
 * In this way you can letterbox basically anything, provided it is anchored by 
 * its corner or its center - as in imageMode(CORNER) or imageMode(CENTER).
 * - when anchored by CORNER, translate by offsetCornerX and Y
 * - when anchored by CENTER, translate by offsetCenterX and Y
 *
 * Tiago Martins 2020
 * https://github.com/tms-martins/processing-androidExamples
*/


PImage sampleImage;
float circleSize = 100;

LetterboxParams imageParams;

float areaX, areaY, areaW, areaH;

void setup() {
  fullScreen();
  sampleImage = loadImage("full-house.jpg");
  
  // let's start by using the whole screen for letterboxing
  areaX = areaY = 0;
  areaW = width;
  areaH = height;
  
  imageParams   = new LetterboxParams(sampleImage.width, sampleImage.height, areaW, areaH);
}

void draw() {
  background(0);
  
  // draw the letterboxed image
  pushMatrix();
  translate(areaX, areaY);
  translate(imageParams.offsetCornerX, imageParams.offsetCornerY);
  // if we had imageMode(CENTER) we would instead use
  // translate(imageParams.offsetCenterX, imageParams.offsetCenterY);
  scale(imageParams.scale);
  image(sampleImage, 0, 0);
  popMatrix();
  
  // draw the letterboxing area
  noFill();
  stroke(255, 0, 255);
  rect(areaX, areaY, areaW, areaH);
}


void mousePressed() {
  areaX = mouseX;
  areaY = mouseY;
  areaW = 0;
  areaH = 0;
  imageParams.calculate(sampleImage.width, sampleImage.height, areaW, areaH);
}

void mouseDragged() {
  float dX = mouseX - pmouseX;
  float dY = mouseY - pmouseY;
  areaW += dX;
  areaH += dY;
  imageParams.calculate(sampleImage.width, sampleImage.height, areaW, areaH);
}

void mouseReleased() {
  areaW = mouseX - areaX;
  areaH = mouseY - areaY;
  imageParams.calculate(sampleImage.width, sampleImage.height, areaW, areaH);
}


// utility class to calculate and store letterboxing parameters for a 2D element
class LetterboxParams {
  float scale;
  float offsetCornerX;
  float offsetCornerY;
  float offsetCenterX;
  float offsetCenterY;
  
  LetterboxParams () {
  }
  
  LetterboxParams (float elementW, float elementH, float displayAreaW, float displayAreaH) {
    calculate(elementW, elementH, displayAreaW, displayAreaH);
  }
  
  void calculate (float elementW, float elementH, float displayAreaW, float displayAreaH) {
    float scaleX = displayAreaW / elementW;
    float scaleY = displayAreaH / elementH;
    scale = min(abs(scaleX), abs(scaleY));
    offsetCornerX = (displayAreaW - (elementW * scale)) / 2.0;
    offsetCornerY = (displayAreaH - (elementH * scale)) / 2.0;
    offsetCenterX = displayAreaW/2.0;
    offsetCenterY = displayAreaH/2.0;
  }
}
