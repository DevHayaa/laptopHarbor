import 'package:flutter/material.dart';
import 'package:laptop_harbor/components/product/product_card.dart';
import 'package:laptop_harbor/models/product_model.dart';
import 'package:laptop_harbor/services/firebase_service.dart';
import '../../../../constants.dart';
import '../../../../models/products_model.dart';
import '../../../../route/route_constants.dart';

class BestSellersDynamic extends StatelessWidget {
  const BestSellersDynamic({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: FirebaseService().getBestSellers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No best sellers found"));
        }

        final products = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: defaultPadding / 2),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Text(
                "Best sellers",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      left: defaultPadding,
                      right: index == products.length - 1 ? defaultPadding : 0,
                    ),
                    child: ProductCard(
                      image: product.image,
                      brandName: product.brand ?? '',
                      title: product.name,
                      price: product.price,
                      press: () {
                        Navigator.pushNamed(
                          context,
                          productDetailsScreenRoute,
                          arguments: product,
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
