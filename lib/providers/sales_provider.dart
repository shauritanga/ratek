import 'package:cloud_firestore/cloud_firestore.dart';
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
