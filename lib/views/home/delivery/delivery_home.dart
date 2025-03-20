import 'package:flutter/material.dart';
import 'package:freshfarmily/models/delivery.dart';
import 'package:freshfarmily/models/product.dart';
import 'package:uuid/uuid.dart';
import 'package:tuple/tuple.dart';
import 'package:freshfarmily/widgets/item_cards/delivery_card.dart';

class DeliveryHomePage extends StatelessWidget {
  const DeliveryHomePage({super.key});

  // Dummy data simulating available orders in the marketplace.
  List<Delivery> _getDummyDeliveries() {
    // Create a dummy product as part of delivery.
    final dummyProduct1 = Product(
      id: const Uuid().v4(),
      name: "Fresh Apples",
      price: 3.50,
      imageUrl: "https://via.placeholder.com/150",
      company: "Doe Farms",
      posted: DateTime.now().subtract(const Duration(days: 1)),
      description: "Crisp and delicious apples",
      category: "Fruit",
      quantity: 100,
      harvestDate: DateTime.now().subtract(const Duration(days: 3)),
      expiryDate: DateTime.now().add(const Duration(days: 7)),
      deliveryEstimate: const Tuple2(2.0, "days"),
    );
    final dummyProduct2 = Product(
      id: const Uuid().v4(),
      name: "Organic Carrots",
      price: 2.00,
      imageUrl: "https://via.placeholder.com/150",
      company: "Green Fields",
      posted: DateTime.now().subtract(const Duration(days: 2)),
      description: "Crunchy organic carrots",
      category: "Vegetable",
      quantity: 150,
      harvestDate: DateTime.now().subtract(const Duration(days: 4)),
      expiryDate: DateTime.now().add(const Duration(days: 10)),
      deliveryEstimate: const Tuple2(1.0, "day"),
    );
    
    // Create dummy deliveries
    return [
      Delivery(
        id: const Uuid().v4(),
        product: dummyProduct1,
        deliveryAddress: "456 Buyer St, Townsville", // typically default buyer address
        scheduledTime: DateTime.now().add(const Duration(hours: 3)),
        status: DeliveryStatus.pending,
        deliveryFee: 5.00,
      ),
      Delivery(
        id: const Uuid().v4(),
        product: dummyProduct2,
        deliveryAddress: "123 Main St, Metropolis",
        scheduledTime: DateTime.now().add(const Duration(hours: 5)),
        status: DeliveryStatus.pending,
        deliveryFee: 4.50,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final deliveries = _getDummyDeliveries();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders Marketplace"),
      ),
      body: deliveries.isEmpty
          ? Center(
              child: Text(
                "No orders available at the moment.",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            )
          : ListView.builder(
              itemCount: deliveries.length,
              itemBuilder: (context, index) {
                final delivery = deliveries[index];
                return DeliveryCard(
                  delivery: delivery,
                  // Since in marketplace mode, we don't allow editing/deletion;
                  // tapping might view details or allow accepting the order.
                  onTap: () {
                    // Implement order detail view or accept order functionality.
                  },
                );
              },
            ),
    );
  }
}