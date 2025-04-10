// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ratek/core/services/database_service.dart';

// abstract class BaseRepository<T> {
//   final String collection;
//   final String table;
//   final DatabaseService _db = DatabaseService.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   BaseRepository({
//     required this.collection,
//     required this.table,
//   });

//   // Convert Firestore document to model
//   T fromFirestore(DocumentSnapshot doc);

//   // Convert model to Map for database operations
//   Map<String, dynamic> toMap(T item);

//   // Create item
//   Future<void> create(T item) async {
//     try {
//       final data = toMap(item);
      
//       // Save to local database
//       final localId = await _db.create(table, data);
      
//       // Save to Firestore if online
//       try {
//         final doc = await _firestore.collection(collection).add(data);
//         // Update local record with Firestore ID
//         await _db.update(
//           table,
//           {'id': doc.id},
//           where: 'id = ?',
//           whereArgs: [localId],
//         );
//       } catch (e) {
//         print('Error saving to Firestore: $e');
//         // Continue with local save only
//       }
//     } catch (e) {
//       print('Error in create: $e');
//       rethrow;
//     }
//   }

//   // Read item by ID
//   Future<T?> read(String id) async {
//     try {
//       // Try local database first
//       final localData = await _db.read(
//         table,
//         where: 'id = ?',
//         whereArgs: [id],
//       );

//       if (localData.isNotEmpty) {
//         return fromFirestore(
//           DocumentSnapshot.fromJson({
//             'id': id,
//             ...localData.first,
//           }),
//         );
//       }

//       // If not in local database, try Firestore
//       try {
//         final doc = await _firestore.collection(collection).doc(id).get();
//         if (doc.exists) {
//           // Save to local database
//           await _db.create(table, {
//             'id': doc.id,
//             ...doc.data()!,
//           });
//           return fromFirestore(doc);
//         }
//       } catch (e) {
//         print('Error reading from Firestore: $e');
//       }

//       return null;
//     } catch (e) {
//       print('Error in read: $e');
//       rethrow;
//     }
//   }

//   // Read all items
//   Future<List<T>> readAll() async {
//     try {
//       // Try local database first
//       final localData = await _db.read(table);
      
//       if (localData.isNotEmpty) {
//         return localData.map((item) => fromFirestore(
//           DocumentSnapshot.fromJson({
//             'id': item['id'],
//             ...item,
//           }),
//         )).toList();
//       }

//       // If local database is empty, try Firestore
//       try {
//         final snapshot = await _firestore.collection(collection).get();
//         final items = snapshot.docs.map((doc) => fromFirestore(doc)).toList();
        
//         // Save to local database
//         for (final doc in snapshot.docs) {
//           await _db.create(table, {
//             'id': doc.id,
//             ...doc.data(),
//           });
//         }
        
//         return items;
//       } catch (e) {
//         print('Error reading from Firestore: $e');
//         return [];
//       }
//     } catch (e) {
//       print('Error in readAll: $e');
//       rethrow;
//     }
//   }

//   // Update item
//   Future<void> update(String id, T item) async {
//     try {
//       final data = toMap(item);
      
//       // Update local database
//       await _db.update(
//         table,
//         data,
//         where: 'id = ?',
//         whereArgs: [id],
//       );
      
//       // Update Firestore if online
//       try {
//         await _firestore.collection(collection).doc(id).update(data);
//       } catch (e) {
//         print('Error updating Firestore: $e');
//         // Continue with local update only
//       }
//     } catch (e) {
//       print('Error in update: $e');
//       rethrow;
//     }
//   }

//   // Delete item
//   Future<void> delete(String id) async {
//     try {
//       // Delete from local database
//       await _db.delete(
//         table,
//         where: 'id = ?',
//         whereArgs: [id],
//       );
      
//       // Delete from Firestore if online
//       try {
//         await _firestore.collection(collection).doc(id).delete();
//       } catch (e) {
//         print('Error deleting from Firestore: $e');
//         // Continue with local delete only
//       }
//     } catch (e) {
//       print('Error in delete: $e');
//       rethrow;
//     }
//   }

//   // Query items
//   Future<List<T>> query({
//     String? where,
//     List<dynamic>? whereArgs,
//     String? orderBy,
//     int? limit,
//   }) async {
//     try {
//       final localData = await _db.read(
//         table,
//         where: where,
//         whereArgs: whereArgs,
//         orderBy: orderBy,
//         limit: limit,
//       );

//       return localData.map((item) => fromFirestore(
//         DocumentSnapshot.fromJson({
//           'id': item['id'],
//           ...item,
//         }),
//       )).toList();
//     } catch (e) {
//       print('Error in query: $e');
//       rethrow;
//     }
//   }
// } 