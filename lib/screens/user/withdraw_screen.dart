
import 'package:flutter/material.dart';
import '../../services/wallet_service.dart';
import '../../widgets/custom_button.dart';
import '../../utils/validators.dart';

class WithdrawScreen extends StatefulWidget {
  @override
  _WithdrawScreenState createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final WalletService _walletService = WalletService();
  final _amountController = TextEditingController();
  final _addressController = TextEditingController();
  String selectedCurrency = 'BTC';
  bool _isLoading = false;

  // طلب السحب
  void _requestWithdrawal() async {
    if (!_validateInputs()) return;
    setState(() => _isLoading = true);
    String amount = _amountController.text.trim();
    String address = _addressController.text.trim();
    var response = await _walletService.requestWithdrawal(selectedCurrency, amount, address);
    setState(() => _isLoading = false);
    if (response['success']) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Withdrawal request sent')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response['message'] ?? 'Withdrawal failed')));
    }
  }

  // التحقق من المدخلات
  bool _validateInputs() {
    if (!Validators.isValidAmount(_amountController.text)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Invalid amount')));
      return false;
    }
    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Address required')));
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Withdraw')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Withdraw Funds', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: selectedCurrency,
              items: ['BTC', 'ETH', 'USDT']
                  .map((currency) => DropdownMenuItem(
                value: currency,
                child: Text(currency),
              ))
                  .toList(),
              onChanged: (value) => setState(() => selectedCurrency = value!),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Withdrawal Address',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),
            _isLoading
                ? CircularProgressIndicator()
                : CustomButton(
              text: 'Request Withdrawal',
              onPressed: _requestWithdrawal,
              width: 200,
            ),
          ],
        ),
      ),
    );
  }
}