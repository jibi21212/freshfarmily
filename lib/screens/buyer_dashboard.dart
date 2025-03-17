import 'package:flutter/material.dart';
import '../widgets/common_scaffold.dart';
import 'products_screen.dart'; // Import the new ProductsScreen

class BuyerDashboard extends StatefulWidget {
  const BuyerDashboard({super.key});

  @override
  _BuyerDashboardState createState() => _BuyerDashboardState();
}

class _BuyerDashboardState extends State<BuyerDashboard> {
  int _selectedIndex = 0;

  // Modify the widget options to show your ProductsScreen on one tab.
  static final List<Widget> _widgetOptions = <Widget>[
    const Center(child: Text('Home Screen Content', style: TextStyle(fontSize: 18))),
    const ProductsScreen(),  // Displays products list.
    const Center(child: Text('Profile Screen Content', style: TextStyle(fontSize: 18))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'Buyer Dashboard',
      body: _widgetOptions.elementAt(_selectedIndex),
      selectedIndex: _selectedIndex,
      onItemTapped: _onItemTapped,
    );
  }
}