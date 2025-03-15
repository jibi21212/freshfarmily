import 'product.dart';

class Delivery {
  final String id;
  final double price;
  final String description;
  final String from;
  final String to;
  final double distance;
  final Product product;

  Delivery({
    required this.id,
    required this.price,
    required this.description,
    required this.from,
    required this.to,
    required this.distance,
    required this.product,
  });

  factory Delivery.fromJson(Map<String, dynamic> json){
    return Delivery(
      id: json['id'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
      description: json['description'] ?? '',
      from: json['from'],
      to:json['to'] ?? '',
      distance:json['distance'] ?? '',
      product: json['product'] ?? '',
    );
  }

}