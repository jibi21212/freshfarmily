import 'package:cloud_firestore/cloud_firestore.dart';

class Listing {
  final String id;
  final String farmerId;
  final int available;
  final DateTime posted;
  final String name;
  final bool isActive;
  final double price;
  String imageUrl;
  final String farm;
  final String description;
  final String productType;

  Listing({
    required this.id,
    required this.farmerId,
    required this.name,
    required this.available,
    required this.posted,
    required this.price,
    this.isActive = true,
    this.imageUrl = '',
    required this.farm,
    required this.description,
    required this.productType,
  });

   factory Listing.fromJson(Map<String, dynamic> json) {
    // Convert Firestore data safely.
    final rawAvailable = json['available'];
    final int availableValue =
        (rawAvailable is int) ? rawAvailable : 0;

    final rawPrice = json['price'];
    double priceValue = 0.0;
    if (rawPrice is int) {
      priceValue = rawPrice.toDouble();
    } else if (rawPrice is double) {
      priceValue = rawPrice;
    }

    // Convert Timestamp or string to DateTime
    DateTime postedValue = DateTime.now();
    if (json['posted'] is Timestamp) {
      postedValue = (json['posted'] as Timestamp).toDate();
    } else if (json['posted'] is String) {
      postedValue = DateTime.tryParse(json['posted']) ?? DateTime.now();
    }

    return Listing(
      id: json['id'] ?? '',
      farmerId: json['farmerId'] ?? '',
      name: json['name'] ?? '',
      available: availableValue,
      posted: postedValue,
      price: priceValue,
      isActive: json['isActive'] ?? true,
      farm: json['farm'] ?? '',
      description: json['description'] ?? '',
      productType: json['productType'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmerId': farmerId,
      'name': name,
      'available': available,  // Renamed
      'posted': posted.toIso8601String(),
      'price': price,
      'isActive': isActive,
      'farm': farm,
      'description': description,
      'productType': productType,
      'imageUrl': imageUrl,
    };
  }
}
