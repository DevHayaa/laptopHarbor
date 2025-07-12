// 📁 File: lib/screens/add_products_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProductsScreen extends StatefulWidget {
  const AddProductsScreen({super.key});

  @override
  State<AddProductsScreen> createState() => _AddProductsScreenState();
}

class _AddProductsScreenState extends State<AddProductsScreen> {
  @override
  void initState() {
    super.initState();
    // ✅ Commented to avoid duplicate uploads after first time
    // addMultipleProducts();
  }

  void addMultipleProducts() async {
    List<Map<String, dynamic>> products = [
      // --- Student (5 products) ---
      {
        'name': 'Acer Aspire 5',
        'price': 120000,
        'description': '15.6” FHD, Intel i5, 8GB RAM, 256GB SSD',
        'image': 'https://m.media-amazon.com/images/I/71vvXGmdKWL._AC_SL1500_.jpg',
        'isPopular': false,
        'brands': 'Acer',
        'categories': ['student'],
        'stock': 15,
        'rating': '4.4',
        'specs': {
          'display': '15.6 inch FHD',
          'processor': 'Intel i5-1135G7',
          'ram': '8GB',
          'storage': '256GB SSD',
        }
      },
      {
        'name': 'HP Pavilion 14',
        'price': 130000,
        'description': '14” HD, AMD Ryzen 5, 8GB RAM, 512GB SSD',
        'image': 'https://m.media-amazon.com/images/I/71wF7YDIQkL._AC_SL1500_.jpg',
        'isPopular': false,
        'brands': 'HP',
        'categories': ['student'],
        'stock': 18,
        'rating': '4.3',
        'specs': {
          'display': '14 inch HD',
          'processor': 'Ryzen 5 5500U',
          'ram': '8GB',
          'storage': '512GB SSD',
        }
      },
      {
        'name': 'Lenovo IdeaPad 3',
        'price': 115000,
        'description': '15.6” FHD, Intel i3, 8GB RAM, 256GB SSD',
        'image': 'https://m.media-amazon.com/images/I/71hG+e7roXL._AC_SL1500_.jpg',
        'isPopular': false,
        'brands': 'Lenovo',
        'categories': ['student'],
        'stock': 20,
        'rating': '4.2',
        'specs': {
          'display': '15.6 inch FHD',
          'processor': 'Intel i3-1115G4',
          'ram': '8GB',
          'storage': '256GB SSD',
        }
      },
      {
        'name': 'Dell Inspiron 15',
        'price': 125000,
        'description': '15.6” FHD, Intel i5, 8GB RAM, 512GB SSD',
        'image': 'https://m.media-amazon.com/images/I/71pB+e7roXL._AC_SL1500_.jpg',
        'isPopular': false,
        'brands': 'Dell',
        'categories': ['student'],
        'stock': 17,
        'rating': '4.5',
        'specs': {
          'display': '15.6 inch FHD',
          'processor': 'Intel i5-11300H',
          'ram': '8GB',
          'storage': '512GB SSD',
        }
      },
      {
        'name': 'ASUS VivoBook 15',
        'price': 118000,
        'description': '15.6” FHD, AMD Ryzen 5, 8GB RAM, 256GB SSD',
        'image': 'https://m.media-amazon.com/images/I/81p9P4e7OQL._AC_SL1500_.jpg',
        'isPopular': false,
        'brands': 'ASUS',
        'categories': ['student'],
        'stock': 22,
        'rating': '4.4',
        'specs': {
          'display': '15.6 inch FHD',
          'processor': 'Ryzen 5 5500U',
          'ram': '8GB',
          'storage': '256GB SSD',
        }
      },

      // --- On Sale (5 products) ---
      {
        'name': 'Lenovo Flex 5',
        'price': 110000,
        'description': '14” 2-in-1 Touch, Ryzen 5, 8GB RAM, 256GB SSD',
        'image': 'https://m.media-amazon.com/images/I/81AbJXWCxXL._AC_SL1500_.jpg',
        'isPopular': true,
        'brands': 'Lenovo',
        'categories': ['on_sale'],
        'stock': 10,
        'rating': '4.6',
        'specs': {
          'display': '14 inch Touch',
          'processor': 'Ryzen 5 5500U',
          'ram': '8GB',
          'storage': '256GB SSD',
        }
      },
      {
        'name': 'Dell Vostro 3405',
        'price': 105000,
        'description': '14” HD, AMD Ryzen 3, 4GB RAM, 1TB HDD',
        'image': 'https://m.media-amazon.com/images/I/61z1ksPSfsL._AC_SL1500_.jpg',
        'isPopular': false,
        'brands': 'Dell',
        'categories': ['on_sale'],
        'stock': 13,
        'rating': '4.2',
        'specs': {
          'display': '14 inch HD',
          'processor': 'Ryzen 3 3250U',
          'ram': '4GB',
          'storage': '1TB HDD',
        }
      },
      {
        'name': 'HP Chromebook x360',
        'price': 99000,
        'description': '14” Touch, Intel Celeron, 4GB RAM, 64GB eMMC',
        'image': 'https://m.media-amazon.com/images/I/81zKgTz7DOL._AC_SL1500_.jpg',
        'isPopular': true,
        'brands': 'HP',
        'categories': ['on_sale'],
        'stock': 30,
        'rating': '4.1',
        'specs': {
          'display': '14 inch Touch',
          'processor': 'Intel Celeron N4020',
          'ram': '4GB',
          'storage': '64GB eMMC',
        }
      },
      {
        'name': 'ASUS Chromebook Flip',
        'price': 95000,
        'description': '14” Touch, Intel Pentium Silver, 4GB RAM, 64GB eMMC',
        'image': 'https://m.media-amazon.com/images/I/71m03ZBKc1L._AC_SL1500_.jpg',
        'isPopular': false,
        'brands': 'ASUS',
        'categories': ['on_sale'],
        'stock': 25,
        'rating': '4.3',
        'specs': {
          'display': '14 inch Touch',
          'processor': 'Intel Pentium N6000',
          'ram': '4GB',
          'storage': '64GB eMMC',
        }
      },
      {
        'name': 'Acer Chromebook Spin 311',
        'price': 89000,
        'description': '11.6” Touch, MediaTek MT8183, 4GB RAM, 32GB eMMC',
        'image': 'https://m.media-amazon.com/images/I/71WxGUNeSSL._AC_SL1500_.jpg',
        'isPopular': false,
        'brands': 'Acer',
        'categories': ['on_sale'],
        'stock': 28,
        'rating': '4.0',
        'specs': {
          'display': '11.6 inch Touch',
          'processor': 'MediaTek MT8183',
          'ram': '4GB',
          'storage': '32GB eMMC',
        }
      }
    ];

    final collection = FirebaseFirestore.instance.collection('products');

    for (var product in products) {
      await collection.add(product);
    }

    print("✅ Products added successfully");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Products uploaded to Firebase!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Adding products...")),
    );
  }
}
