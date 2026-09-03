import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../../helpers/helpers.dart';
import '../../values/values.dart';
import '../../widgets/widgets.dart';

class HomeScreenDemo extends StatelessWidget {
  const HomeScreenDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Cerdas AI Modern Demo'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: AppColors.textPrimary,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Welcome Section
              Text(
                'Selamat Datang di Cerdas AI',
                style: ScreenStyleHelper.getScreenTitleStyle(context),
              ).paddingOnly(bottom: 8),
              
              const Text(
                'Ini adalah halaman demo untuk menguji integrasi komponen, tema, dan animasi modern.',
                style: TextStyle(color: AppColors.textMuted, fontSize: 14, height: 1.5),
              ).paddingOnly(bottom: 32),

              // 2. Sample AI Response Card
              Text(
                'Contoh Respons AI:',
                style: ScreenStyleHelper.getLabelStyle(context),
              ).paddingOnly(bottom: 12),
              
              const AiResponseCard(
                response: 'Halo! Saya adalah asisten Cerdas AI. Saya siap membantu Anda menganalisis dokumen dan menjawab pertanyaan dengan cepat dan akurat.',
              ).paddingOnly(bottom: 32),

              // 3. Action Buttons Section
              Text(
                'Aksi Navigasi Demo:',
                style: ScreenStyleHelper.getLabelStyle(context),
              ).paddingOnly(bottom: 16),

              AppButton(
                text: 'GALERI ANIMASI',
                icon: Icons.auto_awesome_motion_rounded,
                onPressed: () => context.pushNamed('/animation-gallery'),
              ).paddingOnly(bottom: 12),

              AppButton(
                text: 'DEMO INPUT MODERN',
                icon: Icons.edit_note_rounded,
                backgroundColor: AppColors.white,
                foregroundColor: AppColors.indigoPrimary,
                onPressed: () => context.pushNamed('/demo-input-box'),
              ).paddingOnly(bottom: 12),

              AppButton(
                text: 'DAFTAR DOKUMEN',
                icon: Icons.folder_shared_rounded,
                backgroundColor: AppColors.emeraldSuccess,
                onPressed: () => context.pushNamed('/demo-example-docs'),
              ).paddingOnly(bottom: 12),

              const SizedBox(height: 24),
              
              // 4. Footer Info
              Center(
                child: Text(
                  AppStrings.appVersion,
                  style: const TextStyle(color: AppColors.iconTint, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
