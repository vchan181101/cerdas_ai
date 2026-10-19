import 'package:flutter/material.dart';

class BottomNavHelper {
  /// Index menu bottom navigation:
  /// 0: Dashboard/Beranda
  /// 1: Aktivitas
  /// 2: Notifikasi
  /// 3: Informasi/Global
  /// 4: Pengaturan

  /// Method untuk menavigasi halaman ber-index tanpa animasi transisi (setara overridePendingTransition(0, 0))
  static void navigateTo(BuildContext context, int targetIndex, int currentIndex) {
    if (targetIndex == currentIndex) return;

    String targetRoute;
    switch (targetIndex) {
      case 0:
        targetRoute = '/dashboard';
        break;
      case 1:
        targetRoute = '/activity';
        break;
      case 2:
        targetRoute = '/notification';
        break;
      case 3:
        targetRoute = '/informasi';
        break;
      case 4:
        targetRoute = '/setting';
        break;
      default:
        targetRoute = '/dashboard';
    }

    Navigator.pushReplacementNamed(
      context,
      targetRoute,
      result: PageRouteBuilder(
        pageBuilder: (context, anim1, anim2) => const SizedBox(),
        transitionDuration: Duration.zero, // Tanpa animasi transisi
      ),
    );
  }

  /// Reusable Widget BottomNavigationBar untuk dipakai di semua Screen
  static Widget buildBottomNavigationBar({
    required BuildContext context,
    required int currentIndex,
    required Function(int) onTap,
  }) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        if (index != currentIndex) {
          navigateTo(context, index, currentIndex);
        } else {
          onTap(index);
        }
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF6366F1),
      unselectedItemColor: const Color(0xFF94A3B8),
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assessment_outlined),
          activeIcon: Icon(Icons.assessment),
          label: 'Aktivitas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_outlined),
          activeIcon: Icon(Icons.notifications),
          label: 'Notifikasi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info_outline),
          activeIcon: Icon(Icons.info),
          label: 'Informasi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          activeIcon: Icon(Icons.settings),
          label: 'Pengaturan',
        ),
      ],
    );
  }
}