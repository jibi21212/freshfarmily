import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freshfarmily/models/listing.dart';

class ListingProvider extends ChangeNotifier {
  final List<Listing> _listings = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot>? _listingSubscription;
  
  List<Listing> get listings => _listings;

  void initializeListings(String farmerId) {
    _listingSubscription?.cancel();
    _listingSubscription = _firestore
        .collection('product_listings')
        .where('farmerId', isEqualTo: farmerId)
        .snapshots()
        .listen((snapshot) {
          _listings.clear();
          _listings.addAll(
            snapshot.docs.map((doc) => Listing.fromJson(doc.data() as Map<String, dynamic>))
          );
          notifyListeners();
        });
  }

  void addListing(Listing listing) async {
    try {
      await _firestore
          .collection('product_listings')
          .doc(listing.id)
          .set(listing.toJson());
      // Stream will automatically update _listings
    } catch (e) {
      e;
    }
  }

  void updateListing(Listing listing) async {
    try {
      await _firestore
          .collection('product_listings')
          .doc(listing.id)
          .update(listing.toJson());
      // Stream will automatically update _listings
    } catch (e) {
      print('Error updating listing: $e');
    }
  }

  void removeListing(String id) async {
    try {
      await _firestore
          .collection('product_listings')
          .doc(id)
          .delete();
      // Stream will automatically update _listings
    } catch (e) {
      print('Error removing listing: $e');
    }
  }

  void setListings(List<Listing> listings) {
    _listings.clear();
    _listings.addAll(listings);
    notifyListeners();
  }

  @override
  void dispose() {
    _listingSubscription?.cancel();
    super.dispose();
  }
}