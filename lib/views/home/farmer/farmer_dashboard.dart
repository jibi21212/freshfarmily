import 'package:flutter/material.dart';
import 'package:freshfarmily/providers/listing_provider.dart';
import 'package:freshfarmily/widgets/navbar.dart';
import 'package:freshfarmily/views/home/farmer/farmer_home.dart';
import 'package:freshfarmily/views/home/farmer/listings.dart';
import 'package:freshfarmily/views/home/farmer/farmer_profile.dart';
import 'package:freshfarmily/models/user.dart';
import 'package:provider/provider.dart';

class FarmerDashboard extends StatefulWidget {
  final String uid;
  const FarmerDashboard({super.key, required this.uid});

  @override
  State<FarmerDashboard> createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends State<FarmerDashboard> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

        Provider.of<ListingProvider>(context, listen: false).initializeListings(widget.uid);

    _pages = [
      const FarmerHomePage(),
      ListingsPage(farmerId: widget.uid),
      FarmerProfilePage(uid: widget.uid),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        role: UserRole.farmer,
      ),
    );
  }
}