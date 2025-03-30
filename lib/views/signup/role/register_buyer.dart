import 'package:flutter/material.dart';
import 'package:freshfarmily/views/login/login.dart';
import 'package:freshfarmily/services/auth_service.dart';

class RegisterBuyerPage extends StatefulWidget {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;

  RegisterBuyerPage({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
  
  @override
  _RegisterBuyerPageState createState() => _RegisterBuyerPageState();
}

class _RegisterBuyerPageState extends State<RegisterBuyerPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  
  String address = "";
  String zipcode = "";
  String error = "";

  Future<void> registerBuyerWithDetails() async {
    try {
      final user = await _authService.registerWithDetails(
        email: widget.email,
        password: widget.password,
        name: widget.name,
        userType: UserType.buyer,
        address: address,
        zipcode: zipcode,
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
        title: const Text('Register Buyer'),
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
              if (error.isNotEmpty)
                Text(
                  error,
                  style: TextStyle(color: Colors.red),
                ),
              ElevatedButton(
                child: Text("Register"),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await registerBuyerWithDetails();
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