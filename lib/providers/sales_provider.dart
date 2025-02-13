import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ratek/models/sale.dart';
import 'package:ratek/providers/firestore_provider.dart';

final salesStreamProvider = StreamProvider<List<Sale>>((ref) {
  final firestore = ref.watch(firestoreProvider);

  CollectionReference salesCollection = firestore.collection("sales");
  return salesCollection.snapshots().map((querySnapshot) {
    return querySnapshot.docs
        .map<Sale>((doc) => Sale.fromDocument(doc))
        .toList();
  });
});

final saleProvider = StateNotifierProvider<DeductionNotifier, List<Sale>>(
  (ref) => DeductionNotifier(),
);

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class DeductionNotifier extends StateNotifier<List<Sale>> {
  DeductionNotifier() : super([]) {
    _loadDeductions(); // Load deductions from Firestore when initializing
  }

  // Load deductions from Firestore
  Future<void> _loadDeductions() async {
    try {
      final querySnapshot = await _firestore.collection('sales').get();
      final sales = querySnapshot.docs
          .map(
            (doc) => Sale(
              id: doc.id,
              farmer: doc['farmer'],
              weight: doc['weight'],
              date: doc['date'],
              receive: doc['receive'],
              amount: doc['amount'],
              uwamambo: doc['uwamambo'],
              corperate: doc['corperate'],
            ),
          )
          .toList();
      state = sales;
    } catch (e) {
      debugPrint("Error loading deductions from Firestore: $e");
    }
  }

  // Add a deduction to Firestore and update state
  Future<void> addDeduction(Sale sale) async {
    try {
      // Add deduction to Firestore
      final docRef = await _firestore.collection('sales').add({
        'farmer': sale.farmer,
        'weight': sale.weight,
        'receive': sale.receive,
        'amount': sale.amount,
        'date': sale.date,
        'uwamambo': sale.uwamambo,
        "corperate": sale.corperate
      });

      // Add the deduction to the local state
      final newSale = sale.copyWith(id: docRef.id);
      state = [...state, newSale];
    } catch (e) {
      debugPrint("Error adding deduction: $e");
    }
  }

  // Delete a deduction from Firestore and update state
  Future<void> deleteDeduction(String id) async {
    try {
      // Delete deduction from Firestore
      await _firestore.collection('deductions').doc(id).delete();

      // Remove the deduction from the local state
      state = state.where((sale) => sale.id != id).toList();
    } catch (e) {
      debugPrint("Error deleting deduction: $e");
    }
  }

  // Update a deduction in Firestore and update state
  Future<void> updateDeduction(Sale updatedSale) async {
    try {
      // Update deduction in Firestore
      await _firestore.collection('sales').doc(updatedSale.id).update({
        'farmer': updatedSale.farmer,
        'weight': updatedSale.weight,
        'cooperate': updatedSale.corperate,
        "amount": updatedSale.amount,
        'date': updatedSale.date,
        "receive": updatedSale.receive,
        "uwamambo": updatedSale.uwamambo,
      });

      // Update the deduction in the local state
      state = [
        for (final sale in state)
          if (sale.id == updatedSale.id) updatedSale else sale
      ];
    } catch (e) {
      debugPrint("Error updating deduction: $e");
    }
  }
}
