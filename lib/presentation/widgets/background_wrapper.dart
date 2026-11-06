import 'package:flutter/material.dart';

class BackgroundWrapper extends StatelessWidget {
  final Widget child;

  const BackgroundWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0F172A),
                  Color(0xFF1E293B),
                ],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFD1ECFD), // Soft Sky Blue (Top-Left)
                  Color(0xFFEBF6FE), // Light Pastel Blue
                  Color(0xFFFCF8FF), // Pale Lavender / White Tint
                  Color(0xFFF5E8FA), // Soft Lilac / Purple Pastel (Bottom-Right)
                ],
                stops: [0.0, 0.35, 0.7, 1.0],
              ),
      ),
      child: child,
    );
  }
}
