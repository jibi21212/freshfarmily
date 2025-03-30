import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freshfarmily/models/delivery.dart'; // Must export Delivery and DeliveryStatus.
import 'package:freshfarmily/views/home/delivery/delivery_details.dart';
import 'package:freshfarmily/widgets/item_cards/delivery_card.dart';
import 'package:intl/intl.dart';

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

class DeliveriesPage extends StatefulWidget {
  const DeliveriesPage({Key? key}) : super(key: key);

  @override
  _DeliveriesPageState createState() => _DeliveriesPageState();
}

class _DeliveriesPageState extends State<DeliveriesPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String userId;
  final DateFormat _dateFormat = DateFormat.yMMMd().add_jm();

  @override
  void initState() {
    super.initState();
    final user = _auth.currentUser;
    userId = user?.uid ?? '';
  }

  // Query orders accepted by this delivery agent.
  Stream<QuerySnapshot> _getAssignedOrders() {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('deliveryAgent', isEqualTo: userId)
        .snapshots();
  }

  // Update the order status (e.g., mark as delivered).
  Future<void> _updateOrderStatus(String orderId, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update({'status': newStatus});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order updated to $newStatus')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating status: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userId.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Please sign in to view your deliveries.')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Deliveries"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getAssignedOrders(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text("No deliveries assigned."));
          }
          List<Delivery> deliveries = docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            DateTime scheduledTime = DateTime.now();
            if (data['createdAt'] is Timestamp) {
              scheduledTime = (data['createdAt'] as Timestamp).toDate();
            }
            final rawStatus = data['status'] as String? ?? 'pending';
            final status = parseDeliveryStatus(rawStatus);
            String listingName = '';
            if (data['items'] is List && (data['items'] as List).isNotEmpty) {
              final firstItem = (data['items'] as List).first as Map<String, dynamic>;
              listingName = firstItem['name'] as String? ?? '';
            }
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
            itemCount: deliveries.length,
            itemBuilder: (context, index) {
              final delivery = deliveries[index];
              return DeliveryCard(
                delivery: delivery,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeliveryDetailsPage(delivery: delivery),
                    ),
                  );
                },
                onUpdateStatus: () async {
                  // For example, mark the order as delivered.
                  await _updateOrderStatus(delivery.id, 'delivered');
                },
                buttonText: "Update Status",
              );
            },
          );
        },
      ),
    );
  }
}
