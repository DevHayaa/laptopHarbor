import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/cart_item_model.dart';
import '../models/order_model.dart';

class OrderProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> placeOrder({
    required List<CartItem> cartItems,
    required double totalAmount,
    required String fullName,
    required String phone,
    required String city,
    required String postalCode,
    required String shippingAddress,
    required String paymentMethod,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final orderId = _firestore.collection('orders').doc().id;
    final order = OrderModel(
      id: orderId,
      userId: user.uid,
      items: cartItems.map((item) {
        return {
          'id': item.id,
          'name': item.name,
          'price': item.price,
          'quantity': item.quantity,
          'image': item.image,
        };
      }).toList(),
      totalAmount: totalAmount,
      fullName: fullName,
      phone: phone,
      city: city,
      postalCode: postalCode,
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
      status: "Pending",
      orderDate: DateTime.now(),
    );

    // Save the order in user's collection
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .doc(orderId)
        .set(order.toMap());

    // Also add to global orders collection
    await _firestore.collection('all_orders').doc(orderId).set(order.toMap());

    // ✅ Reduce stock in products collection
    for (final item in cartItems) {
      final productRef = _firestore.collection('products').doc(item.id);

      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(productRef);

        if (!snapshot.exists) return;

        final currentStock = snapshot['stock'] ?? 0;
        final newStock = currentStock - item.quantity;

        if (newStock >= 0) {
          transaction.update(productRef, {'stock': newStock});
        } else {
          throw Exception("Not enough stock for ${item.name}");
        }
      });
    }

    // ✅ Clear user's cart from Firestore
    final cartRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('cart');

    final cartSnapshot = await cartRef.get();
    for (final doc in cartSnapshot.docs) {
      await doc.reference.delete();
    }

    notifyListeners();
  }
}
