import 'package:flutter/material.dart';
import 'package:freshfarmily/models/delivery.dart';

class DeliveryProvider extends ChangeNotifier {
  final List<Delivery> _deliveries = [];

  List<Delivery> get deliveries => _deliveries;

  void addDelivery(Delivery delivery) {
    _deliveries.add(delivery);
    notifyListeners();
  }

  void updateDelivery(Delivery updatedDelivery) {
    final index = _deliveries.indexWhere((d) => d.id == updatedDelivery.id);
    if (index != -1) {
      _deliveries[index] = updatedDelivery;
      notifyListeners();
    }
  }

  void deleteDelivery(String id) {
    _deliveries.removeWhere((d) => d.id == id);
    notifyListeners();
  }
}