/*
 * This sketch works as a basic musical instrument with a pentatonic scale.
 * It uses the included PAAudioPlayer class to load and play audio files from the sketch's data folder.
 *
 * By touching a white area on the screen, the corresponding note will be played.
 * By touching the pink area, a random note will be played.
 *
 * Tiago Martins 2017-2020
 * https://github.com/tms-martins/processing-androidExamples
 */

// create an array of audio players to hold 5 notes
int numNotes = 5;
PAAudioPlayer [] notes = new PAAudioPlayer [numNotes];

// the height of a note's touch area on screen
float touchAreaSize;

void setup() {
  fullScreen();
  orientation(PORTRAIT);
  
  // we add 1 to the number of notes because we will have a sixth "random" note
  touchAreaSize = displayHeight/(numNotes +1);

  // create the audio player objects 
  for (int i = 0; i < numNotes; i++) notes[i] = new PAAudioPlayer(); 
  
  // load a file into each audio player
  notes[0].loadFile(this, "5A.wav");
  notes[1].loadFile(this, "4G.wav");
  notes[2].loadFile(this, "4E.wav");
  notes[3].loadFile(this, "4D.wav");
  notes[4].loadFile(this, "4C.wav");
}

void draw() {
  background(255);
  noFill();
  stroke(0);
  
  float currentHeight = touchAreaSize;
  
  // draw the separators for the areas that trigger notes
  for (int i = 0; i < numNotes; i++) {
    line(0, currentHeight, width, currentHeight);
    currentHeight += touchAreaSize;
  }
  
  // draw the area that triggers a random note
  fill(#FF79C3);
  noStroke();
  rect(0, touchAreaSize * numNotes, width, touchAreaSize);
}

void mousePressed() {
  int noteIndex = floor(mouseY/touchAreaSize);
  
  // check if the random note is triggered, and generate a random index
  if (noteIndex >= numNotes) {
    noteIndex = (int)random(numNotes);
  }
  
  println("Playing index " + noteIndex);
  notes[noteIndex].play();
}
