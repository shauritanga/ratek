import 'package:cloud_firestore/cloud_firestore.dart';

class Sale {
  final String id;
  final String date;
  final String farmer;
  final double amount;
  final String corperate;
  final double weight;
  final double uwamambo;
  final double receive;

  Sale({
    required this.id,
    required this.date,
    required this.farmer,
    required this.amount,
    required this.corperate,
    required this.weight,
    required this.uwamambo,
    required this.receive,
  });

  // Convert a Sale into a Map. The keys must correspond to the column names
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'farmer': farmer,
      'amount': amount,
      'corperate': corperate,
      "uwamambo": uwamambo,
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
        corperate: map['coorperate'],
        weight: map['weight'],
        uwamambo: map['uwamambo'],
        receive: map['receive']);
  }

  static fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Sale(
      id: doc.id,
      date: data['date'] ?? DateTime.now(),
      farmer: data['farmer'] ?? "",
      amount: data['amount'] ?? 0.0,
      corperate: data['corperate'] ?? "",
      weight: data['weight'] ?? 0.0,
      uwamambo: data['uwamambo'] ?? 0.0,
      receive: data['receive'] ?? 0.0,
    );
  }

  Sale copyWith({
    String? id,
    String? date,
    String? farmer,
    double? amount,
    String? corperate,
    double? weight,
    double? uwamambo,
    double? receive,
  }) {
    return Sale(
      id: id ?? this.id,
      date: date ?? this.date,
      farmer: farmer ?? this.farmer,
      amount: amount ?? this.amount,
      corperate: corperate ?? this.corperate,
      weight: weight ?? this.weight,
      uwamambo: uwamambo ?? this.uwamambo,
      receive: receive ?? this.receive,
    );
  }
}
