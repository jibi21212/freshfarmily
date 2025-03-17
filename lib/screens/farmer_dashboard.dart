import 'package:flutter/material.dart';
import '../widgets/common_scaffold.dart';

class FarmerDashboard extends StatefulWidget {
  const FarmerDashboard({super.key});

  @override
  _FarmerDashboardState createState() => _FarmerDashboardState();

}


class _FarmerDashboardState extends State<FarmerDashboard>{

  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Center(child: Text('Home Screen Content', style: TextStyle(fontSize: 18))),
    Center(child: Text('Listings Screen Content', style: TextStyle(fontSize: 18))),
    Center(child: Text('Profile Screen Content', style: TextStyle(fontSize: 18))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'Farmer Dashboard',
      body: _widgetOptions.elementAt(_selectedIndex),
      selectedIndex: _selectedIndex,
      onItemTapped: _onItemTapped,
    );
  }
}
