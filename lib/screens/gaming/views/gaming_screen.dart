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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Top Gaming Laptops"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<Product>>(
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

          return SingleChildScrollView(
            padding: const EdgeInsets.all(defaultPadding),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: defaultPadding,
                mainAxisSpacing: defaultPadding,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(
                  image: product.image,
                  brandName: product.name,
                  title: product.brand,
                  price: product.price,
                  press: () {
                    Navigator.pushNamed(
                      context,
                      productDetailsScreenRoute,
                      arguments: product,
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
