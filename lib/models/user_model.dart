class UserModel {
  final String phoneNumber;
  final String fullName;
  final String email;
  final String? address;
  final bool isRegistered;
  final DateTime createdAt;

  UserModel({
    required this.phoneNumber,
    required this.fullName,
    required this.email,
    this.address,
    required this.isRegistered,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'phoneNumber': phoneNumber,
    'fullName': fullName,
    'email': email,
    'address': address,
    'isRegistered': isRegistered,
    'createdAt': createdAt.toIso8601String(),
  };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      phoneNumber: json['phoneNumber'],
      fullName: json['fullName'],
      email: json['email'],
      address: json['address'],
      isRegistered: json['isRegistered'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}