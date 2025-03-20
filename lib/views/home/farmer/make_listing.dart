import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:freshfarmily/models/listing.dart';
import 'package:freshfarmily/providers/listing_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// This widget doubles up for creating a new listing and editing an existing one.
// If 'listing' is null, a new listing is created; otherwise, the existing listing data is loaded for editing.
class CombinedListingForm extends StatefulWidget {
  final Listing? listing; // Null means new listing, non-null means edit

  const CombinedListingForm({super.key, this.listing});

  @override
  State<CombinedListingForm> createState() => _CombinedListingFormState();
}

class _CombinedListingFormState extends State<CombinedListingForm> {
  final _formKey = GlobalKey<FormState>();

  // Form field variables. They are pre-populated if widget.listing is not null.
  late String productName;
  late double price;
  late int quantity;

  // Controller for the optional image URL text field.
  late TextEditingController _imageUrlController;

  // For local image picking.
  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // If an existing listing is provided, populate fields.
    if (widget.listing != null) {
      productName = widget.listing!.product.name;
      price = widget.listing!.product.price;
      quantity = widget.listing!.availableQuantity;
    } else {
      productName = "";
      price = 0.0;
      quantity = 0;
    }
    // Pre-populate the image URL controller either with existing product image URL or empty.
    _imageUrlController =
        TextEditingController(text: widget.listing?.product.imageUrl ?? "");
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    super.dispose();
  }

  // Method for picking an image from the gallery.
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = pickedFile;
      });
    }
  }

  // Dummy function for uploading an image to Firebase Storage.
  // Replace this with your actual implementation using the firebase_storage package.
  Future<String> _uploadImage(File imageFile) async {
    // Example: Upload image file then return its download URL.
    await Future.delayed(const Duration(seconds: 2)); // simulate upload delay
    return "https://example.com/the-uploaded-image-url"; // Replace with real URL.
  }

  // Combined function to either create a new listing or update an existing one.
  // Example modifications in the _submit() function

Future<void> _submit() async {
  if (!_formKey.currentState!.validate()) return;
  _formKey.currentState!.save();

  // Decide which image URL to use:
  String enteredImageUrl = _imageUrlController.text.trim();
  String imageUrl;
  if (enteredImageUrl.isNotEmpty) {
    imageUrl = enteredImageUrl;
  } else if (_pickedImage != null) {
    imageUrl = await _uploadImage(File(_pickedImage!.path));
  } else if (widget.listing != null && widget.listing!.product.imageUrl.isNotEmpty) {
    imageUrl = widget.listing!.product.imageUrl;
  } else {
    imageUrl = 'https://via.placeholder.com/150';
  }

  // Build JSON representation objects (as before) ...
  final productJson = {
    "id": widget.listing?.product.id ?? const Uuid().v4(),
    "name": productName,
    "price": price,
    "imageUrl": imageUrl,
    "company": "My Farm",
    "posted": DateTime.now().toIso8601String(),
    "description": '',
    "category": '',
    "quantity": quantity,
    "harvestDate": null,
    "expiryDate": null,
    "deliveryEstimate": {"value": 2.0, "unit": "days"}
  };

  final listingJson = {
    "id": widget.listing?.id ?? const Uuid().v4(),
    "product": productJson,
    "availableQuantity": quantity,
    "posted": DateTime.now().toIso8601String(),
    "isActive": true,
  };

  try {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) throw Exception("User not logged in.");
    String? token = await currentUser.getIdToken();

    http.Response response;
    if (widget.listing == null) {
      response = await http.post(
        Uri.parse("https://<YOUR-PROJECT-ID>.cloudfunctions.net/api/listings"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(listingJson),
      );
    } else {
      response = await http.patch(
        Uri.parse("https://<YOUR-PROJECT-ID>.cloudfunctions.net/api/listings/${widget.listing!.id}"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(listingJson),
      );
    }

    // Check response codes to determine success.
    if ((widget.listing == null && response.statusCode == 201) ||
        (widget.listing != null && response.statusCode == 200)) {
      // Make sure the widget is still mounted before using the BuildContext.
      if (!mounted) return;

      if (widget.listing == null) {
        Provider.of<ListingProvider>(context, listen: false)
            .addListing(Listing.fromJson(jsonDecode(response.body)));
      } else {
        Provider.of<ListingProvider>(context, listen: false)
            .updateListing(Listing.fromJson(jsonDecode(response.body)));
      }
      Navigator.pop(context);
    } else {
      // Replace print with your logging framework if desired.
      _logError("Error submitting listing: ${response.body}");
      // Optionally, show a dialog or a Snackbar with the error message.
    }
  } catch (error) {
    _logError("Error submitting listing: $error");
    // Optionally, display an error to the user.
  }
}

// Dummy logging helper. In production, use a logging framework.
void _logError(String message) {
  // In production, replace 'print' with your logging of choice.
  log(message);
}
  @override
  Widget build(BuildContext context) {
    // Display a preview of a locally picked image if available.
    final Widget localImagePreview = _pickedImage != null
        ? Image.file(
            File(_pickedImage!.path),
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          )
        : (widget.listing != null && widget.listing!.product.imageUrl.isNotEmpty)
            ? Image.network(widget.listing!.product.imageUrl,
                width: 100, height: 100, fit: BoxFit.cover)
            : const Text("No image selected");

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
                initialValue: quantity == 0 ? "" : quantity.toString(),
                decoration:
                    const InputDecoration(labelText: "Available Quantity"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || int.tryParse(value) == null
                        ? "Enter valid quantity"
                        : null,
                onChanged: (value) => quantity = int.tryParse(value) ?? 0,
              ),
              const SizedBox(height: 20),
              // IMAGE INPUT SECTION
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
              // Option to Provide an Image URL
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
                child: Text(widget.listing == null ? "Create Listing" : "Update Listing"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}