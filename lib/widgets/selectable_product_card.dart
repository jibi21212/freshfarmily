import 'package:flutter/material.dart';
import '../models/product.dart';
import '../screens/product_detail_screen.dart';

class SelectableProductCard extends StatelessWidget {
  final Product product;
  // Controls whether we are in selection mode (checkbox visible on mobile)
  final bool selectionMode;
  // Is this product currently selected?
  final bool isSelected;
  // Callback when selection changes (e.g., when checkbox toggles)
  final ValueChanged<bool> onSelectionChanged;

  const SelectableProductCard({
    super.key,
    required this.product,
    this.selectionMode = false,
    this.isSelected = false,
    required this.onSelectionChanged,
  });

  // Helper function to build rating stars.
  Widget _buildRatingStars(double rating) {
    int fullStars = rating.floor();
    List<Widget> stars = [];
    for (int i = 0; i < fullStars; i++) {
      stars.add(const Icon(Icons.star, size: 16, color: Colors.amber));
    }
    if (rating - fullStars >= 0.5) {
      stars.add(const Icon(Icons.star_half, size: 16, color: Colors.amber));
    }
    return Row(children: stars);
  }

  @override
  Widget build(BuildContext context) {
    // Determine if device is desktop.
    final bool isDesktop = (Theme.of(context).platform == TargetPlatform.macOS ||
        Theme.of(context).platform == TargetPlatform.windows ||
        Theme.of(context).platform == TargetPlatform.linux);

    // On desktop, always show the checkbox.
    final bool showCheckbox = isDesktop ? true : selectionMode;

    return GestureDetector(
      onTap: () {
        // On mobile, if in selection mode, toggle selection.
        if (!isDesktop && selectionMode) {
          onSelectionChanged(!isSelected);
        } else {
          // Otherwise, navigate to the detail screen.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailScreen(product: product),
            ),
          );
        }
      },
      onLongPress: () {
        // On mobile, a long press activates selection mode.
        if (!isDesktop && !selectionMode) {
          onSelectionChanged(true);
        }
      },
      child: Stack(
        children: [
          // Main card content (similar to the original ProductCard design)
          Card(
            elevation: 2,
            margin: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image
                Image.network(
                  product.imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 150,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image, size: 50),
                  ),
                ),
                Padding(
  padding: const EdgeInsets.all(16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        product.name,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      const SizedBox(height: 4),
      _buildRatingStars(product.rating),
      const SizedBox(height: 8),
      Text(
        '\$${product.price.toStringAsFixed(2)}',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(height: 8),
      Text(
        product.description,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      const SizedBox(height: 8),
      Chip(
        label: Text(product.category),
        backgroundColor: Colors.grey[200],
        ),
    ],
  ),
),
              ],
            ),
          ),
          
          if (showCheckbox)
            Positioned(
              top: 8,
              right: 8,
              child: Checkbox(
                value: isSelected,
                onChanged: (value) {
                  onSelectionChanged(value ?? false);
                },
              ),
            ),
        ],
      ),
    );
  }
}