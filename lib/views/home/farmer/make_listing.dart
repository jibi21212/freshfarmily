import 'dart:io';
// Image uploading feature on hold till we get to backend as it is too much of a hassle
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:tuple/tuple.dart';
import 'package:freshfarmily/models/listing.dart';
import 'package:freshfarmily/models/product.dart';
import 'package:freshfarmily/providers/listing_provider.dart';

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
  // Controller for the optional image URL text field.
  final TextEditingController _imageUrlController = TextEditingController();
  // Holds the selected local image (if any).
  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  // Allows picking an image from local files
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = pickedFile;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Determine which image source to use:
      // Prioritize the image URL field if not empty.
      String enteredImageUrl = _imageUrlController.text.trim();
      String imageUrl;
      if (enteredImageUrl.isNotEmpty) {
        imageUrl = enteredImageUrl;
      } else if (_pickedImage != null) {
        imageUrl = _pickedImage!.path;
      } else {
        imageUrl = 'https://via.placeholder.com/150';
      }

      // Create a dummy product for this listing.
      final product = Product(
        id: const Uuid().v4(),
        name: productName,
        price: price,
        imageUrl: imageUrl,
        company: "My Farm",
        posted: DateTime.now(),
        description: '',
        category: '',
        quantity: quantity,
        harvestDate: null,
        expiryDate: null,
        deliveryEstimate: const Tuple2(2.0, "days"),
      );

      // Create the listing that wraps the product.
      final listing = Listing(
        id: const Uuid().v4(),
        product: product,
        availableQuantity: quantity,
        posted: DateTime.now(),
        isActive: true,
      );

      // Add the listing via the provider.
      Provider.of<ListingProvider>(context, listen: false).addListing(listing);

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show a preview for local image if selected.
    final Widget localImagePreview = _pickedImage != null
        ? Image.file(
            File(_pickedImage!.path),
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          )
        : const Text("No local image selected");

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
              // Product Name Field
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
              // Price Field
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
              // Available Quantity Field
              TextFormField(
                decoration:
                    const InputDecoration(labelText: "Available Quantity"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || int.tryParse(value) == null) {
                    return "Enter a valid quantity";
                  }
                  return null;
                },
                onSaved: (value) => quantity = int.parse(value!),
              ),
              const SizedBox(height: 20),
              // IMAGE INPUT SECTION
              // Option 1: Local File via Image Picker
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text("Select Local Image"),
                  ),
                  const SizedBox(width: 10),
                  localImagePreview,
                ],
              ),
              const SizedBox(height: 20),
              // Option 2: Enter an Image URL
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: "Or Paste Image URL",
                ),
                keyboardType: TextInputType.url,
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