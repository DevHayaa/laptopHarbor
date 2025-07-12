import 'package:flutter/material.dart';
import 'package:laptop_harbor/components/product/product_card.dart';
import 'package:laptop_harbor/models/products_model.dart';
import 'package:laptop_harbor/services/firebase_service.dart';
import 'package:laptop_harbor/route/route_constants.dart';

import '../../../../constants.dart';

class GamingProductsSlider extends StatelessWidget {
  const GamingProductsSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: defaultPadding / 2),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            "Top Gaming Laptops",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        FutureBuilder<List<Product>>(
          future: FirebaseService().getGamingProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No Gaming Products Found"));
            }

            final products = snapshot.data!;

            return SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      left: defaultPadding,
                      right:
                      index == products.length - 1 ? defaultPadding : 0,
                    ),
                    child: ProductCard(
                      image: product.image,
                      brandName: product.name,
                      title: product.categories.join(', '),
                      price: product.price,
                      priceAfetDiscount: product.price,
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
            );
          },
        )
      ],
    );
  }
}
