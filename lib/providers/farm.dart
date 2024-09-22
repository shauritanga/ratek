import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ratek/models/farm.dart';

final farmProvider = FutureProvider.autoDispose((ref) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  QuerySnapshot snapshots = await firestore
      .collection("farms")
      .where("farmer", isEqualTo: user?.uid)
      .get();
  final List documents =
      snapshots.docs.map((snapshot) => snapshot.data()).toList();
  List<Farm> farms =
      documents.map((document) => Farm.fromMap(document)).toList();
  return farms;
});
