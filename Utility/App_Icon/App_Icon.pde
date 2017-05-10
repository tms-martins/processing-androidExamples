/* 
 * For your app to have its own custom icons, you should:
 * - create 36x36, 48x48, and 72x72 pixel icons
 * - save them as icon-36.png, icon-48.png, and icon-72.png, respectively
 * - place these files in the sketch folder 
 *
 * Tiago Martins 2016 
 * tms[dot]martins[at]gmail[dot]com
 */
 
void setup() {
  size(displayWidth, displayHeight, P2D);
  orientation(PORTRAIT);
  
  textSize(20);
  textAlign(CENTER, CENTER);
}

void draw() {
  background(0);
  fill(255);
  text("Hello World", 0, 0, width, height);
}