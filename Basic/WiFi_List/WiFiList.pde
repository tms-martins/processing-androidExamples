import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import android.content.Context;
import android.content.BroadcastReceiver;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.wifi.ScanResult;
import android.net.wifi.WifiManager;

class WiFiList {
  protected WifiManager wifiManager;
  protected List<ScanResult> scanList;
  protected ArrayList<WiFiListItem> items;
  protected boolean bScanning = false;

  WiFiList() {
    items = new ArrayList<WiFiListItem>();
  }
  
  boolean isScanning() {
    return bScanning;
  }
  
  ArrayList<WiFiListItem> getItems() {
    while (bScanning) {}
    return new ArrayList<WiFiListItem>(items);
  }
  
  ArrayList<WiFiListItem> getItemsSortedBySignal() {
    while (bScanning) {}
    ArrayList<WiFiListItem> sortedItems = new ArrayList<WiFiListItem>(items);
    Collections.sort(sortedItems, new Comparator<WiFiListItem>() {
      public int compare(WiFiListItem obj1, WiFiListItem obj2) {
        return obj2.signal - obj1.signal;
      }
    });
    return sortedItems;
  }

  void init() {
    wifiManager = (WifiManager)getActivity().getSystemService(Context.WIFI_SERVICE);
    
    IntentFilter filter = new IntentFilter();
    filter.addAction(WifiManager.SCAN_RESULTS_AVAILABLE_ACTION);
    
    getActivity().registerReceiver(new BroadcastReceiver() {
      public void onReceive(Context context, Intent intent) {
        println("WiFiList: scan finished");
        scanList = wifiManager.getScanResults();
        for (ScanResult networkDevice : scanList) {
          updateItem(networkDevice.SSID, networkDevice.level);
        }
        bScanning = false;
        Thread t = new Thread() {
          @Override
          public void run() {
            delay(50);
            wifiScanFinished();
          }
        };
        t.start();
      }
    }
    , filter);
  }
  
  void updateItem(String name, int signal) {
    for(WiFiListItem item : items) {
      if (item.name.equals(name))  {
        item.signal = signal;
        item.lastSeen = millis();
        println("[Updated] " + name + " : " + signal);
        return;
      }
    }
    items.add(new WiFiListItem(name, signal, millis()));
    println("[Added] " + name + " : " + signal);
  }
  
  void scan() {
    if (bScanning) {
      println("WiFiList: already scanning");
      return;
    }
    bScanning = true;
    println("WiFiList: starting scan");
    wifiManager.startScan();
  }
  
  void removeOld(int milliseconds) {
    while (bScanning) {}
    for (int i = items.size() -1; i >= 0; i--) {
      WiFiListItem item = items.get(i);
      float itemAge = millis() - item.lastSeen;
      if (itemAge >= milliseconds) {
        items.remove(item);
        println("[Removed] " + item.name + " (" + (int)itemAge + " msec. old)");
      }
    }
  }
}

class WiFiListItem {
  String name;
  int signal;
  float lastSeen;
  
  WiFiListItem(String name, int signal, int lastSeen) {
    this.name = name;
    this.signal = signal;
    this.lastSeen = lastSeen;
  }
}
