import 'package:flutter/material.dart';
import 'package:laptop_harbor/models/products_model.dart';
import 'package:provider/provider.dart';
import 'package:laptop_harbor/providers/cart_provider.dart';

class ProductFullDetailScreen extends StatelessWidget {
  final Product product;

  const ProductFullDetailScreen({Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isInStock = product.stock > 0;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0.4,
        foregroundColor: theme.textTheme.bodyLarge!.color,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton.icon(
          onPressed: isInStock
              ? () async {
            await Provider.of<CartProvider>(context, listen: false)
                .addToCart(product);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('✅ Added to Cart')),
            );
          }
              : null,
          icon: const Icon(Icons.shopping_cart_outlined),
          label: const Text(
            "Add to Cart",
            style: TextStyle(fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            disabledBackgroundColor: Colors.grey.shade400,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              product.image,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
              const Icon(Icons.broken_image, size: 100, color: Colors.grey),
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return SizedBox(
                  height: 250,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: progress.expectedTotalBytes != null
                          ? progress.cumulativeBytesLoaded /
                          (progress.expectedTotalBytes ?? 1)
                          : null,
                      strokeWidth: 2,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // Title
          Text(
            product.name,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 6),

          // Brand
          Text(
            "Brand: ${product.brand}",
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
          ),

          const SizedBox(height: 16),

          // Price & Stock
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Rs. ${product.price.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              Text(
                isInStock ? "In Stock" : "Out of Stock",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isInStock ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),

          const Divider(height: 32),

          // Description
          const Text("Description",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 6),
          Text(
            product.description,
            style: const TextStyle(fontSize: 15, height: 1.5),
          ),

          const SizedBox(height: 24),

          // Specifications
          if (product.specs.isNotEmpty) ...[
            const Text("Specifications",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            ...product.specs.entries.map(
                  (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        "${entry.key}:",
                        style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(
                        entry.value,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
