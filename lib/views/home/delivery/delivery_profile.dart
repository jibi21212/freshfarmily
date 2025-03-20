import 'package:flutter/material.dart';

class DeliveryProfilePage extends StatefulWidget {
  const DeliveryProfilePage({super.key});

  @override
  State<DeliveryProfilePage> createState() => _DeliveryProfilePageState();
}

class _DeliveryProfilePageState extends State<DeliveryProfilePage> {
  bool isEditing = false;
  String name = "Alex Smith";
  String email = "alex.smith@example.com";
  String phone = "987-654-3210";
  String profileImage = "https://via.placeholder.com/150";

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: name);
    _emailController = TextEditingController(text: email);
    _phoneController = TextEditingController(text: phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
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
      phone = _phoneController.text;
      isEditing = false;
    });
    // TODO: Send changes to backend.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delivery Profile"),
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
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.phone),
          title: const Text("Contact Number"),
          subtitle: Text(phone),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, "/settings");
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