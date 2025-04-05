import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constants.dart';

class WalletService {
  String? _token; // يتم تحديثه ديناميكيًا

  // تحديث رمز المصادقة
  void setToken(String token) {
    _token = token;
  }

  // جلب بيانات المحفظة
  Future<Map<String, dynamic>> getWallet() async {
    if (_token == null) throw Exception('Token is not set');
    try {
      final response = await http.get(
        Uri.parse('$BASE_URL/wallet'),
        headers: {'Authorization': 'Bearer $_token'},
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to load wallet');
    }
  }

  // جلب عنوان الإيداع
  Future<String> getDepositAddress(String currency) async {
    if (_token == null) throw Exception('Token is not set');
    try {
      final response = await http.get(
        Uri.parse('$BASE_URL/wallet/deposit-address?currency=$currency'),
        headers: {'Authorization': 'Bearer $_token'},
      );
      return jsonDecode(response.body)['address'];
    } catch (e) {
      throw Exception('Failed to load address');
    }
  }

  // طلب السحب
  Future<Map<String, dynamic>> requestWithdrawal(String currency, String amount, String address) async {
    if (_token == null) throw Exception('Token is not set');
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/wallet/withdraw'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({
          'currency': currency,
          'amount': amount,
          'address': address,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error'};
    }
  }

  // جلب سجل المعاملات
  Future<List<dynamic>> getTransactionHistory(String userId) async {
    if (_token == null) throw Exception('Token is not set');
    try {
      final response = await http.get(
        Uri.parse('$BASE_URL/wallet/transactions?userId=$userId'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
