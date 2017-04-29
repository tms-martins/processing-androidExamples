import java.util.List;
import java.util.Iterator;
import android.content.Context;
import android.content.BroadcastReceiver;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.wifi.ScanResult;
import android.net.wifi.WifiManager;

/*
  USAGE:

  WiFiScanner scanner = new WiFiScanner();
  scaner.init();

  scanner.scan();

  void wifiScanFinished() {
    ArrayList<WiFiListItem> results = scanner.getItems();
  }
  
*/

class WiFiScanner {
  protected WifiManager wifiManager;
  protected List<ScanResult> scanList;
  protected ArrayList<WiFiListItem> items;
  protected boolean bScanning = false;

  WiFiScanner() {
    items = new ArrayList<WiFiListItem>();
  }
  
  void init() {
    wifiManager = (WifiManager)getActivity().getSystemService(Context.WIFI_SERVICE);

    IntentFilter filter = new IntentFilter();
    filter.addAction(WifiManager.SCAN_RESULTS_AVAILABLE_ACTION);

    getActivity().registerReceiver(new BroadcastReceiver() {
      public void onReceive(Context context, Intent intent) {
        println("WiFiScanner: scan finished");
        scanList = wifiManager.getScanResults();
        //items.clear();
        setItemsUpdated(false);
        for (ScanResult networkDevice : scanList) {
          updateItem(networkDevice.SSID, networkDevice.level);
        }
        clearStaleItems();
        bScanning = false;
        wifiScanFinished();
      }
    }
    , filter);
  }
  
  void scan() {
    if (bScanning) {
      println("WiFiScanner: already scanning");
      return;
    }
    bScanning = true;
    println("WiFiScanner: starting scan");
    wifiManager.startScan();
  }

  boolean isScanning() {
    return bScanning;
  }

  ArrayList<WiFiListItem> getItems() {
    while (bScanning) {
    }
    return new ArrayList<WiFiListItem>(items);
  }

  void setItemsUpdated(boolean value) {
    for (WiFiListItem item : items) {
      item.updated = value;
    }
  }

  void clearStaleItems() {
    Iterator<WiFiListItem> itemsIterator = items.iterator();
    while (itemsIterator.hasNext()) {
      WiFiListItem item = itemsIterator.next(); // must be called before you can call i.remove()
      if (!item.updated) { 
        println("[Removed] " + item.name);
        itemsIterator.remove();
      }
    }
  }

  void updateItem(String name, int level) {
    for (WiFiListItem item : items) {
      if (item.name.equals(name)) {
        item.level = level;
        item.updated = true;
        println("[Updated] " + name + " : " + level);
        return;
      }
    }
    WiFiListItem newItem = new WiFiListItem(name, level);
    newItem.updated = true;
    items.add(newItem);
    println("[Added] " + name + " : " + level);
  }
}

class WiFiListItem {
  String name;
  int level;
  boolean updated = false;

  WiFiListItem(String name, int level) {
    this.name = name;
    this.level = level;
  }
}