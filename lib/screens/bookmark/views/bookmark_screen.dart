import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:laptop_harbor/components/product/product_card.dart';
import 'package:laptop_harbor/route/route_constants.dart';
import '../../../constants.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('bookmarks')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No bookmarks yet."));
          }

          final bookmarks = snapshot.data!.docs;

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding, vertical: defaultPadding),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200.0,
                    mainAxisSpacing: defaultPadding,
                    crossAxisSpacing: defaultPadding,
                    childAspectRatio: 0.66,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      final data = bookmarks[index].data() as Map<String, dynamic>;

                      return ProductCard(
                        image: data['image'],
                        brandName: data['brandName'],
                        title: data['title'],
                        price: data['price'],
                        priceAfetDiscount: data['priceAfetDiscount'],
                        dicountpercent: data['dicountpercent'],
                        press: () {
                          Navigator.pushNamed(context, productDetailsScreenRoute);
                        },
                      );
                    },
                    childCount: bookmarks.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
