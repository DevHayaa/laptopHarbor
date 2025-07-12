import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../models/products_model.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};
  Map<String, CartItem> get items => _items;

  double get totalPrice => _items.values.fold(
    0.0,
        (total, item) => total + item.price * item.quantity,
  );

  Future<void> addToCart(Product product) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('cart');

    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity += 1;
    } else {
      _items[product.id] = CartItem(
        id: product.id,
        name: product.name,
        image: product.image,
        price: product.price,
      );
    }

    await cartRef.doc(product.id).set(_items[product.id]!.toMap());
    notifyListeners();
  }

  Future<void> fetchCartItems() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('cart');

    final snapshot = await cartRef.get();

    _items.clear();
    for (var doc in snapshot.docs) {
      _items[doc.id] = CartItem.fromMap(doc.data());
    }

    notifyListeners();
  }

  Future<void> removeItem(String productId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _items.remove(productId);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .doc(productId)
        .delete();

    notifyListeners();
  }

  Future<void> clearCart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('cart');

    for (var productId in _items.keys) {
      await cartRef.doc(productId).delete();
    }

    _items.clear();
    notifyListeners();
  }

  Future<void> increaseQuantity(String productId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (_items.containsKey(productId)) {
      _items.update(
        productId,
            (existingItem) =>
            existingItem.copyWith(quantity: existingItem.quantity + 1),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc(productId)
          .update({'quantity': _items[productId]!.quantity});

      notifyListeners();
    }
  }

  Future<void> decreaseQuantity(String productId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (_items.containsKey(productId)) {
      final currentQty = _items[productId]!.quantity;

      if (currentQty > 1) {
        _items.update(
          productId,
              (existingItem) =>
              existingItem.copyWith(quantity: existingItem.quantity - 1),
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .doc(productId)
            .update({'quantity': _items[productId]!.quantity});
      } else {
        await removeItem(productId);
      }

      notifyListeners();
    }
  }
}
