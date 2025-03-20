import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:freshfarmily/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:freshfarmily/models/user.dart';
import 'package:freshfarmily/providers/listing_provider.dart';
import 'package:freshfarmily/providers/delivery_provider.dart';
import 'package:freshfarmily/providers/cart_provider.dart';
import 'package:freshfarmily/providers/market_provider.dart';
import 'package:freshfarmily/views/home/dashboard.dart';

User dummyUser = User(
    id: '1',
    name: 'Test User',
    role: UserRole.farmer,
    created: DateTime.now(), plainPassword: '',
);
Future<void> main() async {
 WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
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
    );
  }
}
