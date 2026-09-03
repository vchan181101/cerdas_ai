import 'package:flutter/material.dart';
import '../../adapters/notification_adapter.dart';
import '../../helpers/helpers.dart';
import '../../models/notification_item.dart';
import '../../values/colors.dart';

class NotificationDemoScreen extends StatefulWidget {
  const NotificationDemoScreen({super.key});

  @override
  State<NotificationDemoScreen> createState() => _NotificationDemoScreenState();
}

class _NotificationDemoScreenState extends State<NotificationDemoScreen> {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'Pembaruan Fitur AI Berhasil',
      description: 'Model AI Cerdas versi terbaru sudah aktif dan siap digunakan.',
      time: '10 min lalu',
      type: 'UPDATE',
    ),
    NotificationItem(
      id: '2',
      title: 'Dokumen Selesai Diproses',
      description: 'Berkas Laporan_Keuangan_Q3.pdf berhasil diekstrak.',
      time: '1 jam lalu',
      type: 'DOC_SUCCESS',
    ),
    NotificationItem(
      id: '3',
      title: 'Kueri Teks AI Selesai',
      description: 'Jawaban atas pertanyaan Anda sudah dapat dilihat di Riwayat.',
      time: 'Kemarin',
      type: 'AI_SUCCESS',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScreenColorHelper.getBackgroundColor(context),
      appBar: AppBar(
        title: const Text('Notifikasi'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: NotificationAdapter(
          notificationList: _notifications,
          onItemClick: (item) {
            context.showSnackBar('Membuka notifikasi: ${item.title}');
          },
        ),
      ),
    );
  }
}
