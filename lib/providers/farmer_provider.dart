import 'package:cloud_firestore/cloud_firestore.dart';
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

final searchQueryProvider = StateProvider<String>((ref) => "");
