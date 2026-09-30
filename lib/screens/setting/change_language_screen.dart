import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../values/colors.dart';
import '../../values/strings.dart';
import '../../helpers/helpers.dart';
import '../../widgets/language_option_widget.dart';

class ChangeLanguageScreen extends StatefulWidget {
  const ChangeLanguageScreen({super.key});

  @override
  State<ChangeLanguageScreen> createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  // Pilihan bahasa yang sedang aktif/dipilih sementara ('id' atau 'en')
  String _selectedCode = 'id';

  @override
  void initState() {
    super.initState();
    _loadCurrentLanguage();
  }

  // 1. Memuat Kode Bahasa Aktif dari SharedPreferences / Notifier
  Future<void> _loadCurrentLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString('APP_LANG_CODE') ?? 
        appLocaleNotifier.value.languageCode;
    setState(() {
      _selectedCode = (savedCode == 'en') ? 'en' : 'id';
    });
  }

  // 2. Menyimpan Bahasa Baru ketika tombol Simpan ditekan
  Future<void> _saveLanguage() async {
    // a. Simpan bahasa baru ke SharedPreferences & perbarui objek Locale
    final newLocale = await LocaleHelper.setLocale(_selectedCode);

    // b. Simpan nama deskriptif bahasa untuk profil pengguna / setting
    final prefs = await SharedPreferences.getInstance();
    final String langName = (_selectedCode == 'en') ? 'English' : 'Indonesia';
    await prefs.setString('APP_LANG', langName);
    await prefs.setString('APP_LANG_CODE', _selectedCode);

    // c. Perbarui state bahasa global aplikasi secara langsung
    appLocaleNotifier.value = newLocale;

    if (!mounted) return;

    final String snackbarText = (_selectedCode == 'en')
        ? 'Language successfully changed to English'
        : 'Bahasa berhasil diubah ke Bahasa Indonesia';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(snackbarText),
        backgroundColor: ScreenColorHelper.getPrimaryAction(context),
        duration: const Duration(seconds: 2),
      ),
    );

    // d. Navigasi kembali ke halaman sebelumnya
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = ScreenColorHelper.getPrimaryAction(context);
    final cardColor = ScreenColorHelper.getSurfaceColor(context);
    final headingColor = ScreenColorHelper.getHeadingText(context);

    return Scaffold(
      backgroundColor: ScreenColorHelper.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: ScreenColorHelper.getBackgroundColor(context),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 22,
            color: headingColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppStrings.titleUbahBahasa,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: headingColor,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Kolom 1: Bahasa Indonesia
              _buildLanguageColumn(
                name: 'Bahasa Indonesia',
                flagWidget: _buildIndonesiaFlag(),
                isSelected: _selectedCode == 'id',
                cardColor: cardColor,
                primaryColor: primaryColor,
                headingColor: headingColor,
                onTap: () {
                  setState(() {
                    _selectedCode = 'id';
                  });
                },
              ),

              const SizedBox(height: 12),

              // Kolom 2: Bahasa Inggris
              _buildLanguageColumn(
                name: 'Bahasa English',
                flagWidget: _buildUKFlag(),
                isSelected: _selectedCode == 'en',
                cardColor: cardColor,
                primaryColor: primaryColor,
                headingColor: headingColor,
                onTap: () {
                  setState(() {
                    _selectedCode = 'en';
                  });
                },
              ),

              const SizedBox(height: 32),

              // Button Simpan
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _saveLanguage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    AppStrings.btnSimpan,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Kolom Pilihan Bahasa
  Widget _buildLanguageColumn({
    required String name,
    required Widget flagWidget,
    required bool isSelected,
    required Color cardColor,
    required Color primaryColor,
    required Color headingColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? primaryColor
                : AppColors.inputBorder.withValues(alpha: 0.3),
            width: isSelected ? 1.8 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isSelected ? 0.04 : 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Kiri: Icon Bendera
            flagWidget,
            const SizedBox(width: 14),

            // Tengah: Kalimat Bahasa
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: headingColor,
                ),
              ),
            ),

            // Kanan: Icon Lingkaran sebagai Pilihan
            _buildSelectionCircle(isSelected, primaryColor),
          ],
        ),
      ),
    );
  }

  /// Icon Lingkaran sebagai Pilihan (Checkmark / Radio Indicator)
  Widget _buildSelectionCircle(bool isSelected, Color primaryColor) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? primaryColor : Colors.transparent,
        border: Border.all(
          color: isSelected ? primaryColor : Colors.grey.shade400,
          width: 2.0,
        ),
      ),
      child: isSelected
          ? const Icon(
              Icons.check,
              size: 14,
              color: Colors.white,
            )
          : null,
    );
  }

  /// Icon Bendera Indonesia (Merah Putih)
  Widget _buildIndonesiaFlag() {
    return Container(
      width: 38,
      height: 26,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.black.withValues(alpha: 0.15), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3.2),
        child: Column(
          children: [
            Expanded(child: Container(color: const Color(0xFFCE1126))),
            Expanded(child: Container(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  /// Icon Bendera United Kingdom (Union Jack)
  Widget _buildUKFlag() {
    return Container(
      width: 38,
      height: 26,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.black.withValues(alpha: 0.15), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3.2),
        child: CustomPaint(
          size: const Size(38, 26),
          painter: UKFlagPainter(),
        ),
      ),
    );
  }
}

/// CustomPainter untuk Bendera United Kingdom (Union Jack)
class UKFlagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Latar Belakang Biru Navy
    final bgPaint = Paint()..color = const Color(0xFF012169);
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bgPaint);

    // 2. Garis Diagonal Putih
    final whiteDiagPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = h * 0.32
      ..strokeCap = StrokeCap.square;
    canvas.drawLine(Offset.zero, Offset(w, h), whiteDiagPaint);
    canvas.drawLine(Offset(0, h), Offset(w, 0), whiteDiagPaint);

    // 3. Garis Diagonal Merah (St. Patrick)
    final redDiagPaint = Paint()
      ..color = const Color(0xFFC8102E)
      ..strokeWidth = h * 0.14
      ..strokeCap = StrokeCap.square;
    canvas.drawLine(Offset.zero, Offset(w, h), redDiagPaint);
    canvas.drawLine(Offset(0, h), Offset(w, 0), redDiagPaint);

    // 4. Salib Tegak Putih (Tengah)
    final whiteCrossPaint = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(0, (h - h * 0.38) / 2, w, h * 0.38), whiteCrossPaint);
    canvas.drawRect(Rect.fromLTWH((w - w * 0.26) / 2, 0, w * 0.26, h), whiteCrossPaint);

    // 5. Salib Tegak Merah (St. George)
    final redCrossPaint = Paint()..color = const Color(0xFFC8102E);
    canvas.drawRect(Rect.fromLTWH(0, (h - h * 0.22) / 2, w, h * 0.22), redCrossPaint);
    canvas.drawRect(Rect.fromLTWH((w - w * 0.15) / 2, 0, w * 0.15, h), redCrossPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}