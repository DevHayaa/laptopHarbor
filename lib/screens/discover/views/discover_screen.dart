import 'package:flutter/material.dart';
import '../../../models/products_model.dart';
import '../../../services/firebase_service.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  List<Product> gaming = [];
  List<Product> student = [];
  List<Product> business = [];
  List<Product> onSale = [];
  List<Product> allProducts = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    gaming = await _firebaseService.getProductsByCategory('gaming');
    student = await _firebaseService.getProductsByCategory('student');
    business = await _firebaseService.getProductsByCategory('business');
    onSale = await _firebaseService.getProductsByCategory('on sale');
    allProducts = await _firebaseService.getAllProducts();

    setState(() {
      isLoading = false;
    });
  }

  Widget sectionTitle(String emoji, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Text(
        "$emoji  $title",
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget productCard(Product product) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              product.image,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
              const Center(child: Icon(Icons.broken_image)),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Rs. ${product.price.toStringAsFixed(0)}",
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget horizontalProductList(List<Product> products) {
    return SizedBox(
      height: 210,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20, right: 12),
        itemCount: products.length,
        itemBuilder: (context, index) => productCard(products[index]),
      ),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle("🎮", "Gaming Laptops"),
          horizontalProductList(gaming),

          sectionTitle("🎓", "Student Laptops"),
          horizontalProductList(student),

          sectionTitle("💼", "Business Laptops"),
          horizontalProductList(business),

          sectionTitle("🔥", "On Sale"),
          horizontalProductList(onSale),

          sectionTitle("💻", "All Products"),
          horizontalProductList(allProducts),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text(
          "Discover",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : buildBody(),
    );
  }
}
