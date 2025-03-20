import 'package:flutter/material.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // In a real app, fetch the order history (for buyers/delivery agents) from the backend.
    final List<Map<String, String>> orders = [
      {"orderId": "#12345", "status": "Delivered", "date": "2023-01-15"},
      {"orderId": "#12346", "status": "Processing", "date": "2023-02-05"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Order History")),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text("Order ${order['orderId']}"),
              subtitle: Text("Status: ${order['status']} \nDate: ${order['date']}"),
            ),
          );
        },
      ),
    );
  }
}