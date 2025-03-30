import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freshfarmily/views/login/login.dart';


class BuyerProfilePage extends StatefulWidget {
  final String uid;
  const BuyerProfilePage({super.key, required this.uid});

  @override
  State<BuyerProfilePage> createState() => _BuyerProfilePageState();
}

class _BuyerProfilePageState extends State<BuyerProfilePage> {
  bool isEditing = false;
  bool isLoading = true;
  String name = "";
  String email = "";
  String shippingAddress = "";
  String profileImage = "";

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _addressController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('buyers')
          .doc(widget.uid)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          name = data['name'] ?? '';
          email = data['email'] ?? '';
          shippingAddress = data['address'] ?? '';
          profileImage = data['profileImage'] ?? '';  // If you have profile images
          
          _nameController.text = name;
          _emailController.text = email;
          _addressController.text = shippingAddress;
          
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
    _addressController.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

 Future<void> _saveProfile() async {
    try {
      await _firestore.collection('buyers').doc(widget.uid).update({
        'name': _nameController.text,
        'email': _emailController.text,
        'address': _addressController.text,
      });

      setState(() {
        name = _nameController.text;
        email = _emailController.text;
        shippingAddress = _addressController.text;
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
      ),
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