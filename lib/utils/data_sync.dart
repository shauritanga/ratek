import 'package:ratek/db/local.dart';
import 'package:ratek/db/remote.dart';
import 'package:ratek/utils/check_netowrk.dart';

void syncData() async {
  if (await isOnline()) {
    // 1. Get local data from SQLite
    List<Map<String, dynamic>> unsyncedFarmers =
        await LocalDatabase.getUnsyncedFarmers();
    List<Map<String, dynamic>> unsyncedSales =
        await LocalDatabase.getUnsyncedSales();

    // 2. Push local data to Firestore
    for (var farmer in unsyncedFarmers) {
      await FirestoreService().addFarmer(farmer);
      await LocalDatabase.syncFarmer(farmer);
    }

    for (var sale in unsyncedSales) {
      await FirestoreService().addSale(sale);
      await LocalDatabase.syncSale(sale);
    }

    print('Data synced successfully');
  } else {
    print('You are offline. Data will be synced when online.');
  }
}
