import 'package:flutter/material.dart';
import 'package:freshfarmily/views/home/buyer/buyer_dashboard.dart';
import 'package:freshfarmily/views/home/farmer/farmer_dashboard.dart';
import 'package:freshfarmily/views/home/delivery/delivery_dashboard.dart';
import 'package:freshfarmily/models/user.dart';

class Dashboards extends StatelessWidget {
  final User currentUser;

  const Dashboards({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    switch (currentUser.role) {
      case UserRole.farmer:
        return const FarmerDashboard();
      case UserRole.deliveryAgent:
        return const DeliveryDashboard();
      case UserRole.buyer:
        return const BuyerDashboard();
    }
  }
}