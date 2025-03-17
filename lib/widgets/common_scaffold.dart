import 'package:flutter/material.dart';
import 'nav_bar.dart';

class CommonScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final int selectedIndex;
  final ValueChanged<int>? onItemTapped;

  const CommonScaffold({
    super.key,
    required this.title,
    required this.body,
    this.selectedIndex = 0,
    this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: body,
      bottomNavigationBar: onItemTapped != null
          ? NavBar(
              currentIndex: selectedIndex,
              onTap: onItemTapped!,
            )
          : null,
    );
  }
}