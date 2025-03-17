import 'package:flutter/material.dart';
import 'package:freshfarmily/models/listing.dart';

class ListingProvider extends ChangeNotifier {
  final List<Listing> _listings = [];

  List<Listing> get listings => _listings;

  void addListing(Listing listing) {
    _listings.add(listing);
    notifyListeners();
  }

  void updateListing(Listing updatedListing) {
    final index = _listings.indexWhere((l) => l.id == updatedListing.id);
    if (index != -1) {
      _listings[index] = updatedListing;
      notifyListeners();
    }
  }

  void deleteListing(String id) {
    _listings.removeWhere((l) => l.id == id);
    notifyListeners();
  }
}