import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laptop_harbor/models/products_model.dart';
import 'package:laptop_harbor/models/review_model.dart';
import 'package:intl/intl.dart';

class SubmitReviewScreen extends StatefulWidget {
  final Product product;

  const SubmitReviewScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<SubmitReviewScreen> createState() => _SubmitReviewScreenState();
}

class _SubmitReviewScreenState extends State<SubmitReviewScreen> {
  final TextEditingController _controller = TextEditingController();
  double _rating = 0;
  List<Review> _reviews = [];
  bool _isLoading = true;

  Future<void> _fetchReviews() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('productId', isEqualTo: widget.product.id)
          .orderBy('timestamp', descending: true)
          .get();

      setState(() {
        _reviews = snapshot.docs
            .map((doc) => Review.fromFirestore(doc.data(), doc.id))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      print("🔥 Error fetching reviews: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitReview() async {
    if (_controller.text.trim().isEmpty || _rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please give a rating and comment.")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('reviews').add({
        'productId': widget.product.id,
        'rating': _rating,
        'comment': _controller.text.trim(),
        'timestamp': Timestamp.now(),
      });

      _controller.clear();
      _rating = 0;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Review submitted successfully")),
      );

      _fetchReviews(); // Refresh the list
    } catch (e) {
      print("🔥 Error submitting review: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error submitting review")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Write a Review"),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0.5,
        foregroundColor: theme.textTheme.bodyLarge!.color,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.product.name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 24),

            // Rating
            Text("Your Rating:", style: theme.textTheme.titleSmall),
            const SizedBox(height: 6),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  splashRadius: 22,
                  icon: Icon(
                    Icons.star,
                    size: 30,
                    color: index < _rating ? Colors.amber : Colors.grey.shade400,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = (index + 1).toDouble();
                    });
                  },
                );
              }),
            ),

            const SizedBox(height: 24),

            // Comment Box
            Text("Your Review:", style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              maxLines: 5,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: "Write your honest opinion...",
                filled: true,
                fillColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),

            const SizedBox(height: 30),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text("Submit Review", style: TextStyle(fontSize: 16)),
                onPressed: _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Existing Reviews
            const Divider(),
            Text("All Reviews", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_reviews.isEmpty)
              const Text("No reviews yet.")
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _reviews.length,
                itemBuilder: (context, index) {
                  final review = _reviews[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text("⭐ ${review.rating}", style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(review.comment),
                      trailing: Text(
                        DateFormat('MMM d, yyyy').format(review.timestamp),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
