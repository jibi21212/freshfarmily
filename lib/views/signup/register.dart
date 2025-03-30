import 'package:flutter/material.dart';
import 'package:freshfarmily/models/user.dart';
import 'package:freshfarmily/views/signup/role/register_buyer.dart';
import 'package:freshfarmily/views/signup/role/register_delivery.dart';
import 'package:freshfarmily/views/signup/role/register_farmer.dart'; // Assumes UserRole is defined here

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  UserRole? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Name Field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter your name' : null,
                onChanged: (value) => name = value,
              ),
              const SizedBox(height: 16),
              // Email Field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter your email' : null,
                onChanged: (value) => email = value,
              ),
              const SizedBox(height: 16),
              // Password Field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => value == null || value.length < 6
                    ? 'Password must be at least 6 characters'
                    : null,
                onChanged: (value) => password = value,
              ),
              const SizedBox(height: 16),
              // Confirm Password Field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirm your password';
                  }
                  if (value != password) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                onChanged: (value) => confirmPassword = value,
              ),
              const SizedBox(height: 16),
              // Role Selection
              const Text(
                'Select Role',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              RadioListTile<UserRole>(
                title: const Text('Farmer'),
                value: UserRole.farmer,
                groupValue: selectedRole,
                onChanged: (UserRole? value) {
                  setState(() {
                    selectedRole = value;
                  });
                },
              ),
              RadioListTile<UserRole>(
                title: const Text('Buyer'),
                value: UserRole.buyer,
                groupValue: selectedRole,
                onChanged: (UserRole? value) {
                  setState(() {
                    selectedRole = value;
                  });
                },
              ),
              RadioListTile<UserRole>(
                title: const Text('Delivery Agent'),
                value: UserRole.deliveryAgent,
                groupValue: selectedRole,
                onChanged: (UserRole? value) {
                  setState(() {
                    selectedRole = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                child: const Text('Continue'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (selectedRole == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select a role')),
                      );
                      return;
                    }
                    // Route based on the selected role.
                    switch (selectedRole) {
                      case UserRole.farmer:
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterFarmerPage(
                            name: name,
                            email: email,
                            password: password,
                            confirmPassword: confirmPassword,
                          ))
                        );
                        break;
                      case UserRole.buyer:
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterBuyerPage(
                            name: name,
                            email: email,
                            password: password,
                            confirmPassword: confirmPassword,
                          )),
                        );
                        break;
                      case UserRole.deliveryAgent:
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterDeliveryPage(
                            name: name,
                            email: email,
                            password: password,
                            confirmPassword: confirmPassword,
                          )));
                        break;
                      default:
                        // Should never reach here if all roles are handled.
                        break;
                    }
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
