import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/products_model.dart';
import '../models/review_model.dart'; // adjust path based on your structure

class FirebaseService {
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('categories', arrayContains: category.toLowerCase())
          .get();

      print("📦 Documents fetched: ${snapshot.docs.length}");

      return snapshot.docs.map((doc) {
        return Product.fromFirestore(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      print('🔥 Error fetching $category products: $e');
      return [];
    }
  }

  // Optional: keep this for backward compatibility
  Future<List<Product>> getGamingProducts() {
    return getProductsByCategory("gaming");
  }

  Future<List<Product>> getAllProducts() async {
    try {
      final snapshot =
      await FirebaseFirestore.instance.collection('products').get();

      return snapshot.docs
          .map((doc) => Product.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('🔥 Error fetching all products: $e');
      return [];
    }
  }

  Future<List<Review>> getReviewsForProduct(String productId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('productId', isEqualTo: productId)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Review.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('🔥 Error fetching reviews: $e');
      return [];
    }
  }
  Future<void> createUserProfileIfNotExists() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      await docRef.set({
        'name': user.displayName ?? '',
        'email': user.email ?? '',
        'phone': '',
        'profileImage': '',
      });
    }
  }
  Future<List<Product>> getBestSellers() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('isBestSeller', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => Product.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print("🔥 Error fetching best sellers: $e");
      return [];
    }
  }

  Future<List<Product>> getPopularProducts() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('isPopular', isEqualTo: true)
        .get();

    return snapshot.docs.map((doc) => Product.fromFirestore(doc.data(), doc.id)).toList();
  }


}


