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
        wifiScanFinished();
      }
    }
    , filter);
  }
  
  void updateItem(String name, int level) {
    for(WiFiListItem item : items) {
      if (item.name.equals(name))  {
        item.level = level;
        println("[Updated] " + name + " : " + level);
        return;
      }
    }
    items.add(new WiFiListItem(name, level));
    println("[Added] " + name + " : " + level);
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
}

class WiFiListItem {
  String name;
  int level;
  
  WiFiListItem(String name, int level) {
    this.name = name;
    this.level = level;
  }
}