import 'package:flutter/material.dart';
import 'package:freshfarmily/widgets/navbar.dart';
import 'package:freshfarmily/views/home/farmer/farmer_home.dart';
import 'package:freshfarmily/views/home/farmer/listings.dart';
import 'package:freshfarmily/views/home/farmer/farmer_profile.dart';
import 'package:freshfarmily/models/user.dart';

class FarmerDashboard extends StatefulWidget {
  const FarmerDashboard({super.key});

  @override
  State<FarmerDashboard> createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends State<FarmerDashboard> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    FarmerHomePage(),
    ListingsPage(),
    FarmerProfile(),
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
        role: UserRole.farmer,
      ),
    );
  }
}