class Farmer {
  final String id;
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
  final String village;
  final String accountNumber;
  final String bankName;
  final int farmSize;
  final int numberOfTrees;
  final int numberOfTreesWithFruits;

  Farmer({
    required this.id,
    this.corperateId,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.phone,
    required this.gender,
    required this.nida,
    required this.dob,
    required this.zone,
    required this.ward,
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
        lastName: map['last_name'] ?? "",
        phone: map['phone'] ?? "",
        gender: map['gender'] ?? "",
        nida: map['nida'] ?? "",
        dob: map['dob'] ?? "",
        zone: map['zone'] ?? "",
        ward: map['ward'] ?? "",
        village: map['village'] ?? "",
        accountNumber: map['account_number'] ?? "",
        bankName: map['bank_name'] ?? "",
        farmSize: map['farm_size'] ?? 0,
        numberOfTrees: map['number_of_trees'] ?? 0,
        numberOfTreesWithFruits: map['number_of_trees_with_fruits'] ?? 0);
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
      'village': village,
      'account_number': accountNumber,
      'bank_name': bankName,
      'farm_size': farmSize,
      'number_of_trees': numberOfTrees,
      'number_of_trees_with_fruits': numberOfTreesWithFruits,
    };
  }
}
