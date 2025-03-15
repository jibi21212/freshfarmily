import 'package:flutter/material.dart';

class LoginRoleSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FreshFarmily - Select Role'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Log in as:',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              // Button for Buyer Role
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/buyerDashboard');
                },
                child: Text('Buyer'),
              ),
              SizedBox(height: 10),
              // Button for Farmer Role
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/farmerDashboard');
                },
                child: Text('Farmer'),
              ),
              SizedBox(height: 10),
              // Button for Delivery Agent Role
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/deliveryAgentDashboard');
                },
                child: Text('Delivery Agent'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}