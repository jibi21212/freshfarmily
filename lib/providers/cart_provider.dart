import 'package:flutter/material.dart';
import 'package:freshfarmily/models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<Product> _cartItems = [];

  List<Product> get cartItems => _cartItems;

  void addToCart(Product product) {
    _cartItems.add(product);
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cartItems.removeWhere((item) => item.id == productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int newQuantity) {
    // Optionally—if your Product model includes quantity, then update and notify.
    // For now, you might handle quantity changes in a separate data model.
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}