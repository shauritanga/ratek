import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import 'package:ratek/utils/date_formater.dart';

class Farmer {
  final String? id;
  final String firstName;
  final String middleName;
  final String lastName;
  final String phone;
  final String? corperateId;
  final String gender;
  final String nida;
  final String dob;
  final String zone;
  final String ward;
  final String district;
  final String village;
  final String accountNumber;
  final String bankName;
  final int farmSize;
  final int numberOfTrees;
  final int numberOfTreesWithFruits;
  final double? entryFee;
  final double? subscriptionFee;
  final double? loan;

  Farmer({
    required this.id,
    this.corperateId,
    this.entryFee,
    this.subscriptionFee,
    this.loan,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.phone,
    required this.gender,
    required this.nida,
    required this.dob,
    required this.zone,
    required this.ward,
    required this.district,
    required this.village,
    required this.accountNumber,
    required this.bankName,
    required this.farmSize,
    required this.numberOfTrees,
    required this.numberOfTreesWithFruits,
  });

  // Convert a Map to a Farmer
  factory Farmer.fromMap(Map<String, dynamic> map) {
    return Farmer(
        id: map['id'].toString(),
        firstName: map['first_name'] ?? "",
        middleName: map['middle_name'] ?? "",
        corperateId: map['corperate_id'] ?? "",
        entryFee: map['entry_fee'] ?? 0.0,
        subscriptionFee: map['subscription_fee'] ?? 0.0,
        loan: map['loan'] ?? 0.0,
        lastName: map['last_name'] ?? "",
        phone: map['phone'] ?? "",
        gender: map['gender'] ?? "",
        nida: map['nida'] ?? "",
        dob: map['dob'] ?? formatDate(DateTime.now()),
        zone: map['zone'] ?? "Hasamba",
        ward: map['ward'] ?? "",
        district: map['district'] ?? "",
        village: map['village'] ?? "",
        accountNumber: map['account_number'] ?? "",
        bankName: map['bank_name'] ?? "",
        farmSize: map['farm_size'] ?? 0,
        numberOfTrees: map['number_of_trees'] ?? 0,
        numberOfTreesWithFruits: map['number_of_trees_with_fruits'] ?? 0);
  }

  static fromDocument(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return Farmer(
        id: doc.id,
        firstName: map['first_name'] ?? "",
        middleName: map['middle_name'] ?? "",
        corperateId: map['corperate_id'] ?? "",
        lastName: map['last_name'] ?? "",
        phone: map['phone'] ?? "",
        gender: map['gender'] ?? "",
        nida: map['nida'] ?? "",
        dob: map['dob'] ?? formatDate(DateTime.now()),
        zone: map['zone'] ?? "Hasamba",
        ward: map['ward'] ?? "",
        loan: map['loan'] ?? 0.0,
        entryFee: map['entry_fee'] ?? 0.0,
        subscriptionFee: map['subscription_fee'] ?? 0.0,
        district: map['district'] ?? "",
        village: map['village'] ?? "",
        accountNumber: map['account_number'] ?? "",
        bankName: map['bank_name'] ?? "",
        farmSize: map['farm_size'] ?? 0,
        numberOfTrees: map['number_of_trees'] ?? 0,
        numberOfTreesWithFruits: map['number_of_trees_with_fruits'] ?? 0);
  }

  String get formattedName {
    // Format: First Full, Second Initial, Third Full
    String secondInitial = middleName.isNotEmpty ? '${middleName[0]}.' : '';
    return '$firstName $secondInitial $lastName';
  }

  // Convert a Farmer to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'phone': phone,
      'gender': gender,
      'nida': nida,
      'dob': dob,
      'zone': zone,
      'ward': ward,
      "loan": loan,
      "entry_fee": entryFee,
      'village': village,
      'account_number': accountNumber,
      'bank_name': bankName,
      'farm_size': farmSize,
      'number_of_trees': numberOfTrees,
      'number_of_trees_with_fruits': numberOfTreesWithFruits,
    };
  }

  Farmer copyWith({
    String? id,
    String? firstName,
    String? middleName,
    String? lastName,
    String? phone,
    ValueGetter<String?>? corperateId,
    String? gender,
    String? nida,
    String? dob,
    String? zone,
    String? ward,
    String? district,
    String? village,
    String? accountNumber,
    String? bankName,
    int? farmSize,
    int? numberOfTrees,
    int? numberOfTreesWithFruits,
  }) {
    return Farmer(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      corperateId: corperateId != null ? corperateId() : this.corperateId,
      gender: gender ?? this.gender,
      nida: nida ?? this.nida,
      dob: dob ?? this.dob,
      zone: zone ?? this.zone,
      ward: ward ?? this.ward,
      district: district ?? this.district,
      village: village ?? this.village,
      accountNumber: accountNumber ?? this.accountNumber,
      bankName: bankName ?? this.bankName,
      farmSize: farmSize ?? this.farmSize,
      numberOfTrees: numberOfTrees ?? this.numberOfTrees,
      numberOfTreesWithFruits:
          numberOfTreesWithFruits ?? this.numberOfTreesWithFruits,
    );
  }
}
