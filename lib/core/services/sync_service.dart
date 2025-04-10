import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ratek/core/constants/app_constants.dart';
import 'package:ratek/core/services/database_service.dart';

final syncServiceProvider = Provider((ref) => SyncService());

class SyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DatabaseService _db = DatabaseService.instance;
  
  // Sync farmers data
  Future<void> syncFarmers() async {
    try {
      // Get all farmers from Firestore
      final snapshot = await _firestore.collection(AppConstants.farmersCollection).get();
      final farmers = snapshot.docs.map((doc) => {
        ...doc.data(),
        'id': doc.id,
      }).toList();

      // Update local database
      for (final farmer in farmers) {
        await _db.update(
          'farmers',
          farmer,
          where: 'id = ?',
          whereArgs: [farmer['id']],
        );
      }
    } catch (e) {
      print('Error syncing farmers: $e');
    }
  }

  // Sync farms data
  Future<void> syncFarms() async {
    try {
      final snapshot = await _firestore.collection('farms').get();
      final farms = snapshot.docs.map((doc) => {
        ...doc.data(),
        'id': doc.id,
      }).toList();

      for (final farm in farms) {
        await _db.update(
          'farms',
          farm,
          where: 'id = ?',
          whereArgs: [farm['id']],
        );
      }
    } catch (e) {
      print('Error syncing farms: $e');
    }
  }

  // Sync sales data
  Future<void> syncSales() async {
    try {
      final snapshot = await _firestore.collection('sales').get();
      final sales = snapshot.docs.map((doc) => {
        ...doc.data(),
        'id': doc.id,
      }).toList();

      for (final sale in sales) {
        await _db.update(
          'sales',
          sale,
          where: 'id = ?',
          whereArgs: [sale['id']],
        );
      }
    } catch (e) {
      print('Error syncing sales: $e');
    }
  }

  // Sync groups data
  Future<void> syncGroups() async {
    try {
      final snapshot = await _firestore.collection('groups').get();
      final groups = snapshot.docs.map((doc) => {
        ...doc.data(),
        'id': doc.id,
      }).toList();

      for (final group in groups) {
        await _db.update(
          'groups',
          group,
          where: 'id = ?',
          whereArgs: [group['id']],
        );
      }
    } catch (e) {
      print('Error syncing groups: $e');
    }
  }

  // Sync all data
  Future<void> syncAll() async {
    await Future.wait([
      syncFarmers(),
      syncFarms(),
      syncSales(),
      syncGroups(),
    ]);
  }

  // Push local changes to Firestore
  Future<void> pushLocalChanges() async {
    // Implement logic to push local changes to Firestore
    // This should handle conflict resolution and merge strategies
  }

  // Start periodic sync
  Timer startPeriodicSync({Duration duration = const Duration(minutes: 5)}) {
    return Timer.periodic(duration, (_) async {
      await syncAll();
    });
  }
} 