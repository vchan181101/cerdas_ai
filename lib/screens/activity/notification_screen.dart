import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../../menu/menu.dart';
import '../../values/values.dart';
import '../../widgets/widgets.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final int _currentBottomNavIndex = 3; // Index 3 untuk Notifikasi

  final List<Map<String, String>> _notificationList = [
    {
      'title': 'Pembaruan Sistem',
      'desc': 'Cerdas AI kini lebih cepat dengan model Flash terbaru.',
      'time': '2 jam yang lalu',
    },
    {
      'title': 'Upgrade Berhasil',
      'desc': 'Selamat! Akun Anda kini sudah menjadi Cerdas AI Plus.',
      'time': '1 hari yang lalu',
    },
    {
      'title': 'Tips Keamanan',
      'desc': 'Jangan lupa untuk memperbarui kata sandi Anda secara berkala.',
      'time': '3 hari yang lalu',
    },
    {
      'title': 'Fitur Baru: Analisis Suara',
      'desc': 'Sekarang Anda bisa bertanya menggunakan mikrofon di Dashboard.',
      'time': '4 hari yang lalu',
    },
    {
      'title': 'Promo Cerdas AI Pro',
      'desc': 'Dapatkan diskon 50% untuk langganan tahunan pertama Anda.',
      'time': '5 hari yang lalu',
    },
    {
      'title': 'Pesan dari Tim Support',
      'desc': 'Kami telah memverifikasi identitas Anda. Terima kasih.',
      'time': '1 minggu yang lalu',
    },
    {
      'title': 'Laporan Mingguan',
      'desc': 'Anda telah menghemat 10 jam kerja minggu ini dengan Cerdas AI.',
      'time': '1 minggu yang lalu',
    },
    {
      'title': 'Maintenance Selesai',
      'desc': 'Server telah diperbarui untuk performa maksimal.',
      'time': '2 minggu yang lalu',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final headingColor = ScreenColorHelper.getHeadingText(context);
    final bodyColor = ScreenColorHelper.getBodyText(context);
    final primaryColor = ScreenColorHelper.getPrimaryAction(context);

    return Scaffold(
      backgroundColor: ScreenColorHelper.getBackgroundColor(context),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  AppStrings.titleNotifikasi,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: headingColor,
                  ),
                ),
              ),
            ),

            // Daftar Notifikasi
            Expanded(
              child: _notificationList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications_off_outlined, size: 64, color: bodyColor.withValues(alpha: 0.2)),
                          const SizedBox(height: 16),
                          Text('Belum ada notifikasi baru', style: TextStyle(color: bodyColor)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      itemCount: _notificationList.length,
                      itemBuilder: (context, index) {
                        final item = _notificationList[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 1,
                          color: ScreenColorHelper.getSurfaceColor(context),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: primaryColor.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.notifications_active_rounded, color: primaryColor, size: 20),
                            ),
                            title: Text(
                              item['title']!,
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: headingColor),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(item['desc']!, style: TextStyle(fontSize: 13, color: bodyColor)),
                                const SizedBox(height: 4),
                                Text(item['time']!, style: TextStyle(fontSize: 11, color: bodyColor.withValues(alpha: 0.5))),
                              ],
                            ),
                            isThreeLine: true,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationViewWidget(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          BottomNavMenu.handleNavigation(context, _currentBottomNavIndex, index);
        },
      ),
    );
  }
}
