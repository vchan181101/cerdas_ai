import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cerdas_ai/core/helpers/helpers.dart';
import 'package:cerdas_ai/core/values/colors.dart';
import 'package:cerdas_ai/presentation/widgets/widgets.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  // Opsi pilihan tema: 'system', 'light', atau 'dark'
  String _selectedTheme = 'system';

  @override
  void initState() {
    super.initState();
    _loadCurrentTheme();
  }

  // 1. Memuat Tema Terdaftar dari SharedPreferences
  Future<void> _loadCurrentTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedTheme = prefs.getString('THEME_MODE') ?? 'system';
    });
  }

  // 2. Mengubah Tema dan Menyimpan ke SharedPreferences
  Future<void> _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('THEME_MODE', _selectedTheme);

    final ThemeMode mode;
    if (_selectedTheme == 'light') {
      mode = ThemeMode.light;
    } else if (_selectedTheme == 'dark') {
      mode = ThemeMode.dark;
    } else {
      mode = ThemeMode.system;
    }

    await ThemeHelper.setTheme(mode);

    if (!mounted) return;

    final String label;
    if (_selectedTheme == 'light') {
      label = 'Terang';
    } else if (_selectedTheme == 'dark') {
      label = 'Gelap';
    } else {
      label = 'Default System';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tema diubah ke: $label'),
        backgroundColor: ScreenColorHelper.getPrimaryAction(context),
      ),
    );

    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, '/setting');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          } else {
                            Navigator.pushReplacementNamed(context, '/setting');
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Pilih Tema',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: headingColor,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Sesuaikan tampilan aplikasi Cerdas AI agar sesuai dengan kenyamanan mata Anda.',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? const Color(0xFF94A3B8) : Colors.black54,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 1. Default System
                      _buildThemeCardOption(
                        title: 'Default System',
                        icon: Icons.settings_suggest_rounded,
                        iconColor: isDark ? const Color(0xFFCBD5E1) : Colors.black54,
                        isSelected: _selectedTheme == 'system',
                        isDark: isDark,
                        onTap: () => setState(() => _selectedTheme = 'system'),
                      ),

                      const SizedBox(height: 12),

                      // 2. Terang
                      _buildThemeCardOption(
                        title: 'Terang',
                        icon: Icons.light_mode_rounded,
                        iconColor: const Color(0xFFFDBA74),
                        isSelected: _selectedTheme == 'light',
                        isDark: isDark,
                        onTap: () => setState(() => _selectedTheme = 'light'),
                      ),

                      const SizedBox(height: 12),

                      // 3. Gelap
                      _buildThemeCardOption(
                        title: 'Gelap',
                        icon: Icons.dark_mode_rounded,
                        iconColor: const Color(0xFF38BDF8),
                        isSelected: _selectedTheme == 'dark',
                        isDark: isDark,
                        onTap: () => setState(() => _selectedTheme = 'dark'),
                      ),

                      const Spacer(),

                      // Tombol Simpan Perubahan
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
                          onPressed: _saveTheme,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Simpan Perubahan',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.check_circle_outline_rounded,
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

  Widget _buildThemeCardOption({
    required String title,
    required IconData icon,
    required Color iconColor,
    required bool isSelected,
    required bool isDark,
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
                ? (isDark ? const Color(0xFF38BDF8) : AppColors.indigoPrimary)
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
            Icon(
              icon,
              size: 24,
              color: iconColor,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
            if (isSelected)
              Container(
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
              )
            else
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? const Color(0xFF64748B) : Colors.grey.shade400,
                    width: 2.0,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
