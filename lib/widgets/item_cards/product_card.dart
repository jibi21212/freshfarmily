import 'package:flutter/material.dart';
import 'package:freshfarmily/models/listing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductCard extends StatefulWidget {
  final Listing listing;
  final VoidCallback? onTap; // Navigate to product details.
  final VoidCallback? onAdd; // Callback when item is added to cart.
  final VoidCallback? onRemove; // Callback when item is removed from cart.

  const ProductCard({
    Key? key,
    required this.listing,
    this.onTap,
    this.onAdd,
    this.onRemove,
  }) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool inCart = false;


@override
  void initState() {
    super.initState();
    _checkIfInCart();
  }

  // Check Firestore to determine if the item is already in the cart.
  Future<void> _checkIfInCart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('buyers')
          .doc(user.uid)
          .collection('cart')
          .doc(widget.listing.id)
          .get();
      if (doc.exists) {
        setState(() {
          inCart = true;
        });
      }
    }
  }

  // Toggle the cart state and update Firestore accordingly.
  Future<void> toggleCart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please sign in to add items to your cart.')),
      );
      return;
    }
    final userId = user.uid;
    try {
      if (!inCart) {
        // Add the item to the cart.
        await FirebaseFirestore.instance
          .collection('buyers')
          .doc(userId)
          .collection('cart')
          .doc(widget.listing.id)
          .set({
            'listingId': widget.listing.id,
            'name': widget.listing.name,
            'price': widget.listing.price,
            'quantity': 1, // Default cart quantity
            'available': widget.listing.available, // So we can limit increments in the cart
            'addedAt': FieldValue.serverTimestamp(),
            'description': widget.listing.description,
            "farmerId": widget.listing.farmerId,
          });

      } else {
        // Remove the item from the cart.
        await FirebaseFirestore.instance
            .collection('buyers')
            .doc(userId)
            .collection('cart')
            .doc(widget.listing.id)
            .delete();
      }
      setState(() {
        inCart = !inCart;
      });
      if (inCart) {
        if (widget.onAdd != null) widget.onAdd!();
      } else {
        if (widget.onRemove != null) widget.onRemove!();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating cart: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.listing.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "From ${widget.listing.farm}",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Available: ${widget.listing.available}",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Description: ${widget.listing.description}",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Type: ${widget.listing.productType}",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Posted: ${widget.listing.posted.toLocal()}",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    icon: inCart
                        ? const Icon(Icons.remove_shopping_cart)
                        : const Icon(Icons.shopping_cart),
                    onPressed: toggleCart,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}