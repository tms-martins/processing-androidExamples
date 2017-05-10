/*
 * This example includes a function to toggle (show/hide) the software keyboard 
 * and illustrates how to edit a string using the keyboard.
 *
 * IMPORTANT: for now, this sketch does not work well with autocomplete; you should turn it off.
 *
 * Pressing delete/backspace will delete one character; if none are left it will hide the keyboard.
 * Pressing return will hide the keyboard.
 *
 * In Android, you can also use the back arrow to close the keyboard. As this sketch doesn't explicitly
 * open or close the keyboard (just toggles its state), you may come to an inconsistent behaviour.
 *
 * The function is in a separate tab, so it may easily be copied to another sketch.
 *
 * Tiago Martins 2017
 * https://github.com/tms-martins/processing-androidExamples
 */

// the message to be edited and displayed on screen
String message = "nothing";


void setup() {
  size(displayWidth, displayHeight, P2D);
  orientation(PORTRAIT);
  
  // set the text size and drawing parameters
  textSize(height/30);
  textAlign(CENTER, TOP);
  fill(0);
  noStroke();
}


void draw() {
  background(255);
  text(message, 0, height/6, width, height);
}


void mousePressed() {
  toggleKeyboard();
}


void keyPressed() {
  if (key == CODED) {
    println("Pressed keycode " + (int) keyCode);

    // the user presses the "delete" key, delete the last letter
    // or close the keyboard, if there are no characters to delete
    if (keyCode == 67) {
      if (message.length() > 0) {
        message = message.substring(0, message.length()-1);
      }
      else {
        toggleKeyboard();
      }
    }
  }
  else {
    println("Pressed key " + (int) key);
    
    // if the user input a character, add it to the message;
    // otherwise if she pressed "return" close the keyboard
    if (isCharacterNumberOrSign(key)) {
      message += (char)key;
    }
    else if (key == 10) {
      toggleKeyboard();
    }
  }
}


// you are certainly welcome to add/remove according to your needs, or make a different version of this function
boolean isCharacterNumberOrSign(int keyPress) {
  if (keyPress >= 'a' && keyPress <= 'z') return true;
  if (keyPress >= 'A' && keyPress <= 'Z') return true;
  if (keyPress >= '0' && keyPress <= '9') return true;
  if (keyPress == ' ' || keyPress == '-' || keyPress == '_' || keyPress == '.' ||  keyPress == ',' || keyPress == ';' || keyPress == '?' || keyPress == '!' || keyPress == '\'') return true;    
  return false;
}