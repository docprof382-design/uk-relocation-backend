import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // حط رابط الباك إند الحقيقي هنا (اللي رافعينه على Vercel أو سيرفرك)
  static const String baseUrl = 'https://uk-relocation-backend.vercel.app';

  // مثال لدالة إرسال البيانات (حسب نسختك الحالية اللي بتودي لـ Stripe)
  static Future> submitUserData(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/submit-user'), // عدل المسار حسب الراوت عندك في الباك إند
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('فشل الخادم في الرد: ${response.body}');
      }
    } catch (e) {
      throw Exception('خطأ في الاتصال بالشبكة: $e');
    }
  }
}