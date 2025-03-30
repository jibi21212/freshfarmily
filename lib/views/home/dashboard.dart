import 'package:flutter/material.dart';
import 'package:freshfarmily/views/home/buyer/buyer_dashboard.dart';
import 'package:freshfarmily/views/home/farmer/farmer_dashboard.dart';
import 'package:freshfarmily/views/home/delivery/delivery_dashboard.dart';
import 'package:freshfarmily/models/user.dart';

class Dashboards extends StatelessWidget {
  final String uid;
  final UserRole role;

  const Dashboards({
    super.key, 
    required this.uid,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    switch (role) {
      case UserRole.farmer:
        return FarmerDashboard(uid: uid);  // Add uid parameter
      case UserRole.deliveryAgent:
        return DeliveryDashboard(uid: uid);  // Add uid parameter
      case UserRole.buyer:
        return BuyerDashboard(uid: uid);  // Add uid parameter
    }
  }
}