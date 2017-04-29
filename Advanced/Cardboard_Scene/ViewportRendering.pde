static final boolean RENDER_STEREO = true;

int eyeDistanceOffset = 15;
int viewportBackgroundColor = 200;

float eyeX = 0;
float eyeY = 0;
float eyeZ = 0;
float panX = 0;
float panY = 0;
PGraphics leftViewport; //left viewport
PGraphics rightViewport; //right viewport
PGraphics singleViewport; //single viewport (for non-stereo rendering)

void setupViewports() {
  if (RENDER_STEREO) {
    leftViewport  = createGraphics(displayWidth/2, displayHeight, P3D); //size of left viewport
    rightViewport = createGraphics(displayWidth/2, displayHeight, P3D);
  }
  else {
    singleViewport  = createGraphics(displayWidth, displayHeight, P3D); //size of single viewport
  }
}

void drawViewports() {
  if (RENDER_STEREO) {
    renderViewport(leftViewport, eyeX, eyeY, panX, panY, -eyeDistanceOffset);
    renderViewport(rightViewport, eyeX, eyeY, panX, panY, eyeDistanceOffset);
    image(leftViewport, 0, 0);
    image(rightViewport, displayWidth/2, 0);
  }
  else {
    renderViewport(singleViewport, eyeX, eyeY, panX, panY, 0);
    image(singleViewport, 0, 0);
  }
}

void renderViewport(PGraphics g, float x, float y, float px, float py, int eyeOffset) {
  g.beginDraw();
  g.background(viewportBackgroundColor);
  g.lights();
  g.pushMatrix();
  g.camera(x+eyeOffset, y, 300, px, py, 0, 0.0, 1.0, 0.0);
  drawScene(g);
  g.popMatrix();
  g.endDraw();
}