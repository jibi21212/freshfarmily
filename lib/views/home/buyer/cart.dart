import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
      ),
      body: Center(
        child: Text(
          "Cart is empty",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}