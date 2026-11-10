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
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0F172A), // Modern Dark Light Slate Navy (AppDarkColors.bgLight)
                  Color(0xFF162038), // Soft Ambient Indigo-Navy
                  Color(0xFF1E2846), // Luminous Cosmic Highlight Glow
                  Color(0xFF11192E), // Rich Dark Light Navy
                ],
                stops: [0.0, 0.35, 0.7, 1.0],
              )
            : const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFFD4EDFD), // Soft Sky Blue (Kiri)
                  Color(0xFFE4F3FE), // Light Pastel Blue
                  Color(0xFFEFF5FE), // Pale Light Blue / White Tint (Tengah)
                  Color(0xFFFCF8FF), // Pale Lavender / White Tint
                  Color(0xFFF7EDFB), // Soft Lilac / Pink Pastel (Kanan)
                ],
                stops: [0.0, 0.25, 0.5, 0.75, 1.0],
              ),
      ),
      child: child,
    );
  }
}
