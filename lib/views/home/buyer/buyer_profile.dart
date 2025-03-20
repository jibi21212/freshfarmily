import 'package:flutter/material.dart';
import 'edit_buyer_profile.dart';

class BuyerProfile extends StatelessWidget {
  const BuyerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy buyer data; in production, these values come from your backend.
    String buyerName = "Jane Doe";
    String email = "jane.doe@example.com";
    String profileImage = "https://via.placeholder.com/150";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Buyer Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(profileImage),
            ),
            const SizedBox(height: 16),
            // Name and Email
            Text(
              buyerName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              email,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            // Edit Profile Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditBuyerProfilePage()),
                );
              },
              child: const Text("Edit Profile"),
            ),
          ],
        ),
      ),
    );
  }
}