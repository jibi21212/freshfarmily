import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String userId;

  @override
  void initState() {
    super.initState();
    final user = _auth.currentUser;
    if (user != null) {
      userId = user.uid;
    } else {
      userId = ''; // Handle unsigned users as needed.
    }
  }

  Stream<QuerySnapshot> _getActiveOrders() {
    return FirebaseFirestore.instance
      .collection('orders')
      .where('userId', isEqualTo: userId)
      .snapshots();
  }

  // Remove a cart item from Firestore.
  Future<void> removeCartItem(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('buyers')
          .doc(userId)
          .collection('cart')
          .doc(docId)
          .delete(); // Refresh the UI.
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing item: $e')),
      );
    }
  }

  // Checkout: Create an order document, update each product's available quantity, and clear the cart.
Future<void> checkoutCart(QuerySnapshot snapshot) async {
  if (snapshot.docs.isEmpty) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Your cart is empty.')));
    return;
  }
  try {
    double grandTotal = 0;
    List<Map<String, dynamic>> items = [];
    // Aggregate purchased quantity per listingId.
    Map<String, int> purchasedMap = {};

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final price = (data['price'] ?? 0).toDouble();
      // IMPORTANT: Make sure the cart document's "quantity" field is updated correctly.
      final quantity = data['quantity'] as int? ?? 1;
      
      grandTotal += price * quantity;
      
      String listingId = data['listingId'] as String? ?? "";
      String farmerId = data['farmerId'] as String? ?? "";
      items.add({
        'listingId': listingId,
        'farmerId': farmerId,
        'name': data['name'] as String? ?? "",
        'price': price,
        'quantity': quantity,
      });

      if (listingId.isNotEmpty) {
        purchasedMap[listingId] =
            (purchasedMap[listingId] ?? 0) + quantity;
      }
    }

    // Create a list of unique farmer IDs from the items list.
    List<String> farmerIds = items
        .map((item) => item['farmerId'] as String)
        .toSet()
        .toList();

    final orderData = {
      'userId': userId,
      'items': items,
      'farmerIds': farmerIds, // Denormalized field for querying orders by farmer.
      'total': grandTotal,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    };

    // Create a new order.
    await FirebaseFirestore.instance.collection('orders').add(orderData);

    // Update available quantity for each product using a batch.
    WriteBatch batch = FirebaseFirestore.instance.batch();
    purchasedMap.forEach((listingId, totalPurchased) {
      DocumentReference listingRef = FirebaseFirestore.instance
          .collection('product_listings')
          .doc(listingId);
      // Decrement the product's available quantity by the aggregated purchased amount.
      batch.update(listingRef, {
        'available': FieldValue.increment(-totalPurchased)
      });
    });
    await batch.commit();

    // Clear the cart.
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Checkout successful!')));
    setState(() {});
  } catch (e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Checkout failed: $e')));
  }
}


  @override
  Widget build(BuildContext context) {
    if (userId.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Please sign in to view your cart.')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart & Orders"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Cart Section
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('buyers')
                .doc(userId)
                .collection('cart')
                .snapshots(),
            builder: (context, cartSnapshot) {
              if (!cartSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final cartDocs = cartSnapshot.data!.docs;
              if (cartDocs.isEmpty) {
                return const Center(child: Text("Your cart is empty."));
              }
              double grandTotal = 0;
              for (var doc in cartDocs) {
                final data = doc.data() as Map<String, dynamic>;
                final price = (data['price'] ?? 0).toDouble();
                final quantity = data['quantity'] as int? ?? 1;
                grandTotal += price * quantity;
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Cart Items",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...cartDocs.map((doc) => CartItemWidget(
                        doc: doc,
                        onRemoved: () => removeCartItem(doc.id),
                      )),
                  const SizedBox(height: 10),
                  Text(
                    "Total: \$${grandTotal.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => checkoutCart(cartSnapshot.data!),
                    child: const Text("Checkout"),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          // Active Orders Section
          const Text(
            "Active Orders",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _getActiveOrders(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> orderSnapshot) {
              if (!orderSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final orders = orderSnapshot.data!.docs;
              if (orders.isEmpty) {
                return const Center(child: Text("No active orders."));
              }
              return Column(
                children: orders.map((orderDoc) {
                  final data = orderDoc.data() as Map<String, dynamic>;
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text("Order: ${data['orderNumber'] ?? orderDoc.id}"),
                      subtitle: Text("Status: ${data['status']}"),
                      trailing: ElevatedButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('orders')
                              .doc(orderDoc.id)
                              .update({'status': 'cancelled'});
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Order cancelled')),
                          );
                        },
                        child: const Text("Cancel"),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }


}

// A widget to display individual cart items with quantity controls.
class CartItemWidget extends StatefulWidget {
  final DocumentSnapshot doc;
  final VoidCallback onRemoved;

  const CartItemWidget({
    Key? key,
    required this.doc,
    required this.onRemoved,
  }) : super(key: key);

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  late int quantity;
  late int available; // Maximum available stock for the product.
  late double price;
  late String name;
  late String farmerId;
  @override
  void initState() {
    super.initState();
    final data = widget.doc.data() as Map<String, dynamic>;
    // Initialize quantity from the cart document.
    quantity = data['quantity'] as int? ?? 1;
    // "available" should be the product's available stock at the time of adding to cart.
    available = data['available'] as int? ?? 0;
    price = (data['price'] ?? 0).toDouble();
    name = data['name'] as String? ?? 'Item';
    farmerId = data['farmerId']as String? ?? 'Item';
  }

  // Update the quantity in Firestore.
  Future<void> updateQuantity(int newQuantity) async {
    try {
      await widget.doc.reference.update({'quantity': newQuantity});
      setState(() {
        quantity = newQuantity;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating quantity: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = price * quantity;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Price: \$${price.toStringAsFixed(2)}"),
            Text("Total: \$${totalPrice.toStringAsFixed(2)}"),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (quantity > 1) {
                      updateQuantity(quantity - 1);
                    }
                  },
                ),
                Text(quantity.toString()),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (quantity < available) {
                      updateQuantity(quantity + 1);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Cannot exceed available quantity"),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: widget.onRemoved,
        ),
      ),
    );
  }
}
