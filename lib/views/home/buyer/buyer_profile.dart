import 'package:flutter/material.dart';

class BuyerProfilePage extends StatefulWidget {
  const BuyerProfilePage({super.key});

  @override
  State<BuyerProfilePage> createState() => _BuyerProfilePageState();
}

class _BuyerProfilePageState extends State<BuyerProfilePage> {
  bool isEditing = false;
  String name = "Jane Doe";
  String email = "jane.doe@example.com";
  String shippingAddress = "123 Main St, City, Country";
  String profileImage = "https://via.placeholder.com/150";

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: name);
    _emailController = TextEditingController(text: email);
    _addressController = TextEditingController(text: shippingAddress);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void _saveProfile() {
    setState(() {
      name = _nameController.text;
      email = _emailController.text;
      shippingAddress = _addressController.text;
      isEditing = false;
    });
    // TODO: Integrate with backend if needed.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buyer Profile"),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              if (isEditing) {
                _saveProfile();
              } else {
                _toggleEditing();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isEditing ? _buildEditForm() : _buildProfileView(),
      ),
    );
  }

  Widget _buildProfileView() {
    return ListView(
      children: [
        Center(
          child: CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(profileImage),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            email,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: 16),
        ListTile(
          leading: const Icon(Icons.location_on),
          title: const Text("Shipping Address"),
          subtitle: Text(shippingAddress),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, "/settings"); // Example route to global settings
          },
          child: const Text("Settings"),
        ),
      ],
    );
  }

  Widget _buildEditForm() {
    return ListView(
      children: [
        Center(
          child: CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(profileImage),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: "Full Name"),
        ),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: "Email"),
        ),
        TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(labelText: "Shipping Address"),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _saveProfile,
          child: const Text("Save Changes"),
        ),
      ],
    );
  }
}