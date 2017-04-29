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

ArrayList <ContactItem> contacts;


void setup() {
  orientation(PORTRAIT);
  size(displayWidth, displayHeight, P2D);
  
  // initialize the array list and read contacts into it
  contacts = new ArrayList<ContactItem>();
  readContacts(contacts);

  // print all contacts to the console 
  println("CONTACTS ===================");
  for (ContactItem contact : contacts) {
    println(contact.name);
    for (String phoneNumber : contact.phoneList) {
      println("  " + phoneNumber);
    }
  }
  println("END CONTACTS ===============");
  
  // set the text size and drawing parameters
  textSize(height/30);
  textAlign(CENTER, CENTER);
  fill(0);
  noStroke();
}


void draw() {
  background(255);
  text("Found " + contacts.size() + " contacts", 0, 0, width, height);
}