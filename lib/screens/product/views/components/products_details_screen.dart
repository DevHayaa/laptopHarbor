import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:laptop_harbor/screens/product/views/components/product_images.dart';
import 'package:laptop_harbor/screens/product/views/components/product_info.dart';
import 'package:laptop_harbor/screens/product/views/components/product_list_tile.dart';
import 'package:laptop_harbor/components/cart_button.dart';
import 'package:laptop_harbor/components/product/product_card.dart';
import 'package:laptop_harbor/constants.dart';
import 'package:laptop_harbor/models/products_model.dart';
import 'package:laptop_harbor/models/review_model.dart';
import 'package:laptop_harbor/providers/cart_provider.dart';
import 'package:laptop_harbor/route/screen_export.dart';
import '../product_returns_screen.dart';
import 'notify_me_card.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  List<Review> _reviews = [];
  bool _isLoadingReviews = true;
  bool isWishlisted = false;

  Future<void> _fetchReviews(String productId) async {
    setState(() {
      _isLoadingReviews = true;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('productId', isEqualTo: productId)
          .orderBy('timestamp', descending: true)
          .get();

      setState(() {
        _reviews = snapshot.docs
            .map((doc) => Review.fromFirestore(doc.data(), doc.id))
            .toList();
        _isLoadingReviews = false;
      });
    } catch (e) {
      print("🔥 Error fetching reviews: $e");
      setState(() {
        _isLoadingReviews = false;
      });
    }
  }

  Future<void> checkIfWishlisted(String productId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .doc(productId)
        .get();

    setState(() {
      isWishlisted = doc.exists;
    });
  }

  Future<void> toggleWishlist(Product product) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final wishlistRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .doc(product.id);

    if (isWishlisted) {
      await wishlistRef.delete();
      setState(() {
        isWishlisted = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Removed from Wishlist")),
      );
    } else {
      await wishlistRef.set({
        'image': product.image,
        'brandName': product.brand,
        'title': product.name,
        'price': product.price,
        'timestamp': Timestamp.now(),
      });
      setState(() {
        isWishlisted = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Added to Wishlist")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final product = ModalRoute.of(context)!.settings.arguments as Product;
      _fetchReviews(product.id);
      checkIfWishlisted(product.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      bottomNavigationBar: product.stock > 0
          ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: ElevatedButton.icon(
          icon: const Icon(Icons.shopping_cart_checkout),
          onPressed: () async {
            await Provider.of<CartProvider>(context, listen: false)
                .addToCart(product);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Added to Cart")),
            );
            Future.delayed(const Duration(milliseconds: 500), () {
              Navigator.pushNamed(context, cartScreenRoute);
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColorDark,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          label:
          const Text("Add to Cart", style: TextStyle(fontSize: 16)),
        ),
      )
          : NotifyMeCard(
        isNotify: false,
        onChanged: (value) {},
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              floating: true,
              actions: [
                IconButton(
                  onPressed: () {
                    toggleWishlist(product);
                  },
                  icon: Icon(
                    isWishlisted
                        ? Icons.bookmark
                        : Icons.bookmark_border_outlined,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ],
            ),
            ProductImages(images: [product.image]),
            ProductInfo(
              brand: product.brand,
              title: product.name,
              isAvailable: product.stock > 0,
              description: product.description,
              numOfReviews: _reviews.length,
              rating: product.rating,
            ),
            ProductListTile(
              svgSrc: "assets/icons/Product.svg",
              title: "Product Details",
              press: () {
                Navigator.pushNamed(
                  context,
                  productFullDetailScreenRoute,
                  arguments: product,
                );
              },
            ),
            ProductListTile(
              svgSrc: "assets/icons/Return.svg",
              title: "Returns",
              isShowBottomBorder: true,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ProductReturnsScreen()),
                );
              },
            ),

            // --- Reviews Section ---
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Customer Reviews",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await Navigator.pushNamed(
                          context,
                          productReviewsScreenRoute,
                          arguments: product,
                        );
                        _fetchReviews(product.id);
                      },
                      icon: const Icon(Icons.rate_review_outlined),
                      label: const Text("Write a Review"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColorDark,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_isLoadingReviews)
                      const Center(child: CircularProgressIndicator())
                    else if (_reviews.isEmpty)
                      const Text("No reviews yet.")
                    else
                      Column(
                        children: _reviews
                            .take(2)
                            .map(
                              (review) => Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            margin:
                            const EdgeInsets.symmetric(vertical: 6),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.star,
                                          color: Colors.amber, size: 18),
                                      const SizedBox(width: 4),
                                      Text("${review.rating}"),
                                      const Spacer(),
                                      Text(
                                        review.timestamp
                                            .toString()
                                            .split(' ')
                                            .first,
                                        style:
                                        const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    review.comment,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                            .toList(),
                      ),
                    if (_reviews.length > 2)
                      TextButton(
                        onPressed: () async {
                          await Navigator.pushNamed(
                            context,
                            productReviewsScreenRoute,
                            arguments: product,
                          );
                          _fetchReviews(product.id);
                        },
                        child: const Text("See all reviews"),
                      ),
                  ],
                ),
              ),
            ),

            // --- Recommended Products ---
            SliverPadding(
              padding: const EdgeInsets.all(defaultPadding),
              sliver: SliverToBoxAdapter(
                child: Text(
                  "You may also like",
                  style: Theme.of(context).textTheme.titleSmall!,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(
                      left: defaultPadding,
                      right: index == 4 ? defaultPadding : 0,
                    ),
                    child: ProductCard(
                      image: product.image,
                      title: product.name,
                      brandName: product.brand,
                      price: product.price,
                      press: () {},
                    ),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: defaultPadding)),
          ],
        ),
      ),
    );
  }
}
