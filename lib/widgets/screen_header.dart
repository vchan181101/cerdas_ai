import 'package:flutter/material.dart';
import '../helpers/color/color_helper.dart';

class ScreenHeader extends StatelessWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackTap;
  final List<Widget>? actions;
  final bool centerTitle;

  const ScreenHeader({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.onBackTap,
    this.actions,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color iconColor = isDark ? Colors.white : Colors.black;
    final TextStyle titleStyle = ScreenStyleHelper.getScreenTitleStyle(context).copyWith(
      color: isDark ? Colors.white : Colors.black,
    );

    if (centerTitle) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (showBackButton)
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new, size: 20, color: iconColor),
                  onPressed: onBackTap ?? () => Navigator.pop(context),
                ),
              ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: titleStyle,
            ),
            if (actions != null)
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: actions!,
                ),
              ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      child: Row(
        children: [
          if (showBackButton)
            IconButton(
              icon: Icon(Icons.arrow_back_ios_new, size: 20, color: iconColor),
              onPressed: onBackTap ?? () => Navigator.pop(context),
            ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: titleStyle,
            ),
          ),
          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}
