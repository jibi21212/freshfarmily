import 'package:flutter/material.dart';
import 'package:freshfarmily/views/home/farmer/edit_profile.dart';

class FarmerProfile extends StatelessWidget {
  const FarmerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder profile data; in a real app this comes from the backend.
    String farmerName = "John Doe";
    String email = "john.doe@example.com";
    String profileImage =
        "https://via.placeholder.com/150"; // A placeholder image URL

    return Scaffold(
      appBar: AppBar(
        title: const Text("Farmer Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display Profile Picture
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(profileImage),
            ),
            const SizedBox(height: 16),
            // Display Farmer Name
            Text(
              farmerName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            // Display Email
            Text(
              email,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to the Edit Profile screen.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfilePage(),
                  ),
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