import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text("You are not logged in")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: userId)
        // You can uncomment below once index is created:
        // .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("🔥 Firestore Error: ${snapshot.error}");
            return const Center(child: Text("Something went wrong"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];
          print("📦 Fetched orders: ${docs.length}");

          if (docs.isEmpty) {
            return const Center(
              child: Text("You haven't placed any orders yet."),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final shipping = data['shipping'] ?? {};
              final items = data['items'] ?? [];

              return Card(
                margin: const EdgeInsets.all(12),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                  title: Text("Order #${data['orderId']}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Status: ${data['status'] ?? 'Pending'}"),
                      Text("Total: Rs. ${data['totalAmount']}"),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Shipping Information:",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text("Name: ${shipping['name'] ?? 'N/A'}"),
                          Text("Phone: ${shipping['phone'] ?? 'N/A'}"),
                          Text("City: ${shipping['city'] ?? 'N/A'}"),
                          Text("Address: ${shipping['address'] ?? 'N/A'}"),
                          const SizedBox(height: 10),
                          const Text("Items Ordered:",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          ...List.generate(items.length, (i) {
                            final item = items[i];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2.0),
                              child: Text("• ${item['title']} x${item['quantity']}"),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
