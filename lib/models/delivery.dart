// All info required for a delivery
enum DeliveryStatus { pending, inTransit, delivered, canceled }

class Delivery {
  final String id;
  final String deliveryAddress;
  final DateTime scheduledTime;
  final DeliveryStatus status;
  final double deliveryFee;
  final String listingName;
  
  Delivery({
    required this.id,
    required this.deliveryAddress,
    required this.scheduledTime,
    required this.status,
    required this.deliveryFee,
    required this.listingName,
  });
  
}
