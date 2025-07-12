class OrderModel {
  final String id;
  final String userId;
  final List<Map<String, dynamic>> items;
  final double totalAmount;
  final String shippingAddress;
  final String phone;
  final String city;
  final String postalCode;
  final String fullName;
  final String paymentMethod;
  final String status; // e.g. pending, shipped, delivered
  final DateTime orderDate;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.shippingAddress,
    required this.phone,
    required this.city,
    required this.postalCode,
    required this.fullName,
    required this.paymentMethod,
    required this.status,
    required this.orderDate,
  });

  // ✅ Convert OrderModel to Map (for Firebase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items,
      'totalAmount': totalAmount,
      'shippingAddress': shippingAddress,
      'phone': phone,
      'city': city,
      'postalCode': postalCode,
      'fullName': fullName,
      'paymentMethod': paymentMethod,
      'status': status,
      'orderDate': orderDate.toIso8601String(),
    };
  }

  // ✅ Convert Firebase data to OrderModel
  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'],
      userId: map['userId'],
      items: List<Map<String, dynamic>>.from(map['items']),
      totalAmount: (map['totalAmount'] as num).toDouble(),
      shippingAddress: map['shippingAddress'],
      phone: map['phone'],
      city: map['city'],
      postalCode: map['postalCode'],
      fullName: map['fullName'],
      paymentMethod: map['paymentMethod'],
      status: map['status'],
      orderDate: DateTime.parse(map['orderDate']),
    );
  }
}
