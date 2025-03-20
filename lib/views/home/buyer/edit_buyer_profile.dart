import 'package:flutter/material.dart';

class EditBuyerProfilePage extends StatefulWidget {
  const EditBuyerProfilePage({super.key});

  @override
  State<EditBuyerProfilePage> createState() => _EditBuyerProfilePageState();
}

class _EditBuyerProfilePageState extends State<EditBuyerProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late String buyerName;
  late String email;
  // Using a placeholder URL; later, you can allow image uploads.
  String profileImage = "https://via.placeholder.com/150";

  @override
  void initState() {
    super.initState();
    buyerName = "Jane Doe";
    email = "jane.doe@example.com";
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Here you’d send the updated info to your backend.
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Buyer Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(profileImage),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: buyerName,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (value) =>
                    (value == null || value.isEmpty) ? "Enter your name" : null,
                onSaved: (value) => buyerName = value!,
              ),
              TextFormField(
                initialValue: email,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    (value == null || !value.contains("@")) ? "Enter a valid email" : null,
                onSaved: (value) => email = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}