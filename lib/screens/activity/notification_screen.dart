import 'package:flutter/material.dart';

import '../../adapters/notification_adapter.dart';
import '../../helpers/color/color_helper.dart';
import '../../menu/menu.dart';
import '../../models/notification_item.dart';
import '../../values/colors.dart';
import '../../values/strings.dart';
import '../../widgets/bottom_navigation_view_widget.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final int _currentBottomNavIndex = 3; // Index 3 untuk Notifikasi

  // List Data Notifikasi menggunakan model bersama
  final List<NotificationItem> _notificationList = [
    NotificationItem(
      id: "1",
      title: "Jawaban AI Siap",
      description: "Ringkasan Laporan_Keuangan_Q3.pdf telah berhasil dianalisis.",
      time: "10:30",
      type: "AI_SUCCESS",
      isRead: false,
    ),
    NotificationItem(
      id: "2",
      title: "Dokumen Berhasil Diproses",
      description: "Slide Presentasi_Proyek.pptx sudah selesai dipindai.",
      time: "08:15",
      type: "DOC_SUCCESS",
      isRead: false,
    ),
    NotificationItem(
      id: "3",
      title: "Update Fitur Baru",
      description: "Kini kamu bisa mengupload format Word (.doc/.docx) lebih lancar.",
      time: "Kemarin, 17:45",
      type: "UPDATE",
      isRead: false,
    ),
    NotificationItem(
      id: "4",
      title: "Penyimpanan Ditingkatkan",
      description: "Akses cepat analisis suara dan dokumen kini aktif 100%.",
      time: "20 Okt 2026",
      type: "UPDATE",
      isRead: true,
    ),
  ];

  // Aksi Tandai Semua Dibaca
  void _markAllAsRead() {
    setState(() {
      for (int i = 0; i < _notificationList.length; i++) {
        _notificationList[i] = _notificationList[i].copyWith(isRead: true);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Semua notifikasi telah ditandai dibaca')),
    );
  }

  // Dialog Fitur Update
  void _showUpdateFeatureDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: Text(
          '$message\n\nTerima kasih telah menggunakan Cerdas AI!',
          style: const TextStyle(fontSize: 14, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Tutup',
              style: TextStyle(
                color: AppColors.indigoPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Handle Klik Item Notifikasi via Adapter
  void _handleNotificationClick(NotificationItem item) {
    final index = _notificationList.indexWhere((element) => element.id == item.id);
    if (index != -1) {
      setState(() {
        _notificationList[index] = _notificationList[index].copyWith(isRead: true);
      });
    }

    if (item.type == 'UPDATE') {
      _showUpdateFeatureDialog(item.title, item.description);
    } else {
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScreenColorHelper.getBackgroundColor(context),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        AppStrings.titleNotifikasi,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: ScreenColorHelper.getHeadingText(context),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: _markAllAsRead,
                        borderRadius: BorderRadius.circular(4),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            AppStrings.actionTandaiDibaca,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: ScreenColorHelper.getPrimaryAction(context),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: _notificationList.isEmpty
                          ? Center(
                              child: Text(
                                'Belum ada notifikasi',
                                style: TextStyle(
                                  color: ScreenColorHelper.getBodyText(context),
                                  fontSize: 14,
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              child: NotificationAdapter(
                                notificationList: _notificationList,
                                onItemClick: _handleNotificationClick,
                              ),
                            ),
                    ),
                  ],
                ),
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
