import 'package:flutter/material.dart';

class BuyerProfile extends StatelessWidget {
  const BuyerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Center(
        child: Text(
          "Buyer Profile\n(Display profile info here)",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}