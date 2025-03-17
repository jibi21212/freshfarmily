import 'package:flutter/material.dart';
import 'package:freshfarmily/models/user.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final UserRole role;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.role,
  });

  BottomNavigationBarItem _buildDashboardItem() {
    return BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Dashboard',
    );
  }

  BottomNavigationBarItem _buildMarketItem() {
    String label;
    IconData icon;
    switch (role) {
      case UserRole.farmer:
        label = 'Listings';
        icon = Icons.storefront;
        break;
      case UserRole.deliveryAgent:
        label = 'Deliveries';
        icon = Icons.local_shipping;
        break;
      case UserRole.buyer:
        label = 'Cart';
        icon = Icons.shopping_bag;
        break;
    }
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
    );
  }

  BottomNavigationBarItem _buildProfileItem() {
    return BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profile',
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        _buildDashboardItem(),
        _buildMarketItem(),
        _buildProfileItem(),
      ],
      type: BottomNavigationBarType.fixed,
    );
  }
}