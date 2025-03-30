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
  String _searchQuery = '';

  // TODO searchs by name as well
  // Define filter options – add or modify these as needed.
  final List<FilterOption> _filterOptions = [
    FilterOption(name: 'price', type: FilterType.range),
    FilterOption(name: 'available', type: FilterType.range),
    FilterOption(
      name: 'productType',
      type: FilterType.multiSelect,
      options: ['Vegetables', 'Fruits', 'Meat', 'Dairy', 'Eggs', 'Herbs'],
      selectedOptions: [],
    ),
    // Optionally, add a distance filter if needed (for delivery agents):
    // FilterOption(name: 'distance', type: FilterType.range),
  ];

  // Build a Firestore query based on the search query and filters.
  Query<Map<String, dynamic>> _buildQuery() {
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection("product_listings")
        .where('isActive', isEqualTo: true);

    // Search by name using Firestore's range query for strings.
    if (_searchQuery.isNotEmpty) {
      query = query
          .where('name', isGreaterThanOrEqualTo: _searchQuery)
          .where('name', isLessThanOrEqualTo: _searchQuery + '\uf8ff');
    }

    // Apply each filter if provided.
    for (var filter in _filterOptions) {
      if (filter.type == FilterType.range) {
        if (filter.minValue != null) {
          query = query.where(filter.name, isGreaterThanOrEqualTo: filter.minValue);
        }
        if (filter.maxValue != null) {
          query = query.where(filter.name, isLessThanOrEqualTo: filter.maxValue);
        }
      } else if (filter.type == FilterType.multiSelect &&
          filter.selectedOptions != null &&
          filter.selectedOptions!.isNotEmpty) {
        query = query.where('productType', whereIn: filter.selectedOptions);
      }
    }

    // Example for role-specific filtering (e.g., delivery agents):
    // if (currentUser.role == 'deliveryAgent') {
    //   query = query.where('distance', isLessThanOrEqualTo: maxDistance);
    // }

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
          SearchFilterBar(
            onSearch: (query) {
              setState(() {
                _searchQuery = query;
              });
            },
            filterOptions: _filterOptions,
            onFilterApplied: () {
              setState(() {
                // Rebuild the query when filters are applied.
              });
            },
          ),
          // Display listings based on the current query.
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
                      imageUrl: data['imageUrl'] ?? '',
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
