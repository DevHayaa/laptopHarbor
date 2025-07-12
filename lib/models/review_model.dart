import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String productId;
  final double rating;
  final String comment;
  final DateTime timestamp;

  Review({
    required this.id,
    required this.productId,
    required this.rating,
    required this.comment,
    required this.timestamp,
  });

  factory Review.fromFirestore(Map<String, dynamic> data, String id) {
    return Review(
      id: id,
      productId: data['productId'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      comment: data['comment'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
