
import 'package:flutter/material.dart';

class WalletCard extends StatelessWidget {
  final String currency;
  final String balance;

  WalletCard({required this.currency, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(currency, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('$balance', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}