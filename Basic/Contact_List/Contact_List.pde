/*
 * Retrieves a list of contacts (names) and phone numbers for each contact, and prints them out on the console.
 *
 * The list contains contact information as ContactItem objects. 
 * Each ContactItem has a "name" and an ArrayList of Strings "phoneList" storing the phone numbers.
 *
 * Based on the example from
 * http://app-solut.com/blog/2011/03/working-with-the-contactscontract-to-query-contacts-in-android/
 * Special thanks to Michael Holzknecht.
 *
 * This sketch requires the permission READ_CONTACTS.
 * The permission READ_CONTACTS has to be explicitly requested to the user, by displaying a prompt.
 *
 * Tiago Martins 2017-2020
 * https://github.com/tms-martins/processing-androidExamples
 */

final static String permissionReadContacts = "android.permission.READ_CONTACTS";

ArrayList <ContactItem> contacts;


void setup() {
  fullScreen();
  orientation(PORTRAIT);
  
  // initialize the array list and read contacts into it
  contacts = new ArrayList<ContactItem>();
  
  // The app needs to explicitly request permission to read contacts.
  // If the permission hasn't been previously granted, prompt the user and afterwards call permissionContactsGranted().
  // Otherwise, the app jumps straight to permissionContactsGranted() with a value of "true"
  requestPermission(permissionReadContacts, "permissionContactsGranted");
  
  // set the text size and drawing parameters
  textSize(24 * displayDensity);
  textAlign(CENTER, CENTER);
  fill(0);
  noStroke();
}


void draw() {
  background(255);
  if (!hasPermission(permissionReadContacts)) {
    text("You need to grant the app\npermission to read contacts!", 10, 10, width-20, height-20);
  }
  else {
    text("Found " + contacts.size() + " contacts.\nCheck the Processing console for the full list.", 10, 10, width-20, height-20);
  }
}


void permissionContactsGranted(boolean granted) {
  if (!granted) {
    println("ERROR: you need to grant the app permission to read contacts.");
    return;
  }
  
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
}
