
import 'package:flutter/material.dart';

class TradingChart extends StatelessWidget {
  final String pair;

  TradingChart({required this.pair});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          'Trading Chart for $pair\n(Placeholder - Integrate real chart library)',
          style: TextStyle(fontSize: 16, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}