
import 'package:flutter/material.dart';
import '../../services/admin_service.dart';
import '../../widgets/custom_button.dart';

class AdminAddressManagementScreen extends StatefulWidget {
  @override
  _AdminAddressManagementScreenState createState() => _AdminAddressManagementScreenState();
}

class _AdminAddressManagementScreenState extends State<AdminAddressManagementScreen> {
  final AdminService _adminService = AdminService();
  Map<String, String> addresses = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  // جلب العناوين
  Future<void> _loadAddresses() async {
    try {
      var data = await _adminService.getDepositAddresses();
      setState(() {
        addresses = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  // تغيير عنوان الإيداع
  void _changeAddress(String currency) async {
    try {
      var response = await _adminService.changeDepositAddress(currency);
      if (response['success']) {
        setState(() => addresses[currency] = response['newAddress']);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Address updated')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to update address')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Deposit Addresses')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Deposit Addresses', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            _buildAddressRow('BTC'),
            _buildAddressRow('ETH'),
            _buildAddressRow('USDT'),
          ],
        ),
      ),
    );
  }

  // بناء صف العنوان
  Widget _buildAddressRow(String currency) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(currency, style: TextStyle(fontSize: 18)),
              SizedBox(height: 5),
              Text(addresses[currency] ?? 'Not set', style: TextStyle(color: Colors.yellow)),
            ],
          ),
          CustomButton(
            text: 'Change',
            onPressed: () => _changeAddress(currency),
            width: 100,
          ),
        ],
      ),
    );
  }
}