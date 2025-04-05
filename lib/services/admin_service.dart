
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constants.dart';

class AdminService {
  final String token = 'your_jwt_token_here';

  // جلب المعاملات المعلقة
  Future<List<Map<String, dynamic>>> getPendingTransactions() async {
    try {
      final response = await http.get(
        Uri.parse('$BASE_URL/admin/transactions/pending'),
        headers: {'Authorization': 'Bearer $token'},
      );
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } catch (e) {
      throw Exception('Failed to load transactions');
    }
  }

  // معالجة المعاملة
  Future<Map<String, dynamic>> handleTransaction(String transactionId, String action) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/admin/transactions/handle'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'transactionId': transactionId,
          'action': action,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error'};
    }
  }

  // جلب عناوين الإيداع
  Future<Map<String, String>> getDepositAddresses() async {
    try {
      final response = await http.get(
        Uri.parse('$BASE_URL/admin/addresses'),
        headers: {'Authorization': 'Bearer $token'},
      );
      return Map<String, String>.from(jsonDecode(response.body));
    } catch (e) {
      throw Exception('Failed to load addresses');
    }
  }

  // تغيير عنوان الإيداع
  Future<Map<String, dynamic>> changeDepositAddress(String currency) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/admin/addresses/change'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'currency': currency}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error'};
    }
  }
}