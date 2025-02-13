import 'package:cloud_firestore/cloud_firestore.dart';

class Farm {
  String? id;
  final String name;
  final String product;
  final String region;
  final String district;
  final String ward;
  final String image;
  final String village;
  final List<String>? activities;
  final List coordinates;
  final double area;

  Farm({
    this.id,
    required this.name,
    required this.product,
    required this.region,
    required this.district,
    required this.ward,
    required this.image,
    required this.village,
    required this.coordinates,
    required this.area,
    this.activities,
  });

  factory Farm.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Farm(
        id: doc.id,
        name: data['name'] ?? 'Unknown',
        region: data['region'] ?? 'Unknown',
        district: data['district'] ?? 'Unknown',
        ward: data['ward'] ?? "unknown",
        image: data['image'] ??
            "https://images.unsplash.com/photo-1501004318641-b39e6451bec6?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cGxhbnR8ZW58MHx8MHx8fDA%3D",
        village: data['village'] ?? "unknown",
        coordinates: data['coordinates'] ?? "unknown",
        product: data['product'] ?? "unknown",
        area: data['area'] ?? "unknown",
        activities: data['activities'] ?? "unknown");
  }

  Farm.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        region = map['region'],
        district = map['district'],
        ward = map['ward'],
        image = map['image'] ??
            "https://images.unsplash.com/photo-1501004318641-b39e6451bec6?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cGxhbnR8ZW58MHx8MHx8fDA%3D",
        village = map['village'],
        coordinates = map['coordinates'],
        product = map['product'],
        area = map['area'].toDouble(),
        activities = map['activities'] ?? [];
}
