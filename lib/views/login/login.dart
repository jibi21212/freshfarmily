import 'package:flutter/material.dart';
import 'package:freshfarmily/services/auth_service.dart';
import 'package:freshfarmily/views/home/dashboard.dart';
import 'package:freshfarmily/views/signup/register.dart';
import 'package:freshfarmily/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Email input
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (val) =>
                    val != null && val.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              // Password input
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (val) => val != null && val.length < 6
                    ? 'Enter a password 6+ chars long'
                    : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              SizedBox(height: 20.0),
              // Login button
              ElevatedButton(
                child: Text("Login"),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    var user = await _authService.signIn(email, password);
                    if (user == null) {
                      setState(() => error = "Could not sign in with those credentials");
                    } else {
                      try {
                        // Check buyers collection
                        DocumentSnapshot buyerDoc = await FirebaseFirestore.instance
                            .collection('buyers')
                            .doc(user.uid)
                            .get();
                      
                        if (buyerDoc.exists) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Dashboards(
                                uid: user.uid,
                                role: UserRole.buyer,
                              ),
                            ),
                          );
                          return; // Exit after finding the user
                        }
                      
                        // Check farmers collection
                        DocumentSnapshot farmerDoc = await FirebaseFirestore.instance
                            .collection('farmers')
                            .doc(user.uid)
                            .get();
                      
                        if (farmerDoc.exists) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Dashboards(
                                uid: user.uid,
                                role: UserRole.farmer,
                              ),
                            ),
                          );
                          return; // Exit after finding the user
                        }
                      
                        // Check delivery agents collection
                        DocumentSnapshot deliveryDoc = await FirebaseFirestore.instance
                            .collection('delivery_agents')
                            .doc(user.uid)
                            .get();
                      
                        if (deliveryDoc.exists) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Dashboards(
                                uid: user.uid,
                                role: UserRole.deliveryAgent,
                              ),
                            ),
                          );
                          return; // Exit after finding the user
                        }
                      
                        // If we get here, user wasn't found in any collection
                        setState(() => error = "User data not found");
                      
                      } catch (e) {
                        setState(() => error = "Error getting user data");
                        print("Error: $e");
                      }
                    }
                  }
                },
              ),
              SizedBox(height: 12.0),
              ElevatedButton( // Sign up
                 child: Text("Register"),
                  onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
              ),
              SizedBox(height: 12.0),
              // Display error
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
