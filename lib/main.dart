import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:freshfarmily/models/user.dart';
import 'package:freshfarmily/providers/listing_provider.dart';
import 'package:freshfarmily/providers/delivery_provider.dart';
import 'package:freshfarmily/providers/cart_provider.dart';
import 'package:freshfarmily/providers/market_provider.dart';
import 'package:freshfarmily/views/home/dashboard.dart';

void main() {
  // Create a dummy user with the desired role.
  // Change the role to UserRole.farmer or UserRole.deliveryAgent as needed.
  User dummyUser = User(
    id: '1',
    name: 'Test User',
    role: UserRole.deliveryAgent,
    created: DateTime.now(), plainPassword: '',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ListingProvider()),
        ChangeNotifierProvider(create: (_) => DeliveryProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => MarketProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FreshFarmily',
        home: Dashboards(currentUser: dummyUser),
      ),
    ),
  );
}