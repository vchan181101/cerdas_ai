import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cerdas_ai/core/values/colors.dart';
import 'package:cerdas_ai/core/values/strings.dart';
import 'package:cerdas_ai/core/helpers/helpers.dart';
import 'package:cerdas_ai/presentation/widgets/widgets.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = ScreenColorHelper.getPrimaryAction(context);
    final headingColor = isDark ? Colors.white : ScreenColorHelper.getHeadingText(context);

    return BackgroundWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // Header / Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  children: [
                    Container(
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
                    const SizedBox(width: 12),
                    Text(
                      AppStrings.titleUbahBahasa,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: headingColor,
                      ),
                    ),
                  ],
                ),
              ),

              // Form Konten Scrollable
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Kolom 1: Bahasa Indonesia
                      _buildLanguageColumn(
                        name: 'Bahasa Indonesia',
                        flagWidget: _buildIndonesiaFlag(),
                        isSelected: _selectedCode == 'id',
                        isDark: isDark,
                        primaryColor: primaryColor,
                        onTap: () {
                          setState(() {
                            _selectedCode = 'id';
                          });
                        },
                      ),

                      const SizedBox(height: 14),

                      // Kolom 2: Bahasa Inggris
                      _buildLanguageColumn(
                        name: 'Bahasa English',
                        flagWidget: _buildUKFlag(),
                        isSelected: _selectedCode == 'en',
                        isDark: isDark,
                        primaryColor: primaryColor,
                        onTap: () {
                          setState(() {
                            _selectedCode = 'en';
                          });
                        },
                      ),

                      const Spacer(),

                      // Button Simpan
                      Container(
                        width: double.infinity,
                        height: 52,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: isDark
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFF2563EB),
                                    Color(0xFF6366F1),
                                    Color(0xFF8B5CF6),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                )
                              : const LinearGradient(
                                  colors: [
                                    Color(0xFF2563EB),
                                    Color(0xFF38BDF8),
                                  ],
                                ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF2563EB).withValues(alpha: isDark ? 0.45 : 0.25),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _saveLanguage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppStrings.btnSimpan,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.verified_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
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

  /// Kolom Pilihan Bahasa
  Widget _buildLanguageColumn({
    required String name,
    required Widget flagWidget,
    required bool isSelected,
    required bool isDark,
    required Color primaryColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? (isDark ? const Color(0xFF38BDF8) : primaryColor)
                : (isDark ? const Color(0xFF334155) : AppColors.inputBorder.withValues(alpha: 0.5)),
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected && isDark
              ? [
                  BoxShadow(
                    color: const Color(0xFF38BDF8).withValues(alpha: 0.25),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : null,
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
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),

            // Kanan: Icon Lingkaran sebagai Pilihan (Checkmark / Radio Indicator)
            _buildSelectionCircle(isSelected, isDark),
          ],
        ),
      ),
    );
  }

  /// Icon Lingkaran sebagai Pilihan (Checkmark / Radio Indicator)
  Widget _buildSelectionCircle(bool isSelected, bool isDark) {
    if (isSelected) {
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF38BDF8),
          boxShadow: isDark
              ? [
                  BoxShadow(
                    color: const Color(0xFF38BDF8).withValues(alpha: 0.5),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: const Icon(
          Icons.check,
          size: 16,
          color: Colors.white,
        ),
      );
    }
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isDark ? const Color(0xFF64748B) : Colors.grey.shade400,
          width: 2.0,
        ),
      ),
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
