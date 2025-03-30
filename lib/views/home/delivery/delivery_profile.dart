import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freshfarmily/views/login/login.dart';

class DeliveryProfilePage extends StatefulWidget {
  final String uid;
  const DeliveryProfilePage({super.key, required this.uid});

  @override
  State<DeliveryProfilePage> createState() => _DeliveryProfilePageState();
}

class _DeliveryProfilePageState extends State<DeliveryProfilePage> {
  bool isEditing = false;
  bool isLoading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  

  // Dummy profile data. In production, get this from your backend.
  String name = "";
  String email = "";
  String companyName = "";
  String phone = "";
  String companyAddress = "";
  String profileImage = "";

  // Controllers for editing
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _companyController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _companyController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('delivery_agents')
          .doc(widget.uid)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          name = data['name'] ?? '';
          email = data['email'] ?? '';
          companyAddress = data['address'] ?? '';
          profileImage = data['profileImage'] ?? '';  // If you have profile images
          companyName = data['company'] ?? '';

          
          _nameController.text = name;
          _emailController.text = email;
          _addressController.text = companyAddress;
          _companyController.text = companyName;
          
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
    _companyController.dispose();
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
      await _firestore.collection('delivery_agent').doc(widget.uid).update({
        'name': _nameController.text,
        'email': _emailController.text,
        'address': _addressController.text,
        'companyName' : _companyController.text,
      });

      setState(() {
        name = _nameController.text;
        email = _emailController.text;
        companyName = _companyController.text;
        phone = _phoneController.text;
        companyAddress = _addressController.text;
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
        ListTile(
          leading: const Icon(Icons.fire_truck_outlined),
          title: const Text("Company Name"),
          subtitle: Text(companyName),
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
          controller: _companyController,
          decoration: const InputDecoration(labelText: "Company Name"),
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