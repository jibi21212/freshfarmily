import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:freshfarmily/models/listing.dart';
import 'package:freshfarmily/models/product.dart';
import 'package:freshfarmily/providers/listing_provider.dart';
import 'package:tuple/tuple.dart';

class MakeListingPage extends StatefulWidget {
  const MakeListingPage({super.key});

  @override
  State<MakeListingPage> createState() => _MakeListingPageState();
}

class _MakeListingPageState extends State<MakeListingPage> {
  final _formKey = GlobalKey<FormState>();
  String productName = "";
  double price = 0.0;
  int quantity = 0;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create a dummy product for this listing
      final product = Product(
        id: const Uuid().v4(),
        name: productName,
        price: price,
        imageUrl: 'https://via.placeholder.com/150',
        company: "My Farm",
        posted: DateTime.now(),
        description: '',
        category: '',
        quantity: quantity,
        harvestDate: null,
        expiryDate: null,
        deliveryEstimate: const Tuple2(2.0, "days"),
      );

      // Create a listing wrapping the product.
      final listing = Listing(
        id: const Uuid().v4(),
        product: product,
        availableQuantity: quantity,
        posted: DateTime.now(),
        isActive: true,
      );

      // Add the listing to the provider.
      Provider.of<ListingProvider>(context, listen: false).addListing(listing);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Listing"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Product Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter product name";
                  }
                  return null;
                },
                onSaved: (value) => productName = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || double.tryParse(value) == null) {
                    return "Enter valid price";
                  }
                  return null;
                },
                onSaved: (value) => price = double.parse(value!),
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: "Available Quantity"),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: false),
                validator: (value) {
                  if (value == null || int.tryParse(value) == null) {
                    return "Enter a valid quantity";
                  }
                  return null;
                },
                onSaved: (value) => quantity = int.parse(value!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text("Create Listing"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}