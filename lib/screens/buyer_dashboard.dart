import 'package:flutter/material.dart';
import '../widgets/nav_bar.dart';

class BuyerDashboard extends StatefulWidget {
  const BuyerDashboard({Key? key}) : super(key: key);

  @override
  _BuyerDashboardState createState() => _BuyerDashboardState();
}

class _BuyerDashboardState extends State<BuyerDashboard> {
  // The current selected index in the bottom nav bar.
  int _selectedIndex = 0;

  // A list of widgets representing each tab's content.
  static const List<Widget> _widgetOptions = <Widget>[
    Center(child: Text('Home Screen Content', style: TextStyle(fontSize: 18))),
    Center(child: Text('Products Screen Content', style: TextStyle(fontSize: 18))),
    Center(child: Text('Profile Screen Content', style: TextStyle(fontSize: 18))),
  ];

  // When a tab is tapped, update the index.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buyer Dashboard'),
      ),
      // Display the content based on the selected index.
      body: _widgetOptions.elementAt(_selectedIndex),
      // Attach the custom nav bar at the bottom.
      bottomNavigationBar: NavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}