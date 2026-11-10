import 'package:flutter/material.dart';
import 'package:cerdas_ai/core/values/colors.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color backgroundColor;
  final Color foregroundColor;
  final double height;
  final double borderRadius;
  final IconData? icon;
  final Gradient? gradient;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor = AppColors.indigoPrimary,
    this.foregroundColor = Colors.white,
    this.height = 52.0,
    this.borderRadius = 12.0,
    this.icon,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    );

    final content = isLoading
        ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Colors.white,
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );

    if (gradient != null) {
      return Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6D28D9).withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: foregroundColor,
            disabledBackgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: shape,
            elevation: 0,
          ),
          child: content,
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          disabledBackgroundColor: backgroundColor.withValues(alpha: 0.6),
          shape: shape,
          elevation: 2,
        ),
        child: content,
      ),
    );
  }
}
