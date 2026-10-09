import 'package:flutter/material.dart';
import 'bottom_nav_style.dart';
import '../values/strings.dart';

/// Representation dari `<item>` pada res/menu/bottom_nav_menu.xml
class BottomNavItemModel {
  final int id;
  final String title;
  final IconData? icon;
  final IconData? activeIcon;
  final String? assetIcon;
  final String routeName;

  const BottomNavItemModel({
    required this.id,
    required this.title,
    this.icon,
    this.activeIcon,
    this.assetIcon,
    required this.routeName,
  });
}

class BottomNavMenu {
  // ID unik menu setara R.id.nav_* di Android
  static const int idDashboard = 0;
  static const int idActivity = 1;
  static const int idGlobal = 2;
  static const int idQuizz = 3;
  static const int idNotification = 3; // Alias untuk backwards compatibility
  static const int idSetting = 4;

  /// Daftar item menu konversi dari res/menu/bottom_nav_menu.xml
  static const List<BottomNavItemModel> menuItems = [
    BottomNavItemModel(
      id: idDashboard,
      title: 'Dashboard',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      routeName: '/dashboard',
    ),
    BottomNavItemModel(
      id: idActivity,
      title: 'Aktivitas',
      icon: Icons.history_outlined,
      activeIcon: Icons.history,
      routeName: '/aktivitas',
    ),
    BottomNavItemModel(
      id: idGlobal,
      title: 'Belajar',
      icon: Icons.school_outlined,
      activeIcon: Icons.school,
      routeName: '/belajar',
    ),
    BottomNavItemModel(
      id: idQuizz,
      title: 'Quizz',
      assetIcon: 'asset/ic_quizz.png',
      icon: Icons.quiz_outlined,
      activeIcon: Icons.quiz,
      routeName: '/quizz',
    ),
    BottomNavItemModel(
      id: idSetting,
      title: 'Pengaturan',
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      routeName: '/setting', // Disesuaikan dengan route di main.dart
    ),
  ];

  /// Menghasilkan list BottomNavigationBarItem untuk BottomNavigationBar Widget
  static List<BottomNavigationBarItem> getNavigationBarItems({BuildContext? context}) {
    final bool isDark = context != null && Theme.of(context).brightness == Brightness.dark;
    final Color inactiveColor = isDark ? const Color(0xFF94A3B8) : BottomNavStyle.inactiveColor;
    final Color activeColor = BottomNavStyle.activeColor;

    return menuItems.map((item) {
      String itemLabel = item.title;
      if (item.id == idActivity) {
        itemLabel = AppStrings.titleAktivitas;
      } else if (item.id == idGlobal) {
        itemLabel = AppStrings.menuBelajar;
      } else if (item.id == idSetting) {
        itemLabel = AppStrings.titlePengaturan;
      }

      if (item.assetIcon != null) {
        return BottomNavigationBarItem(
          icon: Image.asset(
            item.assetIcon!,
            width: 24,
            height: 24,
            color: inactiveColor,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Icon(
              item.icon ?? Icons.quiz_outlined,
              color: inactiveColor,
            ),
          ),
          activeIcon: Image.asset(
            item.assetIcon!,
            width: 24,
            height: 24,
            color: activeColor,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Icon(
              item.activeIcon ?? Icons.quiz,
              color: activeColor,
            ),
          ),
          label: itemLabel,
        );
      }
      return BottomNavigationBarItem(
        icon: Icon(
          item.icon!,
          color: inactiveColor,
        ),
        activeIcon: Icon(
          item.activeIcon!,
          color: activeColor,
        ),
        label: itemLabel,
      );
    }).toList();
  }

  /// Membangun BottomNavigationBar dengan gaya modern dan keren
  static Widget buildBottomNavigationBar({
    required BuildContext context,
    required int currentIndex,
    required ValueChanged<int> onTap,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BottomNavStyle.getContainerDecoration(context),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          backgroundColor: Colors.transparent,
          selectedItemColor: isDark ? Colors.white : Colors.black,
          unselectedItemColor: isDark ? Colors.white70 : Colors.black87,
          selectedIconTheme: const IconThemeData(
            color: BottomNavStyle.activeColor,
            size: 24,
          ),
          unselectedIconTheme: IconThemeData(
            color: isDark ? const Color(0xFF94A3B8) : BottomNavStyle.inactiveColor,
            size: 24,
          ),
          selectedLabelStyle: BottomNavStyle.getSelectedLabelStyle(context),
          unselectedLabelStyle: BottomNavStyle.getUnselectedLabelStyle(context),
          type: BottomNavigationBarType.fixed,
          useLegacyColorScheme: false,
          elevation: 0,
          items: getNavigationBarItems(context: context),
        ),
      ),
    );
  }

  /// Konversi logika setupBottomNavigation dari bottom_nav_menu.java
  static void handleNavigation(
      BuildContext context,
      int activeItemId,
      int selectedItemId,
      ) {
    if (activeItemId == selectedItemId) return;

    final targetItem = menuItems.firstWhere(
          (item) => item.id == selectedItemId,
      orElse: () => menuItems[0],
    );

    Navigator.pushReplacementNamed(
      context,
      targetItem.routeName,
    );
  }
}
