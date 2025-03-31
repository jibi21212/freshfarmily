import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freshfarmily/models/listing.dart';
import 'package:freshfarmily/widgets/item_cards/product_card.dart';
import 'package:freshfarmily/widgets/searchbar.dart';

class BuyerHomePage extends StatefulWidget {
  const BuyerHomePage({Key? key}) : super(key: key);

  @override
  _BuyerHomePageState createState() => _BuyerHomePageState();
}

class _BuyerHomePageState extends State<BuyerHomePage> {
  
  Query<Map<String, dynamic>> _buildQuery() {
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection("product_listings")
        .where('isActive', isEqualTo: true);

    return query;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Marketplace"),
      ),
      body: Column(
        children: [
          // The search and filter bar updates _searchQuery and filter values.
          Expanded(
            child: StreamBuilder(
              stream: _buildQuery().snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No products available'));
                }
                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final listing = Listing(
                      id: doc.id,
                      farmerId: data['farmerId'] ?? '',
                      name: data['name'] ?? '',
                      price: (data['price'] as num).toDouble(),
                      available: data['available'] ?? 0,
                      posted: DateTime.now(), // Replace with actual timestamp if available.
                      isActive: data['isActive'] ?? true,
                      farm: data['farm'] ?? '',
                      description: data['description'] ?? '',
                      productType: data['productType'] ?? '',
                    );
                    return ProductCard(listing: listing);
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
