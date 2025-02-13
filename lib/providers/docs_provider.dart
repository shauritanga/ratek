import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Create a FutureProvider for counting total documents in 'farmers' and 'farms' collections
final documentCountProvider = FutureProvider<int>((ref) async {
  // Firestore instance
  final firestore = FirebaseFirestore.instance;

  try {
    // Query the 'farmers' collection and get the total count
    final farmersSnapshot = await firestore.collection('farmers').get();
    final farmersCount = farmersSnapshot.docs.length;

    // Query the 'farms' collection and get the total count
    final farmsSnapshot = await firestore.collection('farmas').get();
    final farmsCount = farmsSnapshot.docs.length;

    // Return the total count from both collections
    return farmersCount + farmsCount;
  } catch (e) {
    // Handle errors and return 0 if there's an issue
    print("Error fetching document counts: $e");
    return 0;
  }
});
