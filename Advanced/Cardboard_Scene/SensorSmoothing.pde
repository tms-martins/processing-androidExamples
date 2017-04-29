// Smoothing the accelerometer and compass/orientation ===================================================

final static int ARRAY_LENGTH = 10;

int indexAccelZ = 0;
float averageAccelZ; 
float [] arrayAccelZ = new float[ARRAY_LENGTH];

void updateAccelZAverage() {
  arrayAccelZ[indexAccelZ++] = accelZ;
  if (indexAccelZ >= ARRAY_LENGTH) indexAccelZ = 0;
  float totalValue = 0;
  for (int i = 0; i < ARRAY_LENGTH; i++) {
    totalValue += arrayAccelZ[i];
  }
  averageAccelZ = totalValue/ARRAY_LENGTH;
}

int indexOrientX = 0;
float averageOrientX; 
float [] arrayOrientX = new float[ARRAY_LENGTH];

void updateOrientXAverage() {
  arrayOrientX[indexOrientX++] = orientX;
  if (indexOrientX >= ARRAY_LENGTH) indexOrientX = 0;
  float totalValue = 0;
  for (int i = 0; i < ARRAY_LENGTH; i++) {
    totalValue += arrayOrientX[i];
  }
  averageOrientX = totalValue/ARRAY_LENGTH;
}