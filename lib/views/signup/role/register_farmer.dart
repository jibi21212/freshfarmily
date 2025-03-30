import 'package:flutter/material.dart';
import 'package:freshfarmily/views/login/login.dart';
import 'package:freshfarmily/services/auth_service.dart';

class RegisterFarmerPage extends StatefulWidget {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;

  RegisterFarmerPage({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
  
  @override
  _RegisterFarmerPageState createState() => _RegisterFarmerPageState();
}

class _RegisterFarmerPageState extends State<RegisterFarmerPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  
  String farmName = "";

  String address = "";
  String zipcode = "";
  String error = "";

  Future<void> registerFarmerWithDetails() async {
    try {
      final user = await _authService.registerWithDetails(
        email: widget.email,
        password: widget.password,
        name: widget.name,
        userType: UserType.farmer,
        address: address,
        zipcode: zipcode,
        farmName: farmName,
      );

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        setState(() {
          error = "Registration failed";
        });
      }
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Farmer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter your Address' : null,
                onChanged: (value) => address = value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Zip code'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter your Zip code' : null,
                onChanged: (value) => zipcode = value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Farm Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter your Farm Name' : null,
                onChanged: (value) => farmName = value,
              ),
              const SizedBox(height: 16),
              if (error.isNotEmpty)
                Text(
                  error,
                  style: TextStyle(color: Colors.red),
                ),
              ElevatedButton(
                child: Text("Register"),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await registerFarmerWithDetails();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

