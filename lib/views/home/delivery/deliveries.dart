import 'package:flutter/material.dart';
import 'package:freshfarmily/models/delivery.dart';
import 'package:freshfarmily/widgets/item_cards/delivery_card.dart';

class DeliveriesPage extends StatelessWidget {
  const DeliveriesPage({super.key});

  // A dummy list of deliveries for now.
  final List<Delivery> dummyDeliveries = const [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Deliveries"),
      ),
      body: dummyDeliveries.isEmpty
          ? Center(
              child: Text(
                "No deliveries assigned.",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            )
          : ListView.builder(
              itemCount: dummyDeliveries.length,
              itemBuilder: (context, index) {
                final delivery = dummyDeliveries[index];
                return DeliveryCard(
                  delivery: delivery,
                  onTap: () {
                    // Navigate to delivery details page if needed.
                  },
                  onUpdateStatus: () {
                    // Handle updating the delivery status.
                  },
                );
              },
            ),
    );
  }
}