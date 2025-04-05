
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constants.dart';

class TradingService {
  final String token = 'your_jwt_token_here';

  // جلب بيانات السوق
  Future<Map<String, dynamic>> getMarketData(String pair) async {
    try {
      final response = await http.get(
        Uri.parse('$BASE_URL/trading/market?pair=$pair'),
        headers: {'Authorization': 'Bearer $token'},
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to load market data');
    }
  }

  // وضع أمر تداول
  Future<Map<String, dynamic>> placeOrder(String pair, String type, String amount) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/trading/order'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'pair': pair,
          'type': type,
          'amount': amount,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error'};
    }
  }
}