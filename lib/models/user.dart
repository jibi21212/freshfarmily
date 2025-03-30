import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole {
  buyer,
  farmer,
  deliveryAgent,
}

class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final DateTime createdAt;
  final String address;
  final String zipcode;
  final List<dynamic> purchaseHistory;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.createdAt,
    required this.address,
    required this.zipcode,
    required this.purchaseHistory,
  });

  // Factory constructor to create a User from Firestore data
  factory User.fromFirestore(Map<String, dynamic> data, String documentId) {
    return User(
      id: documentId,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: _stringToUserRole(data['role'] ?? 'buyer'),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      address: data['address'] ?? '',
      zipcode: data['zipcode'] ?? '',
      purchaseHistory: data['purchaseHistory'] ?? [],
    );
  }

  // Helper method to convert string to UserRole enum
  static UserRole _stringToUserRole(String role) {
    switch (role.toLowerCase()) {
      case 'buyer':
        return UserRole.buyer;
      case 'farmer':
        return UserRole.farmer;
      case 'delivery_agent':
        return UserRole.deliveryAgent;
      default:
        return UserRole.buyer;
    }
  }

  // Convert User to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role.toString().split('.').last,
      'createdAt': Timestamp.fromDate(createdAt),
      'address': address,
      'zipcode': zipcode,
      'purchaseHistory': purchaseHistory,
    };
  }
}