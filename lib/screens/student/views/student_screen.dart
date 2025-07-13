import 'package:flutter/material.dart';
import 'package:laptop_harbor/services/firebase_service.dart';
import 'package:laptop_harbor/models/products_model.dart';
import 'package:laptop_harbor/components/product/product_card.dart';
import 'package:laptop_harbor/route/route_constants.dart';
import '../../../../constants.dart';

class StudentScreen extends StatelessWidget {
  const StudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Products")),
      body: FutureBuilder<List<Product>>(
        future: FirebaseService().getProductsByCategory("student"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No Student Products Found"));
          }

          final products = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(defaultPadding),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: defaultPadding,
              mainAxisSpacing: defaultPadding,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              print("🖼 Product Image URL: ${product.image}");
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
          );
        },
      ),
    );
  }
}
