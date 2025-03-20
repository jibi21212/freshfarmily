import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:freshfarmily/providers/listing_provider.dart';
import 'package:freshfarmily/widgets/item_cards/listing_card.dart';
import 'package:freshfarmily/views/home/farmer/make_listing.dart';

class ListingsPage extends StatelessWidget {
  const ListingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final listings = context.watch<ListingProvider>().listings;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Listings"),
      ),
      body: listings.isEmpty
          ? Center(
              child: Text(
                "No listings available. \nAdd a listing now!",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            )
          : ListView.builder(
              itemCount: listings.length,
              itemBuilder: (context, index) {
                final listing = listings[index];
                return ListingCard(
                  listing: listing,
                  onTap: () {
                    // For example, navigate to an editing screen:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CombinedListingForm(listing: listing),
                      ),
                    );
                  },
                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CombinedListingForm(listing: listing),
                      ),
                    );
                  },
                  onDelete: () {
                    // Optionally add a confirmation dialog before deleting.
                    context.read<ListingProvider>().deleteListing(listing.id);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the make listing page.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CombinedListingForm(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}