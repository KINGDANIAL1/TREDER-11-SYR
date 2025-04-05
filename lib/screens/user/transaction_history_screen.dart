import 'package:flutter/material.dart';
import '../../services/wallet_service.dart';
import '../../widgets/transaction_tile.dart';
import '../../models/transaction_model.dart';

class TransactionHistoryScreen extends StatefulWidget {
  final bool isAdmin;

  // تعريف المتغير isAdmin في الـ constructor
  TransactionHistoryScreen({this.isAdmin = false});

  @override
  _TransactionHistoryScreenState createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final WalletService _walletService = WalletService();
  List<TransactionModel> transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    try {
      String userId = "user123"; // يجب جلبه من حالة التطبيق
      final response = await _walletService.getTransactionHistory(userId);
      setState(() {
        transactions = (response as List)
            .map((tx) => TransactionModel.fromJson(tx))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to load transactions')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
        backgroundColor: Colors.yellow,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _loadTransactions,
        child: transactions.isEmpty
            ? Center(child: Text('No transactions yet'))
            : ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final tx = transactions[index];
            return TransactionTile(
              transaction: {
                '_id': tx.id,
                'type': tx.type,
                'amount': tx.amount,
                'currency': tx.currency,
                'address': tx.address ?? 'N/A',
                'status': tx.status,
              },
              onApprove: widget.isAdmin ? () {} : null,
              onReject: widget.isAdmin ? () {} : null,
              isAdmin: widget.isAdmin, // تأكد من تمرير isAdmin بشكل صحيح
            );
          },
        ),
      ),
    );
  }
}
