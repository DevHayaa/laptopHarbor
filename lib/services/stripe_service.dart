// lib/services/stripe_service.dart
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StripeService {
  static Future<void> init() async {
    Stripe.publishableKey = 'pk_test_YourPublicKeyHere'; // ✅ Replace with your key
    await Stripe.instance.applySettings();
  }

  static Future<void> makePayment(int amount) async {
    try {
      final url = Uri.parse('http://your-server.com/create-payment-intent'); // 🟡 Your server URL
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'amount': amount}),
      );

      final jsonResponse = jsonDecode(response.body);
      final clientSecret = jsonResponse['clientSecret'];

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Laptop Harbor',
        ),
      );

      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      throw Exception('Stripe error: $e');
    }
  }
}
