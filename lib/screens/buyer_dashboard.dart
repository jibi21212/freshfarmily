import 'package:flutter/material.dart';

class BuyerDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buyer Dashboard'),
      ),
      body: Center(
        child: Text(
          'Welcome, Buyer! Browse fresh products here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}