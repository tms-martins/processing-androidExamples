import android.content.*;
import android.telephony.*;
import android.os.Bundle;

public class SmsReceiver extends BroadcastReceiver {
  private ArrayList<SmsMessage> smsList;
  private boolean smsReceived;

  protected final String ACTION = "android.provider.Telephony.SMS_RECEIVED";

  SmsReceiver() {
    smsList = new ArrayList<SmsMessage>();
    smsReceived = false;
  }

  void register() {
    IntentFilter filter = new IntentFilter();
    filter.addAction(ACTION);
    getActivity().registerReceiver(this, filter);
  }

  void unregister() {
    getActivity().unregisterReceiver(this);
  }
  
   boolean hasNewMessage() {
    return smsReceived;
  }
  
  SmsMessage getNewMessage() {
    if (!smsReceived) return null;
    
    smsReceived = false;
    return smsList.get(smsList.size() -1);
  }
  
  ArrayList<SmsMessage> getAllMessages() {
    return new ArrayList<SmsMessage>(smsList);
  }
  
  void clearMessages() {
    smsReceived = false;
    smsList.clear();
  }

  public void onReceive(Context context, Intent intent) {
    if (intent.getAction().equals(ACTION)) {
      Bundle bundle = intent.getExtras();

      if (bundle != null) {
        Object[] pdusObj = (Object[]) bundle.get("pdus");
        SmsMessage[] messages = new SmsMessage[pdusObj.length];

        // getting SMS information from Pdu.
        for (int i = 0; i < pdusObj.length; i++) {
          smsList.add(SmsMessage.createFromPdu((byte[]) pdusObj[i]));
          smsReceived = true;
        }
      }
    }
  }
}