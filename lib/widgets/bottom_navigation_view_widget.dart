import 'package:flutter/material.dart';
import '../menu/bottom_nav_menu.dart';

/// Reusable Widget yang membungkus BottomNavMenu dengan gaya modern Cerdas AI.
/// Memberikan cara pemanggilan yang lebih deklaratif di dalam Scaffold.
class BottomNavigationViewWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavigationViewWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavMenu.buildBottomNavigationBar(
      context: context,
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }
}
