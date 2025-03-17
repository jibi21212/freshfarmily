// What is being offered by the farmer in terms of quantity
import 'package:freshfarmily/models/product.dart';

class Listing {
  final String id;
  final Product product;
  final int availableQuantity;
  final DateTime posted;
  final bool isActive; // To indicate if the listing is currently active

  Listing({
    required this.id,
    required this.product,
    required this.availableQuantity,
    required this.posted,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'availableQuantity': availableQuantity,
      'posted': posted.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['id'] as String,
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      availableQuantity: json['availableQuantity'] as int,
      posted: DateTime.parse(json['posted'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}