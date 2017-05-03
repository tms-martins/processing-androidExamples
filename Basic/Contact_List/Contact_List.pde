/*
 * Retrieves a list of contacts (names) and phone numbers for each contact, and prints the mout on the console.
 *
 * Each ContactItem has a "name" and an ArrayList of Strings "phoneList" storing the phone numbers.
 *
 * Based on the example from
 * http://app-solut.com/blog/2011/03/working-with-the-contactscontract-to-query-contacts-in-android/
 * Special thanks to Michael Holzknecht.
 *
 * This sketch requires the permission READ_CONTACTS.
 *
 * Tiago Martins 2017
 * https://github.com/tms-martins/processing-androidExamples
 */

ArrayList <ContactItem> contacts = new ArrayList<ContactItem>();
boolean permissionDenied;

void setup() {
  fullScreen(P2D);
  orientation(PORTRAIT);

  requestPermission("android.permission.READ_CONTACTS", "handleRequest");
  
  // set the text size and drawing parameters
  textSize(displayDensity * 24);
  textAlign(CENTER, CENTER);
  fill(0);
  noStroke();
}


void draw() {
  background(255);
  if (permissionDenied) {
    text("The user did not give permission to read contacts", 0, 0, width, height);
  } else {
    text("Found " + contacts.size() + " contacts", 0, 0, width, height);
  }  
}