// ============================================================
// 1. lib/core/models/user_model.dart
// ============================================================
import 'dart:convert';

class UserModel {
  final String name;
  final String phone;
  final String address;

  UserModel({
    required this.name,
    required this.phone,
    this.address = '',
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'phone': phone,
    'address': address,
  };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    name: map['name'] ?? '',
    phone: map['phone'] ?? '',
    address: map['address'] ?? '',
  );

  String toJson() => jsonEncode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source));
}