import 'package:flutter/material.dart';

class ClaireTheme {
  static const gradientTop = Color(0xFFFFA06E);
  static const gradientBottom = Color(0xFFFFE7D7);
  static const navy = Color(0xFF0A2540);
}

class ClairePrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ClairePrimaryButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: ClaireTheme.navy,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
    );
  }
}
