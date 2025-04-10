import 'package:cloud_firestore/cloud_firestore.dart';

class Sale {
  final String id;
  final String date;
  final String farmer;
  final double amount;
  final double weight;
  final String type;
  final double uwamambo;
  final double? agripoa;
  final double receive;

  Sale({
    required this.id,
    required this.date,
    required this.farmer,
    required this.amount,
    required this.weight,
    required this.type,
    required this.uwamambo,
    this.agripoa,
    required this.receive,
  });

  // Convert a Sale into a Map. The keys must correspond to the column names
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'farmer': farmer,
      'amount': amount,
      "uwamambo": uwamambo,
      "type": type,
      "receive": receive,
      "agripoa": agripoa,
      'weight': weight,
    };
  }

  // Convert a Map into a Sale. The keys must correspond to the column names
  factory Sale.fromMap(Map<String, dynamic> map) {
    return Sale(
        id: map['id'].toString(),
        date: map['date'],
        farmer: map['farmer'],
        amount: map['amount'],
        weight: map['weight'],
        type: map['type'],
        uwamambo: map['uwamambo'],
        agripoa: map['agripoa'],
        receive: map['receive']);
  }

  static fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Sale(
      id: doc.id,
      date: data['date'] ?? DateTime.now(),
      farmer: data['farmer'] ?? "",
      amount: (data['amount'] ?? 0).toDouble(),
      type: data['type'] ?? "",
      weight: (data['weight'] ?? 0.0).toDouble(),
      uwamambo: (data['uwamambo'] ?? 0).toDouble(),
      agripoa: (data['agripoa'] ?? 0).toDouble(),
      receive: (data['receive'] ?? 0).toDouble(),
    );
  }

  Sale copyWith({
    String? id,
    String? date,
    String? farmer,
    double? amount,
    double? weight,
    String? type,
    double? uwamambo,
    double? agripoa,
    double? receive,
  }) {
    return Sale(
      id: id ?? this.id,
      date: date ?? this.date,
      farmer: farmer ?? this.farmer,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      weight: weight ?? this.weight,
      uwamambo: uwamambo ?? this.uwamambo,
      agripoa: agripoa ?? this.agripoa,
      receive: receive ?? this.receive,
    );
  }
}
