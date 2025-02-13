// Provider for DeductionNotifier
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ratek/models/deduction.dart';

final deductionProvider =
    StateNotifierProvider<DeductionNotifier, List<Deduction>>(
  (ref) => DeductionNotifier(),
);

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class DeductionNotifier extends StateNotifier<List<Deduction>> {
  DeductionNotifier() : super([]) {
    _loadDeductions(); // Load deductions from Firestore when initializing
  }

  // Load deductions from Firestore
  Future<void> _loadDeductions() async {
    try {
      final querySnapshot = await _firestore.collection('deductions').get();
      final deductions = querySnapshot.docs
          .map((doc) => Deduction(
                id: doc.id,
                farmerId: doc['farmerId'],
                loan: doc['loan'],
                hisa: doc['hisa'],
                fees: doc['fees'],
              ))
          .toList();
      state = deductions;
    } catch (e) {
      debugPrint("Error loading deductions from Firestore: $e");
    }
  }

  // Add a deduction to Firestore and update state
  Future<void> addDeduction(Deduction deduction) async {
    try {
      // Add deduction to Firestore
      final docRef = await _firestore.collection('deductions').add({
        'farmerId': deduction.farmerId,
        'loan': deduction.loan,
        'hisa': deduction.hisa,
        'fees': deduction.fees,
      });

      // Add the deduction to the local state
      final newDeduction = deduction.copyWith(id: docRef.id);
      state = [...state, newDeduction];
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
      state = state.where((deduction) => deduction.id != id).toList();
    } catch (e) {
      debugPrint("Error deleting deduction: $e");
    }
  }

  // Update a deduction in Firestore and update state
  Future<void> updateDeduction(Deduction updatedDeduction) async {
    try {
      // Update deduction in Firestore
      await _firestore
          .collection('deductions')
          .doc(updatedDeduction.id)
          .update({
        'loan': updatedDeduction.loan,
        'hisa': updatedDeduction.hisa,
        'fees': updatedDeduction.fees,
      });

      // Update the deduction in the local state
      state = [
        for (final deduction in state)
          if (deduction.id == updatedDeduction.id)
            updatedDeduction
          else
            deduction
      ];
    } catch (e) {
      debugPrint("Error updating deduction: $e");
    }
  }
}
