import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../../helpers/helpers.dart';
import '../../values/values.dart';
import '../../widgets/widgets.dart';

class DarkModeDemoScreen extends StatelessWidget {
  final ThemeMode currentThemeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  const DarkModeDemoScreen({
    super.key,
    required this.currentThemeMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: ScreenColorHelper.getBackgroundColor(context),
      appBar: AppBar(
        title: const Text('Cyber Dark Mode Hub'),
        backgroundColor: AppColors.indigoPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          ThemeModeSwitch(
            currentMode: currentThemeMode,
            onThemeChanged: onThemeChanged,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Theme Status Section
            _buildThemeStatusCard(isDark),
            
            const SizedBox(height: 32),

            // 2. Semantic Palette Section
            Text(
              'Semantic Palette',
              style: ScreenStyleHelper.getLabelStyle(context),
            ).paddingOnly(bottom: 16),

            _buildColorCard(
              context: context,
              title: 'Primary Background',
              color: ScreenColorHelper.getBackgroundColor(context),
              description: 'Latar belakang utama aplikasi yang responsif terhadap tema.',
            ),
            _buildColorCard(
              context: context,
              title: 'Surface Container',
              color: ScreenColorHelper.getSurfaceColor(context),
              description: 'Warna kartu dan komponen surface untuk konten utama.',
            ),
            _buildColorCard(
              context: context,
              title: 'Heading Text',
              color: ScreenColorHelper.getHeadingText(context),
              description: 'Teks kontras tinggi untuk judul dan informasi penting.',
            ),
            _buildColorCard(
              context: context,
              title: 'Body Description',
              color: ScreenColorHelper.getBodyText(context),
              description: 'Teks kontras sedang untuk keterbacaan artikel yang nyaman.',
            ),
            
            const SizedBox(height: 32),
            
            // 3. Status Feedback Section
            Text(
              'Status Feedback',
              style: ScreenStyleHelper.getLabelStyle(context),
            ).paddingOnly(bottom: 16),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: ScreenStyleHelper.getModernCardDecoration(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatusCircle('Success', ScreenColorHelper.getStatusColor('success')),
                  _buildStatusCircle('Warning', ScreenColorHelper.getStatusColor('warning')),
                  _buildStatusCircle('Error', ScreenColorHelper.getStatusColor('error')),
                  _buildStatusCircle('Info', ScreenColorHelper.getStatusColor('info')),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 4. Component Preview Section
            Text(
              'Component Preview',
              style: ScreenStyleHelper.getLabelStyle(context),
            ).paddingOnly(bottom: 16),

            const AiResponseCard(
              response: 'Dalam mode gelap, kartu respons ini menggunakan Surface Color yang disesuaikan agar teks tetap mudah dibaca tanpa menyilaukan mata.',
            ),
            
            const SizedBox(height: 24),
            
            AppButton(
              text: 'KEMBALI KE BERANDA',
              backgroundColor: AppColors.indigoPrimary,
              onPressed: () => Navigator.pop(context),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeStatusCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: isDark 
          ? const LinearGradient(colors: [Color(0xFF1E293B), Color(0xFF0F172A)])
          : const LinearGradient(colors: [AppColors.indigoPrimary, Color(0xFF818CF8)]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : AppColors.indigoPrimary).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
            color: Colors.white,
            size: 40,
          ),
          const SizedBox(height: 16),
          Text(
            isDark ? 'Cyber Night Active' : 'Pristine Day Active',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isDark 
              ? 'Antarmuka telah dioptimalkan untuk kondisi minim cahaya.' 
              : 'Warna cerah dan bersih untuk visibilitas maksimal di siang hari.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorCard({
    required BuildContext context,
    required String title,
    required Color color,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: ScreenStyleHelper.getModernCardDecoration(context),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.inputBorder, width: 1),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCircle(String label, Color color) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 1.5),
          ),
          child: Icon(Icons.palette_outlined, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          label, 
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)
        ),
      ],
    );
  }
}
