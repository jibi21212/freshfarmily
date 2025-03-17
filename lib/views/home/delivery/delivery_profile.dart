import 'package:flutter/material.dart';

class DeliveryProfile extends StatelessWidget {
  const DeliveryProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delivery Profile"),
      ),
      body: Center(
        child: Text(
          "Delivery Profile\n(Manage account & settings)",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}