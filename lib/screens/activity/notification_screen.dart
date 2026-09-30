import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../../models/notification_item.dart';
import '../../values/colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Daftar notifikasi aplikasi Cerdas AI
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: 'notif_1',
      title: 'Prediksi Ujian UTS Matematika Siap Dikerjakan',
      description:
          'Dokumen prediksi soal Matematika SMA/SMK telah disusun oleh Cerdas AI Engine. Uji pemahamanmu sekarang!',
      time: '10 menit lalu',
      type: 'QUIZ',
      isRead: false,
    ),
    NotificationItem(
      id: 'notif_2',
      title: 'Analisis Dokumen PDF Selesai',
      description:
          'Berkas materi pembelajaran berhasil diekstrak dan siap dianalisis bersama asisten AI Cerdas.',
      time: '45 menit lalu',
      type: 'DOC',
      isRead: false,
    ),
    NotificationItem(
      id: 'notif_3',
      title: 'Materi Baru Tersedia di Modul Belajar',
      description:
          '15 materi dan ilustrasi visual baru telah ditambahkan ke ruang belajar favorit Anda.',
      time: '2 jam lalu',
      type: 'LEARN',
      isRead: false,
    ),
    NotificationItem(
      id: 'notif_4',
      title: 'Respon AI Cerdas Disimpan ke Riwayat',
      description:
          'Hasil tanya jawab dan solusi soal Anda telah otomatis tersimpan di riwayat Aktivitas.',
      time: '5 jam lalu',
      type: 'AI',
      isRead: true,
    ),
    NotificationItem(
      id: 'notif_5',
      title: 'Status Akun: Cerdas AI Pro Aktif',
      description:
          'Fitur "Berpikir Lebih Keras" dan kuota token tanpa batas kini aktif di akun Anda.',
      time: 'Kemarin, 14:20',
      type: 'ACCOUNT',
      isRead: true,
    ),
    NotificationItem(
      id: 'notif_6',
      title: 'Pembaruan Sistem Cerdas AI v1.0.1',
      description:
          'Peningkatan kecepatan respons Gemini AI dan optimasi memori cache telah berhasil diperbarui.',
      time: '2 hari lalu',
      type: 'SYSTEM',
      isRead: true,
    ),
    NotificationItem(
      id: 'notif_7',
      title: 'Cadangan Dokumen Tersimpan Aman',
      description:
          'Seluruh berkas catatan dan resume belajar Anda telah tersinkronisasi dengan aman di penyimpanan lokal.',
      time: '3 hari lalu',
      type: 'BACKUP',
      isRead: true,
    ),
  ];

  // Aksi: Tandai semua notifikasi sudah dibaca
  void _markAllAsRead() {
    final bool anyUnread = _notifications.any((item) => !item.isRead);
    setState(() {
      for (final item in _notifications) {
        item.isRead = true;
      }
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          anyUnread
              ? 'Semua notifikasi telah ditandai sudah dibaca'
              : 'Semua notifikasi sudah dibaca',
        ),
        backgroundColor: ScreenColorHelper.getPrimaryAction(context),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Helper style icon & warna berdasarkan tipe notifikasi Cerdas AI
  Map<String, dynamic> _getTypeStyle(String type) {
    switch (type.toUpperCase()) {
      case 'QUIZ':
        return {
          'icon': Icons.quiz_outlined,
          'color': const Color(0xFF8B5CF6), // Purple
          'label': 'KUIS',
        };
      case 'DOC':
      case 'DOC_SUCCESS':
        return {
          'icon': Icons.picture_as_pdf_outlined,
          'color': const Color(0xFF2563EB), // Blue
          'label': 'DOKUMEN',
        };
      case 'LEARN':
        return {
          'icon': Icons.school_outlined,
          'color': const Color(0xFFF59E0B), // Amber / Gold
          'label': 'BELAJAR',
        };
      case 'AI':
      case 'AI_SUCCESS':
        return {
          'icon': Icons.auto_awesome_rounded,
          'color': const Color(0xFF10B981), // Emerald Green
          'label': 'CERDAS AI',
        };
      case 'ACCOUNT':
        return {
          'icon': Icons.workspace_premium_rounded,
          'color': const Color(0xFFEC4899), // Pink
          'label': 'AKUN PRO',
        };
      case 'SYSTEM':
      case 'UPDATE':
        return {
          'icon': Icons.system_update_rounded,
          'color': const Color(0xFF6366F1), // Indigo
          'label': 'SISTEM',
        };
      case 'BACKUP':
        return {
          'icon': Icons.cloud_done_rounded,
          'color': const Color(0xFF14B8A6), // Teal
          'label': 'CADANGAN',
        };
      default:
        return {
          'icon': Icons.notifications_rounded,
          'color': const Color(0xFF3B82F6),
          'label': 'INFO',
        };
    }
  }

  // Tampilkan dialog/bottom sheet detail notifikasi saat diklik
  void _openNotificationDetail(NotificationItem item) {
    if (!item.isRead) {
      setState(() {
        item.isRead = true;
      });
    }

    final style = _getTypeStyle(item.type);
    final Color itemColor = style['color'];
    final IconData itemIcon = style['icon'];
    final String itemLabel = style['label'];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        final cardColor = ScreenColorHelper.getSurfaceColor(bottomSheetContext);
        final headingColor = ScreenColorHelper.getHeadingText(bottomSheetContext);
        final bodyColor = ScreenColorHelper.getBodyText(bottomSheetContext);

        return Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header Bar Notifikasi Detail
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: itemColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(itemIcon, color: itemColor, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: itemColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            itemLabel,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: itemColor,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.time,
                          style: TextStyle(
                            fontSize: 12,
                            color: bodyColor.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: headingColor),
                    onPressed: () => Navigator.pop(bottomSheetContext),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Judul Notifikasi
              Text(
                item.title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: headingColor,
                ),
              ),

              const SizedBox(height: 10),

              // Isi Deskripsi
              Text(
                item.description,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: bodyColor.withValues(alpha: 0.85),
                ),
              ),

              const SizedBox(height: 24),

              // Tombol Aksi Menuju Fitur Terkait
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(bottomSheetContext);
                    _navigateForType(item.type);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ScreenColorHelper.getPrimaryAction(context),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _getActionTitleForType(item.type),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getActionTitleForType(String type) {
    switch (type.toUpperCase()) {
      case 'QUIZ':
        return 'Buka Menu Kuis';
      case 'DOC':
      case 'DOC_SUCCESS':
      case 'BACKUP':
        return 'Lihat Dokumen Tersimpan';
      case 'LEARN':
        return 'Buka Ruang Belajar';
      case 'AI':
      case 'AI_SUCCESS':
        return 'Buka Riwayat Aktivitas';
      case 'ACCOUNT':
        return 'Lihat Status Langganan';
      default:
        return 'Tutup Notifikasi';
    }
  }

  void _navigateForType(String type) {
    switch (type.toUpperCase()) {
      case 'QUIZ':
        Navigator.pushNamed(context, '/quizz');
        break;
      case 'DOC':
      case 'DOC_SUCCESS':
      case 'BACKUP':
        Navigator.pushNamed(context, '/dokumen-tersimpan');
        break;
      case 'LEARN':
        Navigator.pushNamed(context, '/belajar');
        break;
      case 'AI':
      case 'AI_SUCCESS':
        Navigator.pushNamed(context, '/aktivitas');
        break;
      case 'ACCOUNT':
        Navigator.pushNamed(context, '/upgrade-plus');
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = ScreenColorHelper.getBackgroundColor(context);
    final cardColor = ScreenColorHelper.getSurfaceColor(context);
    final headingColor = ScreenColorHelper.getHeadingText(context);
    final bodyColor = ScreenColorHelper.getBodyText(context);
    final primaryColor = ScreenColorHelper.getPrimaryAction(context);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        // 1. Icon Back di posisi kiri-atas
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: headingColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        // 2. Kalimat Notifikasi di posisi tengah-atas
        title: Text(
          'Notifikasi',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: headingColor,
          ),
        ),
        // 3. Kalimat "Tandai sudah dibaca" di posisi kanan-atas
        actions: [
          TextButton(
            onPressed: _markAllAsRead,
            child: Text(
              'Tandai sudah dibaca',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      // Di bawah kolom header notifikasi, beberapa kolom notifikasi dan bisa scroll up-down
      body: SafeArea(
        child: _notifications.isEmpty
            ? _buildEmptyState(headingColor, bodyColor)
            : RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(const Duration(milliseconds: 500));
                  setState(() {});
                },
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  itemCount: _notifications.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = _notifications[index];
                    return _buildNotificationCard(
                      item: item,
                      cardColor: cardColor,
                      headingColor: headingColor,
                      bodyColor: bodyColor,
                      primaryColor: primaryColor,
                      onTap: () => _openNotificationDetail(item),
                    );
                  },
                ),
              ),
      ),
    );
  }

  // Widget Kartu Kolom Notifikasi
  Widget _buildNotificationCard({
    required NotificationItem item,
    required Color cardColor,
    required Color headingColor,
    required Color bodyColor,
    required Color primaryColor,
    required VoidCallback onTap,
  }) {
    final style = _getTypeStyle(item.type);
    final Color itemColor = style['color'];
    final IconData itemIcon = style['icon'];
    final String itemLabel = style['label'];

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: !item.isRead
                ? primaryColor.withValues(alpha: 0.35)
                : AppColors.inputBorder.withValues(alpha: 0.25),
            width: !item.isRead ? 1.4 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: !item.isRead ? 0.04 : 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Kiri Kolom Notifikasi
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: itemColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                itemIcon,
                color: itemColor,
                size: 22,
              ),
            ),

            const SizedBox(width: 14),

            // Tengah: Konten Notifikasi
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row Label Kategori & Waktu
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: itemColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          itemLabel,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: itemColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item.time,
                        style: TextStyle(
                          fontSize: 11,
                          color: bodyColor.withValues(alpha: 0.55),
                        ),
                      ),
                      const Spacer(),
                      // Indikator Belum Dibaca (Lingkaran Titik Biru)
                      if (!item.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryColor,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Judul Notifikasi
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: !item.isRead ? FontWeight.bold : FontWeight.w600,
                      color: headingColor,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Deskripsi Notifikasi
                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.35,
                      color: bodyColor.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tampilan Kosong jika tidak ada notifikasi
  Widget _buildEmptyState(Color headingColor, Color bodyColor) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: ScreenColorHelper.getPrimaryAction(context).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_off_outlined,
                size: 40,
                color: ScreenColorHelper.getPrimaryAction(context),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Belum Ada Notifikasi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: headingColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Semua pesan, aktivitas, dan pemberitahuan penting dari Cerdas AI akan muncul di sini.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: bodyColor.withValues(alpha: 0.6),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
