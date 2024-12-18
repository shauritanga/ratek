import 'dart:convert';

import 'package:equatable/equatable.dart';

class Deduction extends Equatable {
  final String id;
  final String farmerId;
  final double loan;
  final double hisa;
  final double fees;
  final double ushuru;
  const Deduction({
    required this.id,
    required this.farmerId,
    required this.loan,
    required this.hisa,
    required this.fees,
    required this.ushuru,
  });

  @override
  List<Object> get props {
    return [
      id,
      farmerId,
      loan,
      hisa,
      fees,
      ushuru,
    ];
  }

  Deduction copyWith({
    String? id,
    String? farmerId,
    double? loan,
    double? hisa,
    double? fees,
    double? ushuru,
  }) {
    return Deduction(
      id: id ?? this.id,
      farmerId: farmerId ?? this.farmerId,
      loan: loan ?? this.loan,
      hisa: hisa ?? this.hisa,
      fees: fees ?? this.fees,
      ushuru: ushuru ?? this.ushuru,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'farmerId': farmerId,
      'loan': loan,
      'hisa': hisa,
      'fees': fees,
      'ushuru': ushuru,
    };
  }

  factory Deduction.fromMap(Map<String, dynamic> map) {
    return Deduction(
      id: map['id'] ?? '',
      farmerId: map['farmerId'] ?? '',
      loan: map['loan']?.toDouble() ?? 0.0,
      hisa: map['hisa']?.toDouble() ?? 0.0,
      fees: map['fees']?.toDouble() ?? 0.0,
      ushuru: map['ushuru']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Deduction.fromJson(String source) =>
      Deduction.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Deduction(id: $id, farmerId: $farmerId, loan: $loan, hisa: $hisa, fees: $fees, ushuru: $ushuru)';
  }
}
