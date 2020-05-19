import java.util.Collections;
import java.util.Comparator;
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
    return new ArrayList<ScanResult>(networkList);
  }

  ArrayList<ScanResult> getNetworkListSortedBySignal() {
    while (bUpdatingList) {}
    ArrayList<ScanResult> sortedItems = new ArrayList<ScanResult>(networkList);
    Collections.sort(sortedItems, new Comparator<ScanResult>() {
      public int compare(ScanResult obj1, ScanResult obj2) {
        return obj2.level - obj1.level;
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
        List<ScanResult> scanResults = wifiManager.getScanResults();
        bUpdatingList =  true;
        networkList.clear();
        for (ScanResult item : scanResults) {
          networkList.add(item);
        }
        bUpdatingList = false;
        bScanning = false;
        Thread t = new Thread() {
          @Override
          public void run() {
            delay(20);
            wifiScanFinished();
          }
        };
        t.start();
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
