import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailService {
  static Future<void> sendOrderConfirmation({
    required String name,
    required String email,
    required double totalAmount,
  }) async {
    const serviceId = 'service_imb438l';
    const templateId = 'template_kn5sxzk';
    const userId = 'n5A7Qa_GA5p-qS4qc';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final bodyData = {
      'service_id': serviceId,
      'template_id': templateId,
      'user_id': userId,
      'template_params': {
        'user_name': name,
        'email': email, // ✅ Must match with `{{email}}` in template
        'order_total': totalAmount.toStringAsFixed(2),
      }
    };

    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode(bodyData),
    );

    print("📩 EmailJS Response Code: ${response.statusCode}");
    print("📩 EmailJS Response Body: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception('Failed to send confirmation email');
    }
  }
}
