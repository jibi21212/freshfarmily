
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:freshfarmily/models/listing.dart';
import 'package:freshfarmily/providers/listing_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// This widget doubles up for creating a new listing and editing an existing one.
// If 'listing' is null, a new listing is created; otherwise, the existing listing data is loaded for editing.
class CombinedListingForm extends StatefulWidget {
  final Listing? listing;
  final String farmerId;
  const CombinedListingForm({
    super.key, 
    this.listing,
    required this.farmerId,
  });
  @override
  State<CombinedListingForm> createState() => _CombinedListingFormState();
}

class _CombinedListingFormState extends State<CombinedListingForm> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Form field variables. They are pre-populated if widget.listing is not null.
  late String productName;
  late double price;
  late int available;
  late String farm;
  late String productType;
  late String description;


  @override
  void initState() {
    super.initState();
    // If an existing listing is provided, populate fields.
    if (widget.listing != null) {
      productName = widget.listing!.name;
      price = widget.listing!.price;
      available = widget.listing!.available;
      farm = widget.listing!.farm;
      productType = widget.listing!.productType;
      description = widget.listing!.description;
    } else {
      productName = "";
      price = 0.0;
      available = 0;
      productType = '';
      description = '';
    }
  }



  @override
  void dispose() {
    super.dispose();
  }


  Future<void> _submit() async {
      if (!_formKey.currentState!.validate()) return;
      _formKey.currentState!.save();

      try {
          final currentUser = FirebaseAuth.instance.currentUser;
          if (currentUser == null) throw Exception("User not logged in.");


          DocumentSnapshot farmerDoc = await FirebaseFirestore.instance
          .collection('farmers')
          .doc(currentUser.uid)
          .get();

          final farmerData = farmerDoc.data() as Map<String, dynamic>;
          final farmName = farmerData['farmName'] ?? 'Unknown Farmer';

          
      
        final listingData = {
        'id': widget.listing?.id ?? const Uuid().v4(),
        'farmerId': widget.farmerId,
        'name': productName,
        'price': price,
        'quantity':1,
        'available': available,
        'posted': DateTime.now(),
        'isActive': true,
        'farm': farmName,
        'description':description,
        };
  
        // Add to both collections using batch write
        WriteBatch batch = FirebaseFirestore.instance.batch();
  
        // Add to main product listings
        DocumentReference mainListingRef = FirebaseFirestore.instance
            .collection('product_listings')
            .doc(listingData['id'] as String);
            batch.set(mainListingRef, listingData);

        await FirebaseFirestore.instance
        .collection('product_listings')
        .doc(listingData['id'])
        .set(listingData);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Listing created successfully')),
        );
        Navigator.pop(context);

      } catch (e) {
        print('Error submitting listing: $e');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
  }


  Future<void> _deleteListing() async {
      if (widget.listing == null) return;

      try {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser == null) throw Exception("User not logged in.");

        WriteBatch batch = _firestore.batch();

        // Delete from main product listings
        batch.delete(_firestore
            .collection('product_listings')
            .doc(widget.listing!.id));

        // Delete from farmer's personal listings
        batch.delete(_firestore
            .collection('farmers')
            .doc(currentUser.uid)
            .collection('listings')
            .doc(widget.listing!.id));

        await batch.commit();

        if (!mounted) return;

        Provider.of<ListingProvider>(context, listen: false)
            .removeListing(widget.listing!.id);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Listing deleted successfully')),
        );

        Navigator.pop(context);

      } catch (error) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting listing: ${error.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

  @override
  Widget build(BuildContext context) {
    // Display a preview of a locally picked image if available.

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.listing == null ? "Create New Listing" : "Edit Listing"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Product Name Field
              TextFormField(
                initialValue: productName,
                decoration: const InputDecoration(labelText: "Product Name"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter product name" : null,
                onChanged: (value) => productName = value,
              ),
              // Price Field
              TextFormField(
                initialValue: price == 0.0 ? "" : price.toString(),
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) =>
                    value == null || double.tryParse(value) == null
                        ? "Enter valid price"
                        : null,
                onChanged: (value) => price = double.tryParse(value) ?? 0.0,
              ),
              // Available Quantity Field
              TextFormField(
                initialValue: available == 0 ? "" : available.toString(),
                decoration:
                    const InputDecoration(labelText: "Available Quantity"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || int.tryParse(value) == null
                        ? "Enter valid quantity"
                        : null,
                onChanged: (value) => available = int.tryParse(value) ?? 0,
              ),
              const SizedBox(height: 20),
              ProductTypeSelector(
                onChanged: (List<String> selected) {
                  setState(() {
                    var productTypes = selected;
                  });
                },
              ),
              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(labelText: "Product Description"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Description" : null,
                onChanged: (value) => description = value,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text(widget.listing == null ? "Create Listing" : "Update Listing"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class ProductTypeSelector extends StatefulWidget {
  final Function(List<String>) onChanged;
  
  
  const ProductTypeSelector({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  _ProductTypeSelectorState createState() => _ProductTypeSelectorState();
}

class _ProductTypeSelectorState extends State<ProductTypeSelector> {
  final Map<String, bool> _productTypes = {
    'Vegetables': false,
    'Fruits': false,
    'Meat': false,
    'Dairy': false,
    'Eggs': false,
    'Herbs': false,
    'Other': false,
    // Add more product types as needed
  };
  
  String? _selectedType;

   void _updateSelected(String type) {
    widget.onChanged([type]);  // Keep the List<String> interface but only send one value
  }

@override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Product Type',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              'Vegetables',
              'Fruits',
              'Meat',
              'Dairy',
              'Eggs',
              'Herbs',
              'Other',
            ].map((String type) {
              return RadioListTile<String>(
                title: Text(type),
                value: type,
                groupValue: _selectedType,
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      _selectedType = value;
                      _updateSelected(value);
                    });
                  }
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}