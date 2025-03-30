import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freshfarmily/models/delivery.dart'; // Ensure this exports Delivery and DeliveryStatus.
import 'package:freshfarmily/views/home/delivery/delivery_details.dart';
import 'package:freshfarmily/widgets/item_cards/delivery_card.dart';
import 'package:intl/intl.dart';


/// Helper function to convert a status string to DeliveryStatus enum.
DeliveryStatus parseDeliveryStatus(String statusString) {
  switch (statusString) {
    case 'inTransit':
      return DeliveryStatus.inTransit;
    case 'delivered':
      return DeliveryStatus.delivered;
    case 'canceled':
      return DeliveryStatus.canceled;
    case 'pending':
    default:
      return DeliveryStatus.pending;
  }
}

class DeliveryHomePage extends StatefulWidget {
  const DeliveryHomePage({Key? key}) : super(key: key);

  @override
  _DeliveryHomePageState createState() => _DeliveryHomePageState();
}

class _DeliveryHomePageState extends State<DeliveryHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String userId;
  final DateFormat _dateFormat = DateFormat.yMMMd().add_jm();

  @override
  void initState() {
    super.initState();
    final user = _auth.currentUser;
    userId = user?.uid ?? '';
  }

  // Query orders with status "pending" (available for acceptance)
  Stream<QuerySnapshot> _getAvailableOrders() {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('status', isEqualTo: 'pending')
        .snapshots();
  }

  // Accept an order: update with deliveryAgent and change status to "inTransit"
  Future<void> _acceptOrder(String orderId) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
        'deliveryAgent': userId,
        'status': 'inTransit',
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order accepted')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error accepting order: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userId.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Please sign in to view orders.')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Orders"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getAvailableOrders(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text('No available orders'));
          }
          // Map each document into a Delivery model.
          List<Delivery> orders = docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;

            // Convert createdAt timestamp to DateTime.
            DateTime scheduledTime = DateTime.now();
            if (data['createdAt'] is Timestamp) {
              scheduledTime = (data['createdAt'] as Timestamp).toDate();
            }

            final rawStatus = data['status'] as String? ?? 'pending';
            final status = parseDeliveryStatus(rawStatus);

            // Extract listing name from the first item in items array.
            String listingName = '';
            if (data['items'] is List && (data['items'] as List).isNotEmpty) {
              final firstItem = (data['items'] as List).first as Map<String, dynamic>;
              listingName = firstItem['name'] as String? ?? '';
            }

            // Use imageUrl or fallback.
            final String imageUrl = (data['imageUrl'] as String?)?.isNotEmpty == true
                ? data['imageUrl'] as String
                : 'https://via.placeholder.com/150';

            return Delivery(
              id: doc.id,
              deliveryAddress: data['deliveryAddress'] as String? ?? '',
              scheduledTime: scheduledTime,
              status: status,
              deliveryFee: (data['deliveryFee'] ?? 0).toDouble(),
              listingName: listingName,
              imageUrl: imageUrl,
            );
          }).toList();

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return DeliveryCard(
                delivery: order,
                onTap: () {
                  // Navigate to details page if needed.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DeliveryDetailsPage(delivery: order),
                    ),
                  );
                },
                onUpdateStatus: () async {
                  // "Accept Order" here updates the document.
                  await _acceptOrder(order.id);
                },
                buttonText: "Accept Order",
              );
            },
          );
        },
      ),
    );
  }
}
