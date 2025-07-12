import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:laptop_harbor/providers/cart_provider.dart';
import 'package:laptop_harbor/providers/order_provider.dart';
import 'package:laptop_harbor/services/stripe_service.dart';
import 'package:laptop_harbor/services/email_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _addressController = TextEditingController();

  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  String _selectedPaymentMethod = "Cash on Delivery";
  bool _isLoading = false;

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedPaymentMethod == "Credit Card") {
      if (_cardNumberController.text.trim().isEmpty ||
          _expiryController.text.trim().isEmpty ||
          _cvvController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❗ Please fill in all credit card details')),
        );
        return;
      }
    }

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final cartItems = cartProvider.items.values.toList();

    final cartTotal = cartProvider.totalPrice;
    const shippingFee = 200.0;
    const taxRate = 0.05;
    final taxAmount = cartTotal * taxRate;
    final total = cartTotal + shippingFee + taxAmount;

    setState(() => _isLoading = true);

    try {
      if (_selectedPaymentMethod == "Credit Card") {
        final amountInCents = (total * 100).toInt();
        await StripeService.makePayment(amountInCents);
      }

      await orderProvider.placeOrder(
        cartItems: cartItems,
        totalAmount: total,
        fullName: _fullNameController.text.trim(),
        phone: _phoneController.text.trim(),
        city: _cityController.text.trim(),
        postalCode: _postalCodeController.text.trim(),
        shippingAddress: _addressController.text.trim(),
        paymentMethod: _selectedPaymentMethod,
      );

      await EmailService.sendOrderConfirmation(
        name: _fullNameController.text,
        email: FirebaseAuth.instance.currentUser?.email ?? '',
        totalAmount: total,
      );

      await cartProvider.clearCart();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Order placed successfully!')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Order failed: $e')),
      );
    }

    setState(() => _isLoading = false);
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildSummaryRow(String title, double value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text("Rs. ${value.toStringAsFixed(2)}", style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartTotal = Provider.of<CartProvider>(context).totalPrice;
    const shippingFee = 200.0;
    const taxRate = 0.05;
    final taxAmount = cartTotal * taxRate;
    final total = cartTotal + shippingFee + taxAmount;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Shipping Information", style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),

                _buildTextField(
                  controller: _fullNameController,
                  label: "Full Name",
                  validator: (value) => value == null || value.trim().isEmpty ? "Full name is required" : null,
                ),
                _buildTextField(
                  controller: _phoneController,
                  label: "Phone",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Phone number is required";
                    } else if (!RegExp(r'^\d{11}$').hasMatch(value.trim())) {
                      return "Enter a valid 11-digit phone number";
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  controller: _cityController,
                  label: "City",
                  validator: (value) => value == null || value.trim().isEmpty ? "City is required" : null,
                ),
                _buildTextField(
                  controller: _postalCodeController,
                  label: "Postal Code",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Postal Code is required";
                    } else if (!RegExp(r'^\d{4,6}$').hasMatch(value.trim())) {
                      return "Enter a valid Postal Code";
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  controller: _addressController,
                  label: "Address",
                  maxLines: 2,
                  validator: (value) => value == null || value.trim().isEmpty ? "Address is required" : null,
                ),

                const SizedBox(height: 20),
                Text("Payment Method", style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedPaymentMethod,
                  items: const [
                    DropdownMenuItem(value: "Cash on Delivery", child: Text("Cash on Delivery")),
                    DropdownMenuItem(value: "Credit Card", child: Text("Credit Card")),
                  ],
                  onChanged: (val) => setState(() => _selectedPaymentMethod = val!),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),

                if (_selectedPaymentMethod == "Credit Card") ...[
                  const SizedBox(height: 14),
                  _buildTextField(
                    controller: _cardNumberController,
                    label: "Card Number",
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Card number is required";
                      } else if (!RegExp(r'^\d{16}$').hasMatch(value.trim().replaceAll(' ', ''))) {
                        return "Enter a valid 16-digit card number";
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _expiryController,
                    label: "Expiry Date (MM/YY)",
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Expiry date is required";
                      } else if (!RegExp(r'^(0[1-9]|1[0-2])\/([0-9]{2})$').hasMatch(value.trim())) {
                        return "Enter a valid expiry (MM/YY)";
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _cvvController,
                    label: "CVV",
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "CVV is required";
                      } else if (!RegExp(r'^\d{3}$').hasMatch(value.trim())) {
                        return "Enter valid 3-digit CVV";
                      }
                      return null;
                    },
                  ),
                ],

                const SizedBox(height: 30),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 2,
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Order Summary", style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 10),
                        _buildSummaryRow("Subtotal", cartTotal),
                        _buildSummaryRow("Tax (5%)", taxAmount),
                        _buildSummaryRow("Shipping", shippingFee),
                        const Divider(),
                        _buildSummaryRow("Total", total, isBold: true),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitOrder,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Place Order"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
