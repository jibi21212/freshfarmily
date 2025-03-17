import 'package:flutter/material.dart';

enum UserRole { buyer, deliveryAgent, farmer }

class SearchBar extends StatelessWidget {
  final UserRole role;
  final ValueChanged<String> onChanged;
  final String? hintTextOverride;

  const SearchBar({
    super.key,
    required this.role,
    required this.onChanged,
    this.hintTextOverride,
  });

  String _getHintText() {
    if (hintTextOverride != null) return hintTextOverride!;
    switch (role) {
      case UserRole.buyer:
        return 'Search products...';
      case UserRole.deliveryAgent:
        return 'Search deliveries by location, distance, pay...';
      case UserRole.farmer:
        return 'Search products to see competition...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: _getHintText(),
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
    );
  }
}