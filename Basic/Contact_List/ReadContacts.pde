import android.database.Cursor;
import android.provider.Contacts.*;
import android.provider.ContactsContract.*;
import android.provider.ContactsContract.CommonDataKinds.Phone;

void readContacts(ArrayList<ContactItem> contactsList) {
  String displayName = "<none>"; 
  String phoneNumber = "<none>"; 

  // ----------------- get the contact ID ----------------------------
  String[] projection = new String[] { RawContacts.CONTACT_ID, RawContacts.DELETED }; // which fields should be searched in the database
  Cursor rawContacts = getActivity().getContentResolver().query(RawContacts.CONTENT_URI, projection, null, null, null); // set the cursor and make the query

  int contactIdColumnIndex = rawContacts.getColumnIndex(RawContacts.CONTACT_ID);
  int deletedColumnIndex = rawContacts.getColumnIndex(RawContacts.DELETED);
  if (rawContacts.moveToFirst()) { // set the cursor to the first item of the list
    while (!rawContacts.isAfterLast()) {  
      int contactId = rawContacts.getInt(contactIdColumnIndex); // get the contactID
      boolean deleted = (rawContacts.getInt(deletedColumnIndex) == 1); // check if the contact was deleted
      if (!deleted) {

        // make a new query in the phonenumbers table
        // select the entry with the id

        // ----------------- get the name ----------------------------
        String[] projection_displayName = new String[] {Contacts.DISPLAY_NAME  };
        final Cursor contact = getActivity().getContentResolver().query(Contacts.CONTENT_URI, projection_displayName, Contacts._ID + "=?", new String[]{String.valueOf(contactId)}, null);
        if (contact.moveToFirst()) {
          displayName = contact.getString( contact.getColumnIndex(Contacts.DISPLAY_NAME));
        }
        contact.close();
        // ----------------- get the number ----------------------------
        String[] projection_number = new String[] {Phone.NUMBER, Phone.TYPE};
        Cursor phone = getActivity().getContentResolver().query(Phone.CONTENT_URI, projection_number, Data.CONTACT_ID + "=?", new String[]{String.valueOf(contactId)}, null);
        if (phone.moveToFirst()) {
          int contactNumberColumnIndex = phone.getColumnIndex(Phone.NUMBER);
          int contactTypeColumnIndex = phone.getColumnIndex(Phone.TYPE);
          while (!phone.isAfterLast()) {
            phoneNumber = phone.getString(contactNumberColumnIndex);
            int type = phone.getInt(contactTypeColumnIndex);
            int typeLabelResource = Phone.getTypeLabelResource(type);
            boolean contactExists = false;
            for (ContactItem item : contactsList) {
              if (item.name == displayName) {
                item.phoneList.add(phoneNumber);
                contactExists = true;
                break;
              }
            }
            if (!contactExists) {
              contactsList.add(new ContactItem(displayName, phoneNumber));
            }
            phone.moveToNext();
          }
        }
        phone.close();
        // ----------------------
      }
      rawContacts.moveToNext();      // move to the next entry
    }
  }
  rawContacts.close();
}




// --------- class --------------

class ContactItem {
  String name;
  ArrayList<String> phoneList;

  ContactItem() {
    phoneList = new ArrayList<String>();
  }

  ContactItem(String name, String phone) {
    this.name = name;
    phoneList = new ArrayList<String>();
    phoneList.add(phone);
  }

  String toString() {
    String result = name + ": ";
    for (String phoneNumber : phoneList) {
      result += "<" + phoneNumber + "> ";
    }
    return result;
  }
}