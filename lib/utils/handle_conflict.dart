import 'package:ratek/db/local.dart';
import 'package:ratek/db/remote.dart';

Future<void> handleConflicts() async {
  List<Map<String, dynamic>> localFarmers = await LocalDatabase.getFarmers();
  List<Map<String, dynamic>> remoteFarmers =
      await FirestoreService().getFarmers();

  for (var localFarmer in localFarmers) {
    var matchingRemoteFarmer = remoteFarmers.firstWhere(
      (remoteFarmer) => remoteFarmer['id'] == localFarmer['id'],
      orElse: () => {},
    );

    if (localFarmer['updatedAt'].isAfter(matchingRemoteFarmer['updatedAt'])) {
      // Local data is newer, so update Firestore
      await FirestoreService().updateFarmer(localFarmer);
    } else {
      // Remote data is newer, so update local SQLite
      await LocalDatabase.updateFarmer(matchingRemoteFarmer);
    }
  }
}
