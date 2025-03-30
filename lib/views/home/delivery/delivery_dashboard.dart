import 'package:flutter/material.dart';
import 'package:freshfarmily/providers/listing_provider.dart';
import 'package:freshfarmily/widgets/navbar.dart';
import 'package:freshfarmily/views/home/delivery/delivery_home.dart';
import 'package:freshfarmily/views/home/delivery/deliveries.dart';
import 'package:freshfarmily/views/home/delivery/delivery_profile.dart';
import 'package:freshfarmily/models/user.dart';
import 'package:provider/provider.dart';

class DeliveryDashboard extends StatefulWidget {
  final String uid;
  const DeliveryDashboard({super.key, required this.uid});

  @override
  State<DeliveryDashboard> createState() => _DeliveryDashboardState();
}

class _DeliveryDashboardState extends State<DeliveryDashboard> {
  int _currentIndex = 0;
  late final List<Widget> _pages;


  @override
  void initState(){
    super.initState();

    _pages = [
    DeliveryHomePage(),
    DeliveriesPage(),
    DeliveryProfilePage(uid: widget.uid),
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
        role: UserRole.deliveryAgent,
      ),
    );
  }
}