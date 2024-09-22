import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ratek/utils/get_id.dart';

class FirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Add a farmer to Firestore
  Future<void> addFarmer(Map<String, dynamic> farmer) async {
    final deviceId = await getDeviceId();
    await firestore
        .collection('farmers')
        .doc("${farmer['id']}-$deviceId")
        .set(farmer);
  }

  Future<void> addSale(Map<String, dynamic> sale) async {
    final deviceId = await getDeviceId();
    await firestore
        .collection('sales')
        .doc("${sale['id']}-$deviceId")
        .set(sale);
  }

  // Get all farmers from Firestore
  Future<List<Map<String, dynamic>>> getFarmers() async {
    QuerySnapshot snapshot = await firestore.collection('farmers').get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  // Delete a farmer from Firestore
  Future<void> deleteFarmer(String id) async {
    await firestore.collection('farmers').doc(id).delete();
  }

  // Update a farmer in Firestore
  Future<void> updateFarmer(Map<String, dynamic> farmer) async {
    await firestore.collection('farmers').doc(farmer['id']).update(farmer);
  }
}
