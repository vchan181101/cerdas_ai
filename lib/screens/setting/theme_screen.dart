import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../values/colors.dart';

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
  Future<void> _changeTheme(String themeName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('THEME_MODE', themeName);

    setState(() {
      _selectedTheme = themeName;
    });

    if (!mounted) return;

    final String label;
    if (themeName == 'light') {
      label = 'Terang';
    } else if (themeName == 'dark') {
      label = 'Gelap';
    } else {
      label = 'Default System';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tema diubah ke: $label')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header / Top Bar
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 28),
                    color: AppColors.textPrimary,
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/setting');
                    },
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Pilih Tema',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Opsi Pilihan Tema Container
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  // 1. Default System
                  _buildThemeOptionRow(
                    title: 'Default System',
                    isSelected: _selectedTheme == 'system',
                    onTap: () => _changeTheme('system'),
                  ),
                  const Divider(height: 1, color: AppColors.inputBorder),

                  // 2. Terang
                  _buildThemeOptionRow(
                    title: 'Terang',
                    isSelected: _selectedTheme == 'light',
                    onTap: () => _changeTheme('light'),
                  ),
                  const Divider(height: 1, color: AppColors.inputBorder),

                  // 3. Gelap
                  _buildThemeOptionRow(
                    title: 'Gelap',
                    isSelected: _selectedTheme == 'dark',
                    onTap: () => _changeTheme('dark'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget Row Pilihan Tema dengan Checkmark
  Widget _buildThemeOptionRow({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textPrimary,
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_box,
                color: AppColors.indigoPrimary,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}