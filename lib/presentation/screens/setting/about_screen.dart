import 'package:flutter/material.dart';
import 'package:cerdas_ai/core/helpers/color/screen_color_helper.dart';
import 'package:cerdas_ai/core/values/strings.dart';
import 'package:cerdas_ai/presentation/widgets/widgets.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headingColor = isDark ? Colors.white : Colors.black;

    return BackgroundWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Tombol Kembali di Kiri & Judul "Tentang Aplikasi" di Posisi Tengah (Sesuai Gambar 4)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: SizedBox(
                  height: 40,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : Colors.black.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 18,
                              color: headingColor,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          AppStrings.titleTentang,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: headingColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Scrollable Content Informasi Aplikasi
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),

                      // Logo App Lingkaran Sesuai Gambar 1
                      const CerdasAiLogoBadge(size: 130),

                      const SizedBox(height: 20),

                      // App Name Full (Gradient Text di Tema Gelap)
                      ShaderMask(
                        shaderCallback: (bounds) {
                          if (!isDark) {
                            return const LinearGradient(
                              colors: [Color(0xFF2563EB), Color(0xFF2563EB)],
                            ).createShader(bounds);
                          }
                          return const LinearGradient(
                            colors: [
                              Color(0xFF38BDF8),
                              Color(0xFFA78BFA),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ).createShader(bounds);
                        },
                        child: Text(
                          AppStrings.appNameFull,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Deskripsi Aplikasi
                      Text(
                        AppStrings.appDescription,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? const Color(0xFF94A3B8) : ScreenColorHelper.getBodyText(context),
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Metadata Card 1: Versi Aplikasi
                      _buildInfoCard(
                        context: context,
                        icon: Icons.memory_rounded,
                        label: AppStrings.appVersionLabel,
                        value: AppStrings.appVersion,
                        valueColor: isDark ? const Color(0xFF94A3B8) : Colors.black54,
                        isDark: isDark,
                      ),

                      const SizedBox(height: 12),

                      // Metadata Card 2: Pengembang / Developer
                      _buildInfoCard(
                        context: context,
                        icon: Icons.people_alt_outlined,
                        label: AppStrings.developerLabel,
                        value: AppStrings.developerName,
                        valueColor: isDark ? const Color(0xFF94A3B8) : Colors.black54,
                        isDark: isDark,
                      ),

                      const SizedBox(height: 12),

                      // Metadata Card 3: Kontak Kami
                      _buildInfoCard(
                        context: context,
                        icon: Icons.mail_outline_rounded,
                        label: AppStrings.contactUs,
                        value: AppStrings.contactEmail,
                        valueColor: const Color(0xFF38BDF8),
                        isDark: isDark,
                      ),

                      const SizedBox(height: 48),

                      // Copyright Footer
                      Text(
                        '© 2026 AICERDAS All Rights Reserved',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? const Color(0xFF64748B) : Colors.black45,
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget Card Informasi
  Widget _buildInfoCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required Color valueColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : Colors.black.withValues(alpha: 0.08),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isDark ? const Color(0xFF94A3B8) : Colors.black54,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
