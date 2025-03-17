// What populates the buyers marketplace (products)
import 'package:flutter/material.dart';
import 'package:freshfarmily/models/product.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback? onTap; // Go to product_details view
  final VoidCallback? onAdd; // Add to cart, then switch the button to allow user to easily remove from cart
  final VoidCallback? onRemove; // Remove from cart, then switch the button to allow user to add to cart again

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onAdd,
    this.onRemove,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool inCart = false;
 
  void toggleCart() { // Logic to allow for functionality outlined above for the voidCallBacks for onAdd and onRemove
    setState(() {
      inCart = !inCart;
    });
    if (inCart) {
      if (widget.onAdd != null) widget.onAdd!();
    } else {
      if (widget.onRemove != null) widget.onRemove!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: widget.onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Product image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                widget.product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            // Product name and company
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.product.company,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            // Product price
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "\$${widget.product.price.toStringAsFixed(2)}",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            // Delivery estimate if available, revisit this once app is more complete
            // ignore: unnecessary_null_comparison
            if (widget.product.deliveryEstimate != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Text(
                  "Delivery in ${widget.product.deliveryEstimate.item1} ${widget.product.deliveryEstimate.item2}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            // Toggle Add/Remove from Cart Button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: toggleCart,
                child: Text(inCart ? "Remove from Cart" : "Add to Cart"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}