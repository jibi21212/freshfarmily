import 'package:flutter/material.dart';
import 'package:freshfarmily/models/delivery.dart';
import 'package:freshfarmily/widgets/item_cards/delivery_card.dart';
import 'package:uuid/uuid.dart';
import 'package:tuple/tuple.dart';
import 'package:freshfarmily/models/product.dart';

class DeliveriesPage extends StatelessWidget {
  const DeliveriesPage({super.key});

  // Dummy data simulating deliveries already accepted/assigned to this delivery agent.
  List<Delivery> _getAssignedDeliveries() {
    final dummyProduct = Product(
      id: const Uuid().v4(),
      name: "Fresh Bananas",
      price: 1.50,
      imageUrl: "https://via.placeholder.com/150",
      company: "Tropical Farms",
      posted: DateTime.now().subtract(const Duration(days: 1)),
      description: "Sweet and ripe bananas",
      category: "Fruit",
      quantity: 200,
      harvestDate: DateTime.now().subtract(const Duration(days: 2)),
      expiryDate: DateTime.now().add(const Duration(days: 5)),
      deliveryEstimate: const Tuple2(1.5, "days"),
    );
    
    return [
      Delivery(
        id: const Uuid().v4(),
        product: dummyProduct,
        deliveryAddress: "789 Order Ln, Delivery City",
        scheduledTime: DateTime.now().add(const Duration(hours: 1)),
        status: DeliveryStatus.inTransit,
        deliveryFee: 3.50,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final assignedDeliveries = _getAssignedDeliveries();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Assigned Deliveries"),
      ),
      body: assignedDeliveries.isEmpty
          ? Center(
              child: Text(
                "No assigned orders at this time.",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            )
          : ListView.builder(
              itemCount: assignedDeliveries.length,
              itemBuilder: (context, index) {
                final delivery = assignedDeliveries[index];
                return DeliveryCard(
                  delivery: delivery,
                  onTap: () {
                    // Possibly navigate to delivery details where the driver can update status.
                  },
                  onUpdateStatus: () {
                    // Implement update status functionality (for instance, marking as delivered).
                  },
                );
              },
            ),
    );
  }
}