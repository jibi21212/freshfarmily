import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freshfarmily/models/listing.dart';
import 'package:freshfarmily/widgets/item_cards/listing_card.dart';
import 'package:freshfarmily/views/home/farmer/make_listing.dart';

class ListingsPage extends StatelessWidget {
  final String farmerId;
  const ListingsPage({super.key, required this.farmerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Listings"),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('farmers')
            .doc(farmerId)
            .get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> farmerSnapshot) {
          if (!farmerSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final farmerData = farmerSnapshot.data!.data() as Map<String, dynamic>;
          final farmName = farmerData['farm'] ?? 'Unknown Farmer';

          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('product_listings')
                .where('farmerId', isEqualTo: farmerId) // Add this filter
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView(
                children: snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  // Safe conversion for price.
                  double priceValue;
                  if (data['price'] == null) {
                    priceValue = 0.0;
                  } else if (data['price'] is int) {
                    priceValue = (data['price'] as int).toDouble();
                  } else {
                    priceValue = data['price'] as double;
                  }

                  // Safe conversion for quantity.
                  int available =
                      data['available'] != null ? data['available'] as int : 0;

                  // Safe conversion for posted date.
                  DateTime postedValue;
                  if (data['posted'] != null && data['posted'] is Timestamp) {
                    postedValue = (data['posted'] as Timestamp).toDate();
                  } else if (data['posted'] != null &&
                      data['posted'] is String) {
                    postedValue = DateTime.tryParse(data['posted'] as String) ??
                        DateTime.now();
                  } else {
                    postedValue = DateTime.now();
                  }


                  final listing = Listing(
                    id: doc.id,
                    name: data['name'] ?? '',
                    price: priceValue,
                    available: available ?? 0,
                    posted: postedValue,
                    isActive: data['isActive'] ?? true,
                    farm: farmName,
                    farmerId: farmerId,
                    description: data['description'] ?? '',
                    productType: data['productType'] ?? '',
                  );
                  
                  return ListingCard(
                    listing: listing,
                  );
                }).toList(),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CombinedListingForm(farmerId: farmerId),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}