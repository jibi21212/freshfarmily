import 'package:flutter/material.dart';
import 'package:freshfarmily/models/delivery.dart';
import 'package:intl/intl.dart';

class DeliveryDetailsPage extends StatelessWidget {
  final Delivery delivery;
  const DeliveryDetailsPage({Key? key, required this.delivery}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final formattedTime = DateFormat.yMMMd().add_jm().format(delivery.scheduledTime.toLocal());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${delivery.id}'),
            Text('Address: ${delivery.deliveryAddress}'),
            Text('Scheduled: $formattedTime'),
            Text('Status: ${delivery.status.toString().split('.').last}'),
            Text('Delivery Fee: \$${delivery.deliveryFee.toStringAsFixed(2)}'),
            Text('Listing: ${delivery.listingName}'),
          ],
        ),
      ),
    );
  }
}
