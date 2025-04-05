import 'package:flutter/material.dart';
import '../../services/wallet_service.dart';
import '../../widgets/custom_button.dart';

class DepositScreen extends StatefulWidget {
  @override
  _DepositScreenState createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final WalletService _walletService = WalletService();
  String selectedCurrency = 'BTC';
  String depositAddress = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDepositAddress();
  }

  // جلب عنوان الإيداع
  Future<void> _fetchDepositAddress() async {
    try {
      var address = await _walletService.getDepositAddress(selectedCurrency);
      setState(() {
        depositAddress = address;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to load address')));
    }
  }

  // طلب الإيداع
  void _requestDeposit() {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Deposit request sent to admin')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Deposit')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Deposit Funds', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: selectedCurrency,
              items: ['BTC', 'ETH', 'USDT']
                  .map((currency) => DropdownMenuItem(
                value: currency,
                child: Text(currency),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCurrency = value!;
                  _isLoading = true;
                  _fetchDepositAddress();
                });
              },
            ),
            SizedBox(height: 20),
            Text('Deposit Address:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            SelectableText(depositAddress, style: TextStyle(color: Colors.yellow)),
            SizedBox(height: 30),
            CustomButton(
              text: 'Request Deposit',
              onPressed: _requestDeposit,
              width: 200,
            ),
          ],
        ),
      ),
    );
  }
}