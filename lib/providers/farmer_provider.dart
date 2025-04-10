import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ratek/models/farmer.dart';
import 'package:ratek/providers/firestore_provider.dart';

final farmersStreamProvider = StreamProvider<List<Farmer>>((ref) {
  final firestore = ref.watch(firestoreProvider);

  CollectionReference farmersCollection = firestore.collection("farmers");
  return farmersCollection.snapshots().map((querySnapshot) {
    List<Farmer> farmers = querySnapshot.docs
        .map<Farmer>((doc) => Farmer.fromDocument(doc))
        .toList();

    // Sort the list by first name
    farmers.sort((a, b) => a.firstName.compareTo(b.firstName));

    return farmers;
  });
});

final countProvider = FutureProvider<int>((ref) async {
  final firestore = ref.watch(firestoreProvider);
  CollectionReference farmersCollection = firestore.collection("farmers");
  return await farmersCollection.snapshots().length;
});

final farmerfutureProvider = FutureProvider<List<Farmer>>((ref) async {
  final firestore = ref.watch(firestoreProvider);
  CollectionReference farmersCollection = firestore.collection("farmers");
  QuerySnapshot snapshot = await farmersCollection.get();
  return snapshot.docs.map<Farmer>((doc) => Farmer.fromDocument(doc)).toList();
});

final farmerProvider = StateNotifierProvider<DeductionNotifier, List<Farmer>>(
  (ref) => DeductionNotifier(),
);

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class DeductionNotifier extends StateNotifier<List<Farmer>> {
  DeductionNotifier() : super([]) {
    _loadFarmers(); // Load deductions from Firestore when initializing
  }

  // Load deductions from Firestore
  Future<void> _loadFarmers() async {
    try {
      final querySnapshot = await _firestore.collection('farmers').get();
      List<Farmer> farmers = querySnapshot.docs
          .map<Farmer>((doc) => Farmer.fromDocument(doc))
          .toList();
      state = farmers;
    } catch (e) {
      debugPrint("Error loading farmers from Firestore: $e");
    }
  }

  // Add a farmer to Firestore and update state
  Future<void> addFarmer(Farmer farmer) async {
    try {
      // Add deduction to Firestore
      final docRef = await _firestore.collection('farmers').add(farmer.toMap());
      // Add the deduction to the local state
      final newFarmer = farmer.copyWith(id: docRef.id);
      state = [...state, newFarmer];
    } catch (e) {
      debugPrint("Error adding farmer: $e");
    }
  }

  // Delete a farmer from Firestore and update state
  Future<void> deleteFarmer(String id) async {
    try {
      // Delete deduction from Firestore
      await _firestore.collection('farmers').doc(id).delete();

      // Remove the deduction from the local state
      state = state.where((farmer) => farmer.id != id).toList();
    } catch (e) {
      debugPrint("Error deleting farmer: $e");
    }
  }

  // Update a farmer in Firestore and update state
  Future<void> updateDeduction(Farmer updatedFarmer) async {
    try {
      // Update farmer in Firestore
      await _firestore
          .collection('farmers')
          .doc(updatedFarmer.id)
          .update(updatedFarmer.toMap());

      // Update the farmer in the local state
      state = [
        for (final sale in state)
          if (sale.id == updatedFarmer.id) updatedFarmer else sale
      ];
    } catch (e) {
      debugPrint("Error updating farmer: $e");
    }
  }
}

final searchQueryProvider = StateProvider<String>((ref) => "");
final farmerQueryProvider = StateProvider<String>((ref) => "");
