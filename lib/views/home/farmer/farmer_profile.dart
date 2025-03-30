import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freshfarmily/views/login/login.dart';

class FarmerProfilePage extends StatefulWidget {
  final String uid;
  const FarmerProfilePage({super.key, required this.uid});

  @override
  State<FarmerProfilePage> createState() => _FarmerProfilePageState();
}

class _FarmerProfilePageState extends State<FarmerProfilePage> {
  bool isEditing = false;
  bool isLoading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  

  // Dummy profile data. In production, get this from your backend.
  String name = "";
  String email = "";
  String farmName = "";
  String phone = "";
  String farmAddress = "";
  String profileImage = "";

  // Controllers for editing
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _farmController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _farmController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('farmers')
          .doc(widget.uid)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          name = data['name'] ?? '';
          email = data['email'] ?? '';
          farmAddress = data['address'] ?? '';
          profileImage = data['profileImage'] ?? '';  // If you have profile images
          farmName = data['farmName'] ?? '';

          
          _nameController.text = name;
          _emailController.text = email;
          _addressController.text = farmAddress;
          _farmController.text = farmName;
          
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _farmController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  Future<void> _saveProfile() async{
    try {
      await _firestore.collection('farmers').doc(widget.uid).update({
        'name': _nameController.text,
        'email': _emailController.text,
        'address': _addressController.text,
        'farmName' : _farmController.text,
      });

      setState(() {
        name = _nameController.text;
        email = _emailController.text;
        farmName = _farmController.text;
        phone = _phoneController.text;
        farmAddress = _addressController.text;
        isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
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
        child: Column(
          children: [
            Expanded(
              child: isEditing ? _buildEditForm() : _buildProfileView(),
            ),
            ElevatedButton(
              onPressed: _signOut,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text("Sign Out"),
            ),
          ],
        ),
      )
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

  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
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
          decoration: const InputDecoration(labelText: "Farm Name"),
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