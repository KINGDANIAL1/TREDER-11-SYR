
import 'package:flutter/material.dart';
import '../../widgets/wallet_card.dart';
import '../../services/wallet_service.dart';

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final WalletService _walletService = WalletService();
  Map<String, dynamic> walletData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWallet();
  }

  // جلب بيانات المحفظة
  Future<void> _fetchWallet() async {
    try {
      var data = await _walletService.getWallet();
      setState(() {
        walletData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wallet')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            WalletCard(currency: 'BTC', balance: walletData['btc']?.toString() ?? '0.0'),
            WalletCard(currency: 'ETH', balance: walletData['eth']?.toString() ?? '0.0'),
            WalletCard(currency: 'USDT', balance: walletData['usdt']?.toString() ?? '0.0'),
          ],
        ),
      ),
    );
  }
}