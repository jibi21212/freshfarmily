import 'package:flutter/material.dart';

class FarmerProfile extends StatelessWidget {
  const FarmerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace placeholder data with real data later.
    return Scaffold(
      appBar: AppBar(
        title: const Text("Farmer Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/farmer_profile.jpg'),
            ),
            const SizedBox(height: 16),
            Text(
              "Farmer Name",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              "farmer@example.com",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to an EditProfile screen if required.
              },
              child: const Text("Edit Profile"),
            ),
          ],
        ),
      ),
    );
  }
}