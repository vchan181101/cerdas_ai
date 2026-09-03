import 'dart:io';
import 'package:flutter/material.dart';
import '../../helpers/color/screen_color_helper.dart';
import '../../values/colors.dart';

class KeteranganScreen extends StatelessWidget {
  final String? title;
  final String? content;
  final String? imageUri;
  final String? fileSize;
  final String? fileFormat;

  const KeteranganScreen({
    super.key,
    this.title,
    this.content,
    this.imageUri,
    this.fileSize,
    this.fileFormat,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Ambil data dari Route Arguments jika tidak diberikan lewat Constructor
    final Map<String, dynamic>? args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final String displayTitle = title ?? args?['EXTRA_TITLE'] ?? "Analisis AI Terperinci";
    final String displayContent = content ?? args?['EXTRA_CONTENT'] ?? "Memuat penjelasan...";
    final String? displayImageUri = imageUri ?? args?['EXTRA_IMAGE_URI'];
    final String displayFileSize = fileSize ?? args?['EXTRA_FILE_SIZE'] ?? "0.90 MB";
    final String displayFileFormat = fileFormat ?? args?['EXTRA_FILE_FORMAT'] ?? "JPEG / Gambar";

    return Scaffold(
      backgroundColor: ScreenColorHelper.getBackgroundColor(context),
      body: SafeArea(
        child: Column(
          children: [
            // Header / Top Toolbar
            _buildTopBar(context),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Detail Card (Gambar, Judul, Garis Aksen, & Konten)
                    _buildDetailCard(
                      context: context,
                      imageUri: displayImageUri,
                      title: displayTitle,
                      content: displayContent,
                    ),

                    const SizedBox(height: 24),

                    // Section Title: Informasi Berkas
                    Text(
                      "Informasi Berkas",
                      style: TextStyle(
                        color: ScreenColorHelper.getHeadingText(context),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Card Informasi Berkas (Ukuran & Format)
                    _buildFileInfoCard(
                      context: context,
                      fileSize: displayFileSize,
                      fileFormat: displayFileFormat,
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // WIDGET BUILDERS
  // ==========================================================================

  // 1. Top Bar Widget
  Widget _buildTopBar(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Tombol Back di kiri
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: ScreenColorHelper.getHeadingText(context)),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
          // Judul di tengah
          Text(
            "Keterangan Detail",
            style: TextStyle(
              color: ScreenColorHelper.getHeadingText(context),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // 2. Detail Card (Gambar, Judul, Aksen & Penjelasan)
  Widget _buildDetailCard({
    required BuildContext context,
    required String? imageUri,
    required String title,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ScreenColorHelper.getSurfaceColor(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // a. Gambar di bagian atas card
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: SizedBox(
              width: double.infinity,
              height: 220,
              child: _buildImageWidget(imageUri),
            ),
          ),

          // b. Konten Teks di bawah gambar
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul
                Text(
                  title,
                  style: TextStyle(
                    color: ScreenColorHelper.getHeadingText(context),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                // Garis Aksen
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: ScreenColorHelper.getPrimaryAction(context),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                const SizedBox(height: 20),

                // Penjelasan Keterangan
                Text(
                  content,
                  style: TextStyle(
                    color: ScreenColorHelper.getBodyText(context),
                    fontSize: 14,
                    height: 1.6, // lineSpacingExtra
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 3. Card Informasi Berkas (Ukuran File & Format)
  Widget _buildFileInfoCard({
    required BuildContext context,
    required String fileSize,
    required String fileFormat,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: ScreenColorHelper.getSurfaceColor(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.inputBorder.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          // a. Ukuran File
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Ukuran File",
                style: TextStyle(
                  color: ScreenColorHelper.getBodyText(context),
                  fontSize: 13,
                ),
              ),
              Text(
                fileSize,
                style: TextStyle(
                  color: ScreenColorHelper.getHeadingText(context),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // Divider Line
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(
              color: ScreenColorHelper.getHeadingText(context).withValues(alpha: 0.08),
              height: 1,
              thickness: 1,
            ),
          ),

          // b. Format
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Format",
                style: TextStyle(
                  color: ScreenColorHelper.getBodyText(context),
                  fontSize: 13,
                ),
              ),
              Text(
                fileFormat,
                style: TextStyle(
                  color: ScreenColorHelper.getHeadingText(context),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper render Image (URL, Local File, Asset, atau Fallback Icon)
  Widget _buildImageWidget(String? path) {
    if (path == null || path.isEmpty) {
      return Container(
        color: const Color(0xFFE2E8F0),
        child: const Center(
          child: Icon(Icons.image, color: Colors.black26, size: 60),
        ),
      );
    }
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildFallbackImage(),
      );
    } else if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildFallbackImage(),
      );
    } else {
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildFallbackImage(),
      );
    }
  }

  Widget _buildFallbackImage() {
    return Container(
      color: const Color(0xFFE2E8F0),
      child: const Center(
        child: Icon(Icons.broken_image, color: Colors.black26, size: 60),
      ),
    );
  }
}