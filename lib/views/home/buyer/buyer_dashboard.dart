import 'package:flutter/material.dart';
import 'package:freshfarmily/widgets/navbar.dart';
import 'package:freshfarmily/views/home/buyer/buyer_home.dart';
import 'package:freshfarmily/views/home/buyer/cart.dart';
import 'package:freshfarmily/views/home/buyer/buyer_profile.dart';
import 'package:freshfarmily/models/user.dart';

class BuyerDashboard extends StatefulWidget {
  final String uid;  // Add this
  const BuyerDashboard({super.key, required this.uid});  // Modify constructor

  @override
  State<BuyerDashboard> createState() => _BuyerDashboardState();
}

class _BuyerDashboardState extends State<BuyerDashboard> {
  int _currentIndex = 0;

  late final List<Widget> _pages;  // Make this late

  @override
  void initState() {
    super.initState();
    // Initialize pages with uid
    _pages = [
      const BuyerHomePage(),   
      const CartPage(),        
      BuyerProfilePage(uid: widget.uid),  // Pass the uid here
    ];
  }

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