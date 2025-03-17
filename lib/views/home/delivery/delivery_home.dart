import 'package:flutter/material.dart';

class DeliveryHomePage extends StatelessWidget {
  const DeliveryHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Deliveries Dashboard"),
      ),
      body: Center(
        child: Text(
          "Delivery Home Page\n(Overview & stats for deliveries)",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}