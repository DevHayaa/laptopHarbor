import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:laptop_harbor/components/product/product_card.dart';
import 'package:laptop_harbor/constants.dart';
import 'package:laptop_harbor/route/route_constants.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Wishlist"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('wishlist')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "Your wishlist is empty.",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final wishlistItems = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.all(defaultPadding),
            itemCount: wishlistItems.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200.0,
              mainAxisSpacing: defaultPadding,
              crossAxisSpacing: defaultPadding,
              childAspectRatio: 0.66,
            ),
            itemBuilder: (context, index) {
              final item = wishlistItems[index].data() as Map<String, dynamic>;

              return ProductCard(
                image: item['image'],
                brandName: item['brandName'],
                title: item['title'],
                price: item['price'],

                press: () {
                  Navigator.pushNamed(
                    context,
                    productDetailsScreenRoute,
                    arguments: {
                      'id': wishlistItems[index].id,
                      ...item,
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
