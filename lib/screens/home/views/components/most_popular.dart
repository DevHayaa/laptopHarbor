import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:laptop_harbor/components/product/secondary_product_card.dart';
import 'package:laptop_harbor/constants.dart';
import 'package:laptop_harbor/models/product_model.dart';
import 'package:laptop_harbor/route/route_constants.dart';

import '../../../../models/products_model.dart';

class MostPopularDynamic extends StatelessWidget {
  const MostPopularDynamic({super.key});

  Future<List<Product>> fetchPopularProducts() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('isPopular', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => Product.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: fetchPopularProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(defaultPadding),
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Padding(
            padding: EdgeInsets.all(defaultPadding),
            child: Text('Error loading popular products'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(defaultPadding),
            child: Text('No popular products found'),
          );
        }

        final popularProducts = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: defaultPadding / 2),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Text(
                "Most popular",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            SizedBox(
              height: 114,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: popularProducts.length,
                itemBuilder: (context, index) {
                  final product = popularProducts[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      left: defaultPadding,
                      right: index == popularProducts.length - 1
                          ? defaultPadding
                          : 0,
                    ),
                    child: SecondaryProductCard(
                      image: product.image,
                      brandName: product.brand,
                      title: product.name,
                      price: product.price,
                      // Optional if not available
                      priceAfetDiscount: product.price,
                      dicountpercent: null,
                      press: () {
                        Navigator.pushNamed(
                          context,
                          productDetailsScreenRoute,
                          arguments: product.id,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
