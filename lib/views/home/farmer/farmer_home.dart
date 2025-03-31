import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FarmerHomePage extends StatefulWidget {
  const FarmerHomePage({super.key});  // Modify constructor

  @override
  State<FarmerHomePage> createState() => _farmHomePageState();
}

class _farmHomePageState extends State<FarmerHomePage>{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String userId;

  @override
  void initState(){
    super.initState();
    final user = _auth.currentUser;
    if(user!= null){
      userId = user.uid;
    }else{
      userId = '';
    }
  }
  Stream<QuerySnapshot> _getOrdersByFarmer(String farmerId) {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('farmerIds', arrayContains: farmerId)
        .snapshots();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Farmer Dashboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
            stream: _getOrdersByFarmer(userId),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> orderSnapshot) {
              if (!orderSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final orders = orderSnapshot.data!.docs;
              if (orders.isEmpty) {
                return const Center(child: Text("No active orders."));
              }
              return Column(
                children: orders.map((orderDoc) {
                  final data = orderDoc.data() as Map<String, dynamic>;
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text("Order: ${data['orderNumber'] ?? orderDoc.id}"),
                      subtitle: Text("Status: ${data['status']}"),
                    ),
                  );
                }).toList(),
              );
            },
          ),
          ],
        ),
      ),
    );
  }
}