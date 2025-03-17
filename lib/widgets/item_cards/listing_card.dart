// What populates the farmers marketplace (listings)
import 'package:flutter/material.dart';
import 'package:freshfarmily/models/listing.dart';

class ListingCard extends StatelessWidget {
  final Listing listing;
  final VoidCallback? onTap;     // For viewing more detailed stats or editing the listing
  final VoidCallback? onEdit;    // Specific action to edit the listing
  final VoidCallback? onDelete;  // Specific action to delete the listing

  const ListingCard({
    super.key,
    required this.listing,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Display the product image from the Listing's product
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  listing.product.imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              // Display listing details: product name, company, available quantity, etc.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listing.product.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "From ${listing.product.company}",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Available: ${listing.availableQuantity}",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Posted: ${listing.posted.toLocal().toShortDateString()}",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              // Action buttons for editing or deleting the listing
              // When editing, switch to another page or make a view that appears that allows farmer to change, and send API call
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (onEdit != null)
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: onEdit,
                    ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: onDelete,
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

extension DateTimeExtension on DateTime {
  String toShortDateString() {
    // ignore: unnecessary_this
    return "${this.day}/${this.month}/${this.year}";
  }
}