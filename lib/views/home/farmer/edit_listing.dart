import 'dart:io';
// Image uploading feature on hold till we get to backend as it is too much of a hassle
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  // Controller for the Image URL text field.
  late TextEditingController _imageUrlController;
  // Holds the original/current image URL (could be a network URL or local file path).
  late String currentImageUrl;
  // A local image that might be picked during editing.
  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    productName = widget.listing.product.name;
    price = widget.listing.product.price;
    quantity = widget.listing.availableQuantity;
    currentImageUrl = widget.listing.product.imageUrl;
    // Initialize the controller with the current image URL if it is a valid network URL.
    _imageUrlController = TextEditingController(
        text: currentImageUrl.startsWith('http') ? currentImageUrl : '');
  }

  // Helper to build an image preview widget that checks whether to use Image.network or Image.file.
  Widget _buildImageView(String url) {
    if (url.startsWith('http')) {
      return Image.network(url, width: 100, height: 100, fit: BoxFit.cover);
    } else {
      return Image.file(File(url), width: 100, height: 100, fit: BoxFit.cover);
    }
  }

  // Pick a new image from local files.
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = pickedFile;
      });
    }
  }

  // Optionally, allow the user to remove the chosen image,
  // which resets the image preview to the current image.
  void _removeImage() {
    setState(() {
      _pickedImage = null;
      // Clear the image URL controller if desired.
      _imageUrlController.clear();
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Determine which image to use:
      // Priority: image URL from text field -> local picked image -> original current image.
      String enteredImageUrl = _imageUrlController.text.trim();
      String imageUrl;
      if (enteredImageUrl.isNotEmpty) {
        imageUrl = enteredImageUrl;
      } else if (_pickedImage != null) {
        imageUrl = _pickedImage!.path;
      } else {
        imageUrl = currentImageUrl;
      }

      // Create an updated product instance.
      final updatedProduct = Product(
        id: widget.listing.product.id,
        name: productName,
        price: price,
        imageUrl: imageUrl,
        company: widget.listing.product.company,
        posted: widget.listing.product.posted,
        description: widget.listing.product.description,
        category: widget.listing.product.category,
        quantity: quantity,
        harvestDate: widget.listing.product.harvestDate,
        expiryDate: widget.listing.product.expiryDate,
        deliveryEstimate: widget.listing.product.deliveryEstimate,
      );

      // Create an updated listing.
      final updatedListing = Listing(
        id: widget.listing.id,
        product: updatedProduct,
        availableQuantity: quantity,
        posted: widget.listing.posted,
        isActive: widget.listing.isActive,
      );

      // Update the listing using the provider.
      Provider.of<ListingProvider>(context, listen: false)
          .updateListing(updatedListing);

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
    // Build the preview widget: if a new local image was chosen, show that preview; otherwise, show the preview of the current image.
    final Widget imagePreview = _pickedImage != null
        ? Image.file(File(_pickedImage!.path),
            width: 100, height: 100, fit: BoxFit.cover)
        : _buildImageView(currentImageUrl);

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
              // Product Name Field
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
              // Price Field
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
              // Quantity Field
              TextFormField(
                initialValue: quantity.toString(),
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
              // Image Preview and Controls Section
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text("Change Image"),
                  ),
                  const SizedBox(width: 10),
                  imagePreview,
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _removeImage,
                    child: const Text("Remove Image"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Option for the farmer to paste a new Image URL.
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
                child: const Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}