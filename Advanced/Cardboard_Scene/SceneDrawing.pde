FlyingObjectSystem objects;

void setupScene() {
  objects = new FlyingObjectSystem();
  objects.populate(100); 
}

void drawAxes(PGraphics g) {
  g.pushMatrix();
  g.noFill();
  g.stroke(255, 0, 0);
  g.strokeWeight(3);
  g.line(0, 0, 0, 10, 0, 0);
  g.stroke(0, 255, 0);
  g.line(0, 0, 0, 0, 10, 0);
  g.stroke(0, 0, 255);
  g.line(0, 0, 0, 0, 0, 10);
  g.popMatrix();
}

void drawObjects(PGraphics g) {
  objects.update();
  objects.draw(g);
}

class FlyingObjectSystem {
  ArrayList<FlyingObject> flyingObjects;
  
  int timePrev;
  int timeCurr;
  int timeDiff;
  
  FlyingObjectSystem() {
    flyingObjects = new ArrayList<FlyingObject>();
  }
  
  void randomize(FlyingObject obj) {
    obj.size = random(10, 30);
    obj.objColor = color(random(0, 255), random(0, 255), random(0, 255));
    obj.posX = random(-300, 300);
    obj.posY = random(-300, 300);
    obj.posZ = random(-300, -400);
  }
  
  void populate(int amount) {
    for (int i  = 0; i < amount; i++) {
      FlyingObject obj = new FlyingObject();
      randomize(obj);
      obj.posZ = random(-400, 400);
      flyingObjects.add(obj);
    }
  }
  
  void update() {
    timePrev = timeCurr;
    timeCurr = millis();
    timeDiff = timeCurr - timePrev;
    
    for (FlyingObject obj : flyingObjects) {
      obj.posZ += timeDiff * 0.05;
      if (obj.posZ > 400) {
        //flyingObjects.remove(obj);
        randomize(obj);
      }
    }
  }
  
  void draw(PGraphics g) {
    g.noStroke();
    for (FlyingObject obj : flyingObjects) {
      g.fill(obj.objColor);
      g.pushMatrix();
        g.translate(obj.posX, obj.posY, obj.posZ);
        g.translate(-obj.size/2, -obj.size/2);
        g.rect(0, 0, obj.size, obj.size);
      g.popMatrix();
    }
  }
}

class FlyingObject {
  float size;
  color objColor;
  
  float posX;
  float posY;
  float posZ;
  
  FlyingObject() {
    size = 10;
    objColor = color(128);
  }
}