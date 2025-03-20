import 'package:flutter/material.dart';
import 'package:freshfarmily/models/listing.dart';

class MarketProvider extends ChangeNotifier {
  // Private list holding market listings
  final List<Listing> _listings = [];

  // Public getter to provide read-only access
  List<Listing> get listings => List.unmodifiable(_listings);

  // Set the entire list (e.g., fetched from the backend)
  void setListings(List<Listing> listings) {
    _listings
      ..clear()
      ..addAll(listings);
    notifyListeners();
  }

  // Add a listing to the market.
  // Note: We allow additions here (e.g., when a new farmer listing is published)
  // but we do not provide any deletion or update methods since editing/deleting
  // must be done through the farmer’s own listings.
  void addListing(Listing listing) {
    _listings.add(listing);
    notifyListeners();
  }
}