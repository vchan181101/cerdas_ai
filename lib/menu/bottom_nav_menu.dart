import 'package:flutter/material.dart';
import 'bottom_nav_style.dart';

/// Representation dari `<item>` pada res/menu/bottom_nav_menu.xml
class BottomNavItemModel {
  final int id;
  final String title;
  final IconData icon;
  final IconData activeIcon;
  final String routeName;

  const BottomNavItemModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.activeIcon,
    required this.routeName,
  });
}

class BottomNavMenu {
  // ID unik menu setara R.id.nav_* di Android
  static const int idDashboard = 0;
  static const int idActivity = 1;
  static const int idGlobal = 2;
  static const int idNotification = 3;
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
      id: idNotification,
      title: 'Notifikasi',
      icon: Icons.notifications_outlined,
      activeIcon: Icons.notifications,
      routeName: '/notifikasi',
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
  static List<BottomNavigationBarItem> getNavigationBarItems() {
    return menuItems.map((item) {
      return BottomNavigationBarItem(
        icon: Icon(item.icon),
        activeIcon: Icon(item.activeIcon),
        label: item.title,
      );
    }).toList();
  }

  /// Membangun BottomNavigationBar dengan gaya modern dan keren
  static Widget buildBottomNavigationBar({
    required BuildContext context,
    required int currentIndex,
    required ValueChanged<int> onTap,
  }) {
    return Container(
      decoration: BottomNavStyle.containerDecoration,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          backgroundColor: BottomNavStyle.backgroundColor,
          selectedItemColor: BottomNavStyle.activeColor,
          unselectedItemColor: BottomNavStyle.inactiveColor,
          selectedLabelStyle: BottomNavStyle.activeLabelStyle,
          unselectedLabelStyle: BottomNavStyle.inactiveLabelStyle,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: getNavigationBarItems(),
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
