import 'package:flutter/material.dart';

class TransactionTile extends StatelessWidget {
  final Map<String, dynamic> transaction;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final bool isAdmin;  // إضافة المعامل isAdmin

  TransactionTile({
    required this.transaction,
    this.onApprove,
    this.onReject,
    required this.isAdmin,  // إضافة المعامل isAdmin في البناء
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text('${transaction['type']} ${transaction['amount']} ${transaction['currency']}'),
        subtitle: Text('Address: ${transaction['address']}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isAdmin && onApprove != null)  // إذا كان المسؤول، يمكن تفعيل الأزرار
              IconButton(
                icon: Icon(Icons.check, color: Colors.green),
                onPressed: onApprove,
              ),
            if (isAdmin && onReject != null)   // إذا كان المسؤول، يمكن تفعيل الأزرار
              IconButton(
                icon: Icon(Icons.close, color: Colors.red),
                onPressed: onReject,
              ),
          ],
        ),
      ),
    );
  }
}
