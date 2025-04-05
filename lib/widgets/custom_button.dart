import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final Color? color;

  CustomButton({
    required this.text,
    required this.onPressed,
    this.width = 150,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Color(0xFFF1B700), // اللون الأصفر مثل باينانس (يمكنك تغييره بما يناسبك)
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        minimumSize: Size(width, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(text, style: TextStyle(fontSize: 16)),
    );
  }
}
