import 'package:flutter/material.dart';
import '../../services/admin_service.dart';
import '../../widgets/transaction_tile.dart';

class AdminPanelScreen extends StatefulWidget {
  @override
  _AdminPanelScreenState createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final AdminService _adminService = AdminService();
  List<Map<String, dynamic>> pendingTransactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPendingTransactions();
  }

  // جلب المعاملات المعلقة
  Future<void> _loadPendingTransactions() async {
    try {
      var transactions = await _adminService.getPendingTransactions();
      setState(() {
        pendingTransactions = transactions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to load transactions')));
    }
  }

  // معالجة المعاملة
  void _handleTransaction(String transactionId, String action) async {
    try {
      var response = await _adminService.handleTransaction(transactionId, action);
      if (response['success']) {
        _loadPendingTransactions();
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Action failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Panel')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _loadPendingTransactions,
        child: pendingTransactions.isEmpty
            ? Center(child: Text('No pending transactions'))
            : ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: pendingTransactions.length,
          itemBuilder: (context, index) {
            var tx = pendingTransactions[index];
            return TransactionTile(
              transaction: tx,
              onApprove: () => _handleTransaction(tx['_id'], 'approve'),
              onReject: () => _handleTransaction(tx['_id'], 'reject'),
              isAdmin: true, // تعيين isAdmin على true لأنه المسؤول
            );
          },
        ),
      ),
    );
  }
}
