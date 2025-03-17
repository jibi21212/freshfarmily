import 'package:flutter/material.dart';
import '../widgets/common_scaffold.dart';

class DeliveryDashboard extends StatefulWidget {
  const DeliveryDashboard({super.key});

  @override
  _DeliveryDashboardState createState() => _DeliveryDashboardState();
}

class _DeliveryDashboardState extends State<DeliveryDashboard> {

  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Center(child: Text('Home Screen Content', style: TextStyle(fontSize: 18))),
    Center(child: Text('Deliveries Screen Content', style: TextStyle(fontSize: 18))),
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
      title: 'Delivery Dashboard',
      body: _widgetOptions.elementAt(_selectedIndex),
      selectedIndex: _selectedIndex,
      onItemTapped: _onItemTapped,
    );
  }
}