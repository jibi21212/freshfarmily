import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  late String currentPassword;
  late String newPassword;
  late String confirmPassword;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (newPassword != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Passwords do not match")));
        return;
      }
      // TODO: Call API to change password.
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Change Password")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Current Password"),
                obscureText: true,
                validator: (value) =>
                    (value == null || value.isEmpty) ? "Enter current password" : null,
                onSaved: (value) => currentPassword = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "New Password"),
                obscureText: true,
                validator: (value) =>
                    (value == null || value.length < 6) ? "Enter at least 6 characters" : null,
                onSaved: (value) => newPassword = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Confirm New Password"),
                obscureText: true,
                validator: (value) =>
                    (value == null || value.isEmpty) ? "Confirm your new password" : null,
                onSaved: (value) => confirmPassword = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text("Change Password"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}