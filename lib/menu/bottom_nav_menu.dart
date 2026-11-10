import 'package:flutter/material.dart';
import 'bottom_nav_style.dart';
import 'package:cerdas_ai/core/values/strings.dart';

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

/// CustomPainter untuk menggambar border atas bernuansa neon glowing gradien
/// dari Cyan (#38BDF8) ke Purple (#818CF8) dengan lekukan sudut halus sesuai Gambar 2
class _GlowingTopBorderPainter extends CustomPainter {
  final double radius;

  const _GlowingTopBorderPainter({this.radius = 24.0});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final path = Path();
    path.moveTo(0, radius);
    path.arcToPoint(
      Offset(radius, 0),
      radius: Radius.circular(radius),
      clockwise: true,
    );
    path.lineTo(size.width - radius, 0);
    path.arcToPoint(
      Offset(size.width, radius),
      radius: Radius.circular(radius),
      clockwise: true,
    );

    final rect = Rect.fromLTWH(0, 0, size.width, radius * 2);
    const gradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color(0xFF38BDF8), // Electric Cyan / Sky Blue di kiri
        Color(0xFF818CF8), // Violet / Indigo di kanan
      ],
    );

    // Pass 1: Efek pendaran glow di sekeliling border atas
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.8
      ..shader = gradient.createShader(rect)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.5);
    canvas.drawPath(path, glowPaint);

    // Pass 2: Garis border presisi dan tajam
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..shader = gradient.createShader(rect);
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _GlowingTopBorderPainter oldDelegate) =>
      oldDelegate.radius != radius;
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

  /// Membangun BottomNavigationBar dengan gaya modern, futuristik, dan profesional (Gambar 2)
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
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // 1. Neon Glowing Top Border (Gambar 2: Border gradien melengkung Cyan -> Purple)
            if (isDark)
              const Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _GlowingTopBorderPainter(radius: 24),
                  ),
                ),
              ),

            // 2. Efek Cahaya Ambient Icon Aktif & Indikator Neon Pill di Bagian Bawah (Gambar 2)
            if (isDark)
              Positioned.fill(
                child: IgnorePointer(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final itemWidth = constraints.maxWidth / menuItems.length;
                      final activeCenterX = (currentIndex + 0.5) * itemWidth;

                      return Stack(
                        children: [
                          // Radiant Halo Glow di Belakang Icon Aktif (Home/Dashboard dll)
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 280),
                            curve: Curves.easeOutCubic,
                            left: activeCenterX - 23,
                            top: 7,
                            width: 46,
                            height: 44,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    const Color(0xFF6366F1).withValues(alpha: 0.45),
                                    const Color(0xFF8B5CF6).withValues(alpha: 0.22),
                                    Colors.transparent,
                                  ],
                                  stops: const [0.0, 0.55, 1.0],
                                ),
                              ),
                            ),
                          ),

                          // Indikator Garis Kapsul Neon Gradien di Bawah Teks Label (Sesuai Gambar 2)
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 280),
                            curve: Curves.easeOutCubic,
                            left: activeCenterX - 22,
                            bottom: 5,
                            width: 44,
                            height: 3.5,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF8B5CF6), // Ungu/Violet di kiri
                                    Color(0xFF38BDF8), // Cyan/Biru terang di kanan
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.85),
                                    blurRadius: 8,
                                    spreadRadius: 0.5,
                                    offset: const Offset(0, 1),
                                  ),
                                  BoxShadow(
                                    color: const Color(0xFF38BDF8).withValues(alpha: 0.65),
                                    blurRadius: 6,
                                    spreadRadius: 0.5,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

            // 3. BottomNavigationBar Inti
            Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 6),
              child: BottomNavigationBar(
                currentIndex: currentIndex,
                onTap: onTap,
                backgroundColor: Colors.transparent,
                selectedItemColor: isDark ? Colors.white : Colors.black,
                unselectedItemColor: isDark ? const Color(0xFF94A3B8) : Colors.black87,
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
          ],
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
