class Sale {
  final String id;
  final String date;
  final String farmer;
  final double amount;
  final String corperateId;
  final int weight;
  final double receive;

  Sale({
    required this.id,
    required this.date,
    required this.farmer,
    required this.amount,
    required this.corperateId,
    required this.weight,
  }) : receive = amount - (weight * 70);

  // Convert a Sale into a Map. The keys must correspond to the column names
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'farmer': farmer,
      'amount': amount,
      'corperate_id': corperateId,
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
      corperateId: map['corperate_id'],
      weight: map['weight'],
    );
  }
}
