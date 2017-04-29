import java.util.List;
import java.lang.CharSequence;
import android.content.Context;
import android.content.BroadcastReceiver;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.wifi.ScanResult;
import android.net.wifi.WifiManager;

class WiFiList {
  protected WifiManager wifiManager;
  protected ArrayList<ScanResult> networkList;
  protected boolean bScanning = false;
  protected boolean bUpdatingList = false;

  WiFiList() {
    networkList = new ArrayList<ScanResult>();
  }
  
  boolean isScanning() {
    return bScanning;
  }
  
  ArrayList<ScanResult> getNetworkList() {
    while (bUpdatingList) {}
    return networkList;
  }

  void init() {
    wifiManager = (WifiManager)getActivity().getSystemService(Context.WIFI_SERVICE);
    
    IntentFilter filter = new IntentFilter();
    filter.addAction(WifiManager.SCAN_RESULTS_AVAILABLE_ACTION);
    
    getActivity().registerReceiver(new BroadcastReceiver() {
      public void onReceive(Context context, Intent intent) {
        println("WiFiList: scan finished");
        List<ScanResult> scanResults = wifiManager.getScanResults();
        bUpdatingList =  true;
        networkList.clear();
        for (ScanResult item : scanResults) {
          networkList.add(item);
        }
        bUpdatingList =  false;
        bScanning = false;
        wifiScanFinished();
      }
    }
    , filter);
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