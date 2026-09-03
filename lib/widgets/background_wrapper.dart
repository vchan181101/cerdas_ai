import 'package:flutter/material.dart';
import '../values/colors.dart';

class BackgroundWrapper extends StatelessWidget {
  final Widget child;

  const BackgroundWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        // Linear Gradient visual untuk menggantikan bg_professional_main.xml
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.bgLight,
            Color(0xFFEFF6FF), // Soft Blue Accent Blend
          ],
        ),
      ),
      child: child,
    );
  }
}