import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item_model.dart';

class LocalCartStorage {
  static const _cartKey = 'guest_cart';

  // Save cart to local storage
  static Future<void> saveCart(List<CartItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedItems = items.map((e) => jsonEncode(e.toMap())).toList();
    await prefs.setStringList(_cartKey, encodedItems);
  }

  // Load cart from local storage
  static Future<List<CartItem>> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_cartKey);
    if (data == null) return [];

    return data.map((e) {
      final decoded = jsonDecode(e);
      return CartItem.fromMap(decoded);
    }).toList();
  }

  // Clear cart from local storage
  static Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
  }
}
