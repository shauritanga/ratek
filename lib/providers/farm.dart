import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ratek/models/farm.dart';

final farmProvider = StreamProvider.autoDispose((ref) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  final farmsRef =
      firestore.collection("farms").where("farmer", isEqualTo: user?.uid);

  return farmsRef.snapshots().map((snapshot) {
    return snapshot.docs.map((doc) => Farm.fromFirestore(doc)).toList();
  });
});
