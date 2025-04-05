import 'package:flutter/material.dart';
import '../../widgets/wallet_card.dart';
import '../../services/wallet_service.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final WalletService _walletService = WalletService();
  Map<String, dynamic> walletData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWalletData();
  }

  // جلب بيانات المحفظة
  Future<void> _loadWalletData() async {
    try {
      var data = await _walletService.getWallet();
      setState(() {
        walletData = data['balances'] ?? {'BTC': 0.0, 'ETH': 0.0, 'USDT': 0.0};
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to load wallet')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.admin_panel_settings, color: Colors.yellowAccent),
            onPressed: () => Navigator.pushNamed(context, '/admin'),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.grey[900]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _isLoading
            ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.yellowAccent)))
            : RefreshIndicator(
                onRefresh: _loadWalletData,
                color: Colors.yellowAccent,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Portfolio',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: 20),
                      WalletCard(
                        currency: 'BTC',
                        balance: walletData['BTC']?.toStringAsFixed(4) ?? '0.0000',
                      ),
                      SizedBox(height: 16),
                      WalletCard(
                        currency: 'ETH',
                        balance: walletData['ETH']?.toStringAsFixed(4) ?? '0.0000',
                      ),
                      SizedBox(height: 16),
                      WalletCard(
                        currency: 'USDT',
                        balance: walletData['USDT']?.toStringAsFixed(2) ?? '0.00',
                      ),
                      SizedBox(height: 30),
                      Text(
                        'Quick Actions',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton(context, 'Deposit', '/deposit', Colors.green),
                          _buildActionButton(context, 'Withdraw', '/withdraw', Colors.red),
                          _buildActionButton(context, 'Trade', '/trading', Colors.yellow[700]!),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  // بناء زر الإجراء مع تحسين التصميم
  Widget _buildActionButton(BuildContext context, String text, String route, Color color) {
    return ElevatedButton(
      onPressed: () => Navigator.pushNamed(context, route),
      child: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}