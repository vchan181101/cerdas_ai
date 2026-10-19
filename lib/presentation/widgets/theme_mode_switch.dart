import 'package:flutter/material.dart';

class ThemeModeSwitch extends StatelessWidget {
  final ThemeMode currentMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  const ThemeModeSwitch({
    super.key,
    required this.currentMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = currentMode == ThemeMode.dark;

    return IconButton(
      icon: Icon(
        isDark ? Icons.wb_sunny : Icons.nightlight_round,
        color: Theme.of(context).colorScheme.primary,
      ),
      tooltip: isDark ? 'Beralih ke Light Mode' : 'Beralih ke Dark Mode',
      onPressed: () {
        onThemeChanged(isDark ? ThemeMode.light : ThemeMode.dark);
      },
    );
  }
}