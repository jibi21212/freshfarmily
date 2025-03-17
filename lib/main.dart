import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:freshfarmily/models/user.dart';
import 'package:freshfarmily/views/home/dashboard.dart';
import 'package:freshfarmily/providers/listing_provider.dart';

void main() {
  // Create a dummy buyer user or switch role as needed.
  User dummyFarmer = User(
    id: '1',
    name: 'Test Farmer',
    role: UserRole.farmer,
    created: DateTime.now(), plainPassword: '',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ListingProvider()),
        // Add more providers if needed.
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FreshFarmily',
        home: Dashboards(currentUser: dummyFarmer),
      ),
    ),
  );
}