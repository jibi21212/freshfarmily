// What populates the delivery agents marketplace (deliveries)
import 'package:flutter/material.dart';
import 'package:freshfarmily/models/delivery.dart';

class DeliveryCard extends StatelessWidget {
  final Delivery delivery;
  final VoidCallback? onTap;         // For viewing detailed delivery information
  final VoidCallback? onUpdateStatus; // For updating the delivery status (e.g., marking as delivered)

  const DeliveryCard({
    super.key,
    required this.delivery,
    this.onTap,
    this.onUpdateStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Display product image from the delivery's product
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  delivery.product.imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              // Display delivery details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      delivery.product.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "To: ${delivery.deliveryAddress}",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Scheduled: ${delivery.scheduledTime.toLocal().toShortDateString()}",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Status: ${delivery.status.toString().split('.').last}",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              // Button to update the delivery status (if onUpdateStatus callback is provided)
              if (onUpdateStatus != null)
                IconButton(
                  onPressed: onUpdateStatus,
                  icon: const Icon(Icons.update),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// A simple extension to format DateTime as a short date string.
extension DateTimeDisplay on DateTime {
  String toShortDateString() {
    return "$day/$month/$year";
  }
}