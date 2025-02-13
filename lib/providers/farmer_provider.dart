import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ratek/models/farmer.dart';
import 'package:ratek/providers/firestore_provider.dart';

final farmersStreamProvider = StreamProvider<List<Farmer>>((ref) {
  final firestore = ref.watch(firestoreProvider);

  CollectionReference farmersCollection = firestore.collection("farmers");
  return farmersCollection.snapshots().map((querySnapshot) {
    return querySnapshot.docs
        .map<Farmer>((doc) => Farmer.fromDocument(doc))
        .toList();
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
  return snapshot.docs
      .map((doc) => Farmer.fromMap(doc.data() as Map<String, dynamic>))
      .toList();
});

final farmerProvider = StateNotifierProvider<DeductionNotifier, List<Farmer>>(
  (ref) => DeductionNotifier(),
);

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class DeductionNotifier extends StateNotifier<List<Farmer>> {
  DeductionNotifier() : super([]) {
    _loadDeductions(); // Load deductions from Firestore when initializing
  }

  // Load deductions from Firestore
  Future<void> _loadDeductions() async {
    try {
      final querySnapshot = await _firestore.collection('farmers').get();
      final sales =
          querySnapshot.docs.map((doc) => Farmer.fromMap(doc.data())).toList();
      state = sales;
    } catch (e) {
      debugPrint("Error loading deductions from Firestore: $e");
    }
  }

  // Add a deduction to Firestore and update state
  Future<void> addFarmer(Farmer farmer) async {
    try {
      // Add deduction to Firestore
      final docRef = await _firestore.collection('farmers').add(farmer.toMap());

      // Add the deduction to the local state
      final newSale = farmer.copyWith(id: docRef.id);
      state = [...state, newSale];
    } catch (e) {
      debugPrint("Error adding deduction: $e");
    }
  }

  // Delete a deduction from Firestore and update state
  Future<void> deleteFarmer(String id) async {
    try {
      // Delete deduction from Firestore
      await _firestore.collection('farmers').doc(id).delete();

      // Remove the deduction from the local state
      state = state.where((farmer) => farmer.id != id).toList();
    } catch (e) {
      debugPrint("Error deleting deduction: $e");
    }
  }

  // Update a deduction in Firestore and update state
  Future<void> updateDeduction(Farmer updatedFarmer) async {
    try {
      // Update deduction in Firestore
      await _firestore
          .collection('farmers')
          .doc(updatedFarmer.id)
          .update(updatedFarmer.toMap());

      // Update the deduction in the local state
      state = [
        for (final sale in state)
          if (sale.id == updatedFarmer.id) updatedFarmer else sale
      ];
    } catch (e) {
      debugPrint("Error updating deduction: $e");
    }
  }
}

final searchQueryProvider = StateProvider<String>((ref) => "");
final farmerQueryProvider = StateProvider<String>((ref) => "");
