import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ratek/utils/get_id.dart';

class FirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Add a farmer to Firestore
  Future<void> addFarmer(Map<String, dynamic> farmer) async {
    await firestore.collection('farmers').add(farmer);
  }

  static Future<List<Map<String, dynamic>>> getFullNames(String query) async {
    try {
      // Reference to the 'farmers' collection
      CollectionReference farmers =
          FirebaseFirestore.instance.collection('farmers');

      // Fetch documents where first_name, middle_name, or last_name contains the query
      QuerySnapshot querySnapshot = await farmers.get();

      // List to hold the full names
      List<Map<String, dynamic>> fullNames = [];

      // Iterate through the documents and check if the fields match the query
      for (var doc in querySnapshot.docs) {
        String firstName = doc['first_name'] ?? '';

        // Check if any of the fields contain the query string (substring match)
        if (firstName.contains(query)) {
          String fullName = firstName.trim();
          fullNames.add({'full_name': fullName});
        }
      }

      return fullNames;
    } catch (e) {
      debugPrint("Error getting farmer names: $e");
      return [];
    }
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

  static Future<int> getGroupCount() async {
    try {
      // Get the reference to the 'groups' collection
      CollectionReference groups =
          FirebaseFirestore.instance.collection('groups');
      // Get the snapshot of the collection and count the number of documents
      QuerySnapshot querySnapshot = await groups.get();
      // Return the count of documents
      return querySnapshot.size;
    } catch (e) {
      debugPrint("Error getting group count: $e");
      return 0; // Return 0 in case of error
    }
  }
}
