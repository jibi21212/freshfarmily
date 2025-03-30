import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// TODO -> It updates correctly just needs to not show total on cart_item
// ALSO it already makes orders, just make sures we load orders for delivery drivers
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

  // Remove a cart item from Firestore.
  Future<void> removeCartItem(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('buyers')
          .doc(userId)
          .collection('cart')
          .doc(docId)
          .delete();
      setState(() {}); // Refresh the UI.
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
        items.add({
          'listingId': listingId,
          'name': data['name'] as String? ?? "",
          'price': price,
          'quantity': quantity,
        });

        if (listingId.isNotEmpty) {
          purchasedMap[listingId] =
              (purchasedMap[listingId] ?? 0) + quantity;
        }
      }

      final orderData = {
        'userId': userId,
        'items': items,
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
      // Using a StreamBuilder so that updates in cart quantities are immediately reflected.
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('buyers')
            .doc(userId)
            .collection('cart')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final cartDocs = snapshot.data!.docs;
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
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                const Text(
                  "Cart Items",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                // Display each cart item using a custom widget.
                ...cartDocs.map((doc) {
                  return CartItemWidget(
                    doc: doc,
                    onRemoved: () => removeCartItem(doc.id),
                  );
                }).toList(),
                const SizedBox(height: 20),
                Text(
                  "Total: \$${grandTotal.toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => checkoutCart(snapshot.data!),
                  child: const Text("Checkout"),
                ),
                const SizedBox(height: 20),
                // Optionally, display active orders here.
                const Text(
                  "Active Orders",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
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
  late String imageUrl;

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
    imageUrl = data['imageUrl'] as String? ?? '';
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
        leading: imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              )
            : Container(width: 60, height: 60, color: Colors.grey),
        title: Text(name),
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
