import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:freshfarmily/models/listing.dart';
import 'package:freshfarmily/models/product.dart';
import 'package:freshfarmily/providers/listing_provider.dart';

class EditListingPage extends StatefulWidget {
  final Listing listing;

  const EditListingPage({super.key, required this.listing});

  @override
  State<EditListingPage> createState() => _EditListingPageState();
}

class _EditListingPageState extends State<EditListingPage> {
  final _formKey = GlobalKey<FormState>();
  late String productName;
  late double price;
  late int quantity;

  @override
  void initState() {
    super.initState();
    productName = widget.listing.product.name;
    price = widget.listing.product.price;
    quantity = widget.listing.availableQuantity;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create an updated product instance.
      // If your Product model does not have a copyWith method,
      // you can manually create a new instance:
      final updatedProduct = Product(
        id: widget.listing.product.id,
        name: productName,
        price: price,
        imageUrl: widget.listing.product.imageUrl,
        company: widget.listing.product.company,
        posted: widget.listing.product.posted,
        description: widget.listing.product.description,
        category: widget.listing.product.category,
        quantity: quantity,
        harvestDate: widget.listing.product.harvestDate,
        expiryDate: widget.listing.product.expiryDate,
        deliveryEstimate: widget.listing.product.deliveryEstimate,
      );

      // Create an updated listing
      final updatedListing = Listing(
        id: widget.listing.id,
        product: updatedProduct,
        availableQuantity: quantity,
        posted: widget.listing.posted,
        isActive: widget.listing.isActive,
      );

      Provider.of<ListingProvider>(context, listen: false)
          .updateListing(updatedListing);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Listing"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: productName,
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
                initialValue: price.toString(),
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
                initialValue: quantity.toString(),
                decoration:
                    const InputDecoration(labelText: "Available Quantity"),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: false),
                validator: (value) {
                  if (value == null || int.tryParse(value) == null) {
                    return "Enter valid quantity";
                  }
                  return null;
                },
                onSaved: (value) => quantity = int.parse(value!),
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