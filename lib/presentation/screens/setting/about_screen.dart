import 'package:flutter/material.dart';
import '../../core/app_constants.dart';
import '../../helpers/color/screen_color_helper.dart';
import '../../values/colors.dart';
import '../../values/strings.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScreenColorHelper.getBackgroundColor(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header / Tombol Kembali
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 24),
                    color: ScreenColorHelper.getHeadingText(context),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppStrings.titleTentang,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ScreenColorHelper.getHeadingText(context),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Scrollable Content Informasi Aplikasi
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 8),

                      // Logo App
                      Image.asset(
                        AppConstants.logoPath,
                        width: 120,
                        height: 120,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.psychology_rounded,
                            size: 100,
                            color: ScreenColorHelper.getPrimaryAction(context),
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      // App Name Full
                      Text(
                        AppStrings.appNameFull,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: ScreenColorHelper.getPrimaryAction(context),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Deskripsi Aplikasi
                      Text(
                        AppStrings.appDescription,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: ScreenColorHelper.getBodyText(context),
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 32),
                      Divider(color: AppColors.inputBorder.withValues(alpha: 0.1), thickness: 1),
                      const SizedBox(height: 16),

                      // Metadata: Versi Aplikasi
                      _buildInfoRow(
                        context: context,
                        label: AppStrings.appVersionLabel,
                        value: AppStrings.appVersion,
                        valueColor: ScreenColorHelper.getBodyText(context),
                      ),

                      const SizedBox(height: 16),

                      // Metadata: Pengembang / Developer
                      _buildInfoRow(
                        context: context,
                        label: AppStrings.developerLabel,
                        value: AppStrings.developerName,
                        valueColor: ScreenColorHelper.getBodyText(context),
                      ),

                      const SizedBox(height: 16),

                      // Metadata: Kontak Kami
                      _buildInfoRow(
                        context: context,
                        label: AppStrings.contactUs,
                        value: AppStrings.contactEmail,
                        valueColor: ScreenColorHelper.getPrimaryAction(context),
                      ),

                      const SizedBox(height: 48),

                      // Copyright Footer
                      Text(
                        '© 2026 AICERDAS All Rights Reserved',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white70
                              : Colors.black54,
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

  // Helper Widget Row Informasi
  Widget _buildInfoRow({
    required BuildContext context,
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: ScreenColorHelper.getHeadingText(context),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}