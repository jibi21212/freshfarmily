import 'package:flutter/material.dart';

class SalesHistoryPage extends StatelessWidget {
  const SalesHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // For farmers: fetch sales records from your backend.
    final List<Map<String, String>> sales = [
      {"saleId": "#S1001", "total": "\$150.00", "date": "2023-01-10"},
      {"saleId": "#S1002", "total": "\$200.00", "date": "2023-01-22"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Sales History")),
      body: ListView.builder(
        itemCount: sales.length,
        itemBuilder: (context, index) {
          final sale = sales[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text("Sale ${sale['saleId']}"),
              subtitle: Text("Total: ${sale['total']} \nDate: ${sale['date']}"),
            ),
          );
        },
      ),
    );
  }
}