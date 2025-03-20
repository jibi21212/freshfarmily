import 'package:flutter/material.dart';

class FarmerProfilePage extends StatefulWidget {
  const FarmerProfilePage({super.key});

  @override
  State<FarmerProfilePage> createState() => _FarmerProfilePageState();
}

class _FarmerProfilePageState extends State<FarmerProfilePage> {
  bool isEditing = false;

  // Dummy profile data. In production, get this from your backend.
  String name = "John Doe";
  String email = "john.doe@example.com";
  String farmName = "Doe Farms";
  String phone = "123-456-7890";
  String profileImage = "https://via.placeholder.com/150";

  // Controllers for editing
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _farmController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: name);
    _emailController = TextEditingController(text: email);
    _farmController = TextEditingController(text: farmName);
    _phoneController = TextEditingController(text: phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _farmController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void _saveProfile() {
    // Save changes. Normally you'd also update the backend.
    setState(() {
      name = _nameController.text;
      email = _emailController.text;
      farmName = _farmController.text;
      phone = _phoneController.text;
      isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Farmer Profile"),
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
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isEditing ? _buildEditForm() : _buildProfileView(),
      ),
    );
  }

  Widget _buildProfileView() {
    // Non-editable profile display.
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
        // Farmer-specific info
        ListTile(
          leading: const Icon(Icons.agriculture),
          title: const Text("Farm Name"),
          subtitle: Text(farmName),
        ),
        ListTile(
          leading: const Icon(Icons.phone),
          title: const Text("Contact Number"),
          subtitle: Text(phone),
        ),
        // Link to settings if needed.
        ElevatedButton(
          onPressed: () {
            // Navigate to global settings (change password, order history, etc.)
            Navigator.pushNamed(context, "/settings");
          },
          child: const Text("Settings"),
        ),
      ],
    );
  }

  Widget _buildEditForm() {
    // Editable form for profile fields.
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
          controller: _farmController,
          decoration: const InputDecoration(labelText: "Farm/Company Name"),
        ),
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(labelText: "Contact Number"),
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