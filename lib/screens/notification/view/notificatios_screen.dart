import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  // Sample dynamic notifications data
  final List<Map<String, String>> notifications = const [
    {
      "title": "Order Shipped",
      "message": "Your order #1234 has been shipped.",
      "time": "2h ago"
    },
    {
      "title": "New Offer!",
      "message": "Get 25% off on accessories today.",
      "time": "5h ago"
    },
    {
      "title": "Welcome!",
      "message": "Thank you for joining Laptop Harbor.",
      "time": "1d ago"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              "assets/icons/DotsV.svg",
              colorFilter: ColorFilter.mode(
                Theme.of(context).iconTheme.color!,
                BlendMode.srcIn,
              ),
            ),
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: ListTile(
              leading: const Icon(Icons.notifications, color: Colors.deepPurple),
              title: Text(notification["title"]!),
              subtitle: Text(notification["message"]!),
              trailing: Text(
                notification["time"]!,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ),
          );
        },
      ),
    );
  }
}
