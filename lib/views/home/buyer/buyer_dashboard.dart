import 'package:flutter/material.dart';
import 'package:freshfarmily/widgets/navbar.dart';
import 'package:freshfarmily/views/home/buyer/buyer_home.dart';
import 'package:freshfarmily/views/home/buyer/cart.dart';
import 'package:freshfarmily/views/home/buyer/buyer_profile.dart';
import 'package:freshfarmily/models/user.dart';

class BuyerDashboard extends StatefulWidget {
  const BuyerDashboard({super.key});

  @override
  State<BuyerDashboard> createState() => _BuyerDashboardState();
}

class _BuyerDashboardState extends State<BuyerDashboard> {
  int _currentIndex = 0;

  // Replace these with your actual screens for buyers.
  final List<Widget> _pages = const [
    BuyerHomePage(),   // Your home page (e.g., featured products or marketplace)
    CartPage(),        // The shopping cart page
    BuyerProfilePage(),    // The buyer's profile page
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        role: UserRole.buyer,
      ),
    );
  }
}