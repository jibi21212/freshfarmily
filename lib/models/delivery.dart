// All info required for a delivery
import 'package:freshfarmily/models/product.dart';

enum DeliveryStatus {
  pending,
  inTransit,
  delivered,
  cancelled,
}

class Delivery {
  final String id;
  final Product product;
  final String deliveryAddress;
  final DateTime scheduledTime;
  final DeliveryStatus status;
  final double deliveryFee;

  Delivery({
    required this.id,
    required this.product,
    required this.deliveryAddress,
    required this.scheduledTime,
    this.status = DeliveryStatus.pending,
    this.deliveryFee = 0.0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'deliveryAddress': deliveryAddress,
      'scheduledTime': scheduledTime.toIso8601String(),
      'status': status.toString().split('.').last,
      'deliveryFee': deliveryFee,
    };
  }

  factory Delivery.fromJson(Map<String, dynamic> json) {
    DeliveryStatus status;
    final statusStr = json['status'] as String;
    switch (statusStr) {
      case 'inTransit':
        status = DeliveryStatus.inTransit;
        break;
      case 'delivered':
        status = DeliveryStatus.delivered;
        break;
      case 'cancelled':
        status = DeliveryStatus.cancelled;
        break;
      case 'pending':
      default:
        status = DeliveryStatus.pending;
        break;
    }
    return Delivery(
      id: json['id'] as String,
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      deliveryAddress: json['deliveryAddress'] as String,
      scheduledTime: DateTime.parse(json['scheduledTime'] as String),
      status: status,
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 0.0,
    );
  }
}