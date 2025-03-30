import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum UserType {
  buyer,
  farmer,
  deliveryAgent
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  

  // Sign in with email and password
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      return null;
    }
  }

  // Register with all details
  Future<User?> registerWithDetails({
    required String email,
    required String password,
    required String name,
    required UserType userType,
    String? address,
    String? zipcode,
    String? company,
    String? farmName,
    List<String>? productTypes
  }) async {
    try {
      // Create auth user
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      
      if (result.user != null) {
        // Base user data
        Map<String, dynamic> userData = {
          'name': name,
          'email': email,
          'role': userType.toString().split('.').last,
          'createdAt': FieldValue.serverTimestamp(),
        };

        // Add type-specific fields
        switch (userType) {
          case UserType.buyer:
            userData.addAll({
              'address': address,
              'zipcode': zipcode,
            });
            await _firestore.collection('buyers').doc(result.user!.uid).set(userData);
            break;

          case UserType.farmer:
            userData.addAll({
              'farmLocation': address,
              'farmName': farmName,
              'productTypes': productTypes,
              // Add other farmer-specific fields
            });
            await _firestore.collection('farmers').doc(result.user!.uid).set(userData);
            break;

          case UserType.deliveryAgent:
            userData.addAll({
              'currentLocation': null,
              'availability': true,
              'company':company,
              // Add other delivery agent-specific fields
            });
            await _firestore.collection('delivery_agents').doc(result.user!.uid).set(userData);
            break;
        }
      }
      
      return result.user;
    } catch (e) {
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Stream for auth changes
  Stream<User?> get user {
    return _auth.authStateChanges();
  }
}