import 'package:flutter/material.dart';
import '../values/styles.dart';

class CircularImageView extends StatelessWidget {
  final String imagePath;
  final double size;
  final Color borderColor;
  final double borderWidth;
  final IconData placeholderIcon;

  const CircularImageView({
    super.key,
    required this.imagePath,
    this.size = 88.0,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0.0,
    this.placeholderIcon = Icons.person,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: AppStyles.circularProfileDecoration(
        borderColor: borderColor,
        borderWidth: borderWidth,
      ),
      child: ClipOval(
        child: Image.asset(
          imagePath,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey.shade200,
              child: Icon(
                placeholderIcon,
                size: size * 0.5,
                color: Colors.grey.shade500,
              ),
            );
          },
        ),
      ),
    );
  }
}