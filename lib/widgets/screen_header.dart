import 'package:flutter/material.dart';
import '../helpers/color/color_helper.dart';

class ScreenHeader extends StatelessWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackTap;
  final List<Widget>? actions;

  const ScreenHeader({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.onBackTap,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      child: Row(
        children: [
          if (showBackButton)
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              onPressed: onBackTap ?? () => Navigator.pop(context),
            ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: ScreenStyleHelper.getScreenTitleStyle(context),
            ),
          ),
          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}
