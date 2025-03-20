import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // In a real app, you’d fetch these from your CartProvider or backend.
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart & Orders"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Section: Cart Items
            const Text(
              "Cart Items",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Placeholder list of cart items.
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: const Text("Apple"),
                subtitle: const Text("2 x \$2.00"),
                trailing: const Text("\$4.00"),
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: const Text("Banana"),
                subtitle: const Text("3 x \$1.00"),
                trailing: const Text("\$3.00"),
              ),
            ),
            const SizedBox(height: 20),
            // Checkout Button
            ElevatedButton(
              onPressed: () {
                // Trigger the checkout process.
              },
              child: const Text("Checkout"),
            ),
            const SizedBox(height: 20),
            // Section: Active Orders
            const Text(
              "Active Orders",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Placeholder active orders.
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: const Text("Order #12345"),
                subtitle: const Text("Processing"),
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: const Text("Order #12346"),
                subtitle: const Text("Shipped"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}