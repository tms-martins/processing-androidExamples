/* 
 * For your app to have its own custom icons, you should:
 * - create icons in PNG format in the following sizes: 36x36, 48x48, 72x72, 96x96, 144x144 and 192x192
 * - name them icon-36.png, icon-48.png, icon-72.png, icon-96.png, icon-144.png and icon-192.png
 * - place these files in the sketch folder 
 *
 * Tiago Martins 2016/2018 
 * https://github.com/tms-martins/processing-androidExamples
 */
 
void setup() {
  fullScreen();
  orientation(PORTRAIT);
  
  textSize(height/20);
  textAlign(CENTER, CENTER);
}

void draw() {
  background(0);
  fill(255);
  text("Hello World", 0, 0, width, height);
}