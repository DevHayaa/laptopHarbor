import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laptop_harbor/constants.dart';
import 'package:laptop_harbor/route/route_constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data?.data() == null) {
            return const Center(child: Text("User profile not found."));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: data['profileImage'] != null && data['profileImage'].toString().isNotEmpty
                          ? NetworkImage(data['profileImage'])
                          : null,
                      child: data['profileImage'] == null || data['profileImage'].toString().isEmpty
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                    const SizedBox(height: 10),
                    Text(data['name'] ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(data['email'] ?? '', style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, editProfileScreenRoute),
                      child: const Text("Edit Profile"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              const Divider(),

              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text("Account", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),

              _buildListTile(context, "Orders", Icons.shopping_bag, ordersScreenRoute),
              _buildListTile(context, "Wishlist", Icons.favorite_border, wishlistScreenRoute),

              /// ✅ Dynamic Addresses from Orders
              FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user!.uid)
                    .collection('orders')
                    .get(),
                builder: (context, addressSnapshot) {
                  if (addressSnapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(title: Text("Loading Addresses..."));
                  }

                  final orders = addressSnapshot.data?.docs ?? [];
                  final uniqueAddresses = orders
                      .map((doc) => doc['shippingAddress'])
                      .where((address) => address != null)
                      .toSet()
                      .toList();

                  return _buildListTile(
                    context,
                    "Addresses (${uniqueAddresses.length})",
                    Icons.location_on_outlined,
                    addressesScreenRoute,
                  );
                },
              ),

              /// ✅ Show Payment Methods only if available
              FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .collection('paymentMethods')
                    .get(),
                builder: (context, paymentSnapshot) {
                  if (paymentSnapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(title: Text("Loading Payment Methods..."));
                  }

                  final hasPayment = paymentSnapshot.data?.docs.isNotEmpty ?? false;
                  return hasPayment
                      ? _buildListTile(context, "Payment Methods", Icons.credit_card, paymentScreenRoute)
                      : const SizedBox();
                },
              ),

              _buildListTile(context, "Change Password", Icons.lock_outline, changePasswordScreenRoute),

              const SizedBox(height: 30),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text("Logout", style: TextStyle(color: Colors.red)),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(context, logInScreenRoute, (_) => false);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildListTile(BuildContext context, String title, IconData icon, String route) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => Navigator.pushNamed(context, route),
    );
  }
}
