import 'package:flutter/material.dart';
import 'package:freshfarmily/models/delivery.dart';
import 'package:intl/intl.dart';

class DeliveryCard extends StatelessWidget {
  final Delivery delivery;
  final VoidCallback onTap;
  final VoidCallback onUpdateStatus;
  final String buttonText;

  const DeliveryCard({
    Key? key,
    required this.delivery,
    required this.onTap,
    required this.onUpdateStatus,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedTime = DateFormat.yMMMd().add_jm().format(delivery.scheduledTime.toLocal());
    return Card(
      child: ListTile(
        leading: Image.network(
          delivery.imageUrl.isNotEmpty
              ? delivery.imageUrl
              : 'https://via.placeholder.com/150',
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
        title: Text('Order: ${delivery.id}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Address: ${delivery.deliveryAddress}'),
            Text('Scheduled: $formattedTime'),
            Text('Status: ${delivery.status.toString().split('.').last}'),
            Text('Delivery Fee: \$${delivery.deliveryFee.toStringAsFixed(2)}'),
            Text('Listing: ${delivery.listingName}'),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: onUpdateStatus,
          child: Text(buttonText),
        ),
        onTap: onTap,
      ),
    );
  }
}
