import 'package:flutter/material.dart';

class FarmerHomePage extends StatelessWidget {
  const FarmerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Farmer Dashboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Statistics Card: Total Sales
            Card(
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.trending_up),
                title: const Text("Total Sales"),
                subtitle: const Text("\$1,250.00"),
              ),
            ),
            const SizedBox(height: 16),
            // Statistics Card: Active Listings
            Card(
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.store),
                title: const Text("Active Listings"),
                subtitle: const Text("3 Active Listings"),
              ),
            ),
            const SizedBox(height: 16),
            // Placeholder for additional stats or charts
            Expanded(
              child: Center(
                child: Text(
                  "Dashboard stats and charts go here",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}