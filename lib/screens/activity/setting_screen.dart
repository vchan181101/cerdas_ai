import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/core.dart';
import '../../helpers/helpers.dart';
import '../../menu/menu.dart';
import '../../values/colors.dart';
import '../../values/strings.dart';
import '../../widgets/bottom_navigation_view_widget.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final int _currentBottomNavIndex = 4; // Index 4 untuk Pengaturan / Setting

  String _userName = 'Cerdas Pengguna';
  String _userEmail = 'user.cerdas@gmail.com';
  String _userInitials = 'CP';
  String _selectedLang = 'Indonesia';
  String _cacheSizeText = '0.0 MB';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _calculateCacheSize();
  }

  // 1. Memuat Profil Pengguna & Data Preferensi
  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(AppConstants.keyUserName) ?? 'Cerdas Pengguna';
    final email = prefs.getString(AppConstants.keyUserEmail) ?? 'user.cerdas@gmail.com';
    final lang = prefs.getString('APP_LANG') ?? 'Indonesia';

    if (!mounted) return;
    setState(() {
      _userName = name;
      _userEmail = email;
      _selectedLang = lang;
      _userInitials = _getInitials(name);
    });
  }

  // Membuat Inisial Nama (Misal: "Cerdas Pengguna" -> "CP")
  String _getInitials(String name) {
    List<String> parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return 'CP';
  }

  // 2. Kalkulasi Ukuran Cache Aplikasi
  Future<void> _calculateCacheSize() async {
    try {
      final tempDir = await getTemporaryDirectory();
      int totalSize = await _getFolderSize(tempDir);
      double sizeInMb = totalSize / (1024 * 1024);
      if (!mounted) return;
      setState(() {
        _cacheSizeText = '${sizeInMb.toStringAsFixed(1)} MB';
      });
    } catch (e) {
      LoggerUtil.error('Failed to calculate cache size', e);
      if (!mounted) return;
      setState(() {
        _cacheSizeText = '0.0 MB';
      });
    }
  }

  Future<int> _getFolderSize(Directory dir) async {
    int size = 0;
    try {
      if (await dir.exists()) {
        await for (var entity in dir.list(recursive: true, followLinks: false)) {
          if (entity is File) {
            size += await entity.length();
          }
        }
      }
    } catch (e) {
      LoggerUtil.warning('Error listing directory for size: $e');
    }
    return size;
  }

  // 3. Membersihkan Cache Aplikasi
  Future<void> _clearAppCache() async {
    try {
      final tempDir = await getTemporaryDirectory();
      if (await dirExists(tempDir.path)) {
        final List<FileSystemEntity> entities = await tempDir.list().toList();
        for (final entity in entities) {
          await entity.delete(recursive: true);
        }
      }
      await _calculateCacheSize();
      if (!mounted) return;
      context.showSnackBar('Cache berhasil dibersihkan!');
    } catch (e) {
      LoggerUtil.error('Failed to clear cache', e);
      if (!mounted) return;
      context.showSnackBar('Gagal membersihkan cache.');
    }
  }

  Future<bool> dirExists(String path) async {
    return await Directory(path).exists();
  }

  // 4. Dialog Informasional
  void _showInfoDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message, style: const TextStyle(fontSize: 14, height: 1.4)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup',
                style: TextStyle(
                    color: AppColors.indigoPrimary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // 5. Dialog Log Out
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Konfirmasi Keluar',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Apakah Anda yakin ingin keluar dari akun Cerdas AI?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal', style: TextStyle(color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool(AppConstants.keyIsLoggedIn, false);

              if (!mounted) return;
              context.showSnackBar('Berhasil keluar');
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
            child: const Text('Keluar',
                style:
                    TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // 6. Dialog Pemilihan Tema
  void _showThemeSelectionDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pilih Tema Aplikasi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _buildThemeOption(
                title: 'Default System',
                icon: Icons.brightness_auto_rounded,
                mode: ThemeMode.system,
              ),
              _buildThemeOption(
                title: 'Terang',
                icon: Icons.light_mode_rounded,
                mode: ThemeMode.light,
              ),
              _buildThemeOption(
                title: 'Gelap',
                icon: Icons.dark_mode_rounded,
                mode: ThemeMode.dark,
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeOption({
    required String title,
    required IconData icon,
    required ThemeMode mode,
  }) {
    final bool isSelected = appThemeNotifier.value == mode;

    return ListTile(
      leading: Icon(icon, color: isSelected ? AppColors.indigoPrimary : AppColors.iconTint),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppColors.indigoPrimary : AppColors.textPrimary,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppColors.indigoPrimary)
          : null,
      onTap: () {
        ThemeHelper.setTheme(mode);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScreenColorHelper.getBackgroundColor(context),
      body: SafeArea(
        child: Column(
          children: [
            // Header / Title
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  'Pengaturan',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: ScreenColorHelper.getHeadingText(context),
                  ),
                ),
              ),
            ),

            // Main Content Area ScrollView
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card Profil
                    Card(
                      elevation: 2,
                      color: ScreenColorHelper.getSurfaceColor(context),
                      shadowColor: ScreenColorHelper.getPrimaryAction(context).withValues(alpha: 0.1),
                      shape:
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: InkWell(
                        onTap: () {
                          context.pushNamed('/edit-profil');
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              // Avatar Circle dengan Inisial
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: ScreenColorHelper.getPrimaryAction(context),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    _userInitials,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _userName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: ScreenColorHelper.getHeadingText(context),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _userEmail,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: ScreenColorHelper.getBodyText(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'Edit',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: ScreenColorHelper.getPrimaryAction(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // SECTION 1: PENGATURAN UMUM
                    _buildSectionHeader('PENGATURAN UMUM'),
                    Card(
                      elevation: 1,
                      color: ScreenColorHelper.getSurfaceColor(context),
                      shape:
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        children: [
                          _buildSettingItem(
                            title: 'Ubah Kata Sandi',
                            onTap: () => context.pushNamed('/ubah-kata-sandi'),
                          ),
                          Divider(height: 1, color: AppColors.inputBorder.withValues(alpha: 0.1)),
                          _buildSettingItem(
                            title: AppStrings.titleUbahBahasa,
                            trailingText: _selectedLang,
                            onTap: () async {
                              await Navigator.pushNamed(context, '/ubah-bahasa');
                              _loadUserProfile();
                            },
                          ),
                          Divider(height: 1, color: AppColors.inputBorder.withValues(alpha: 0.1)),
                          ValueListenableBuilder<ThemeMode>(
                            valueListenable: appThemeNotifier,
                            builder: (context, currentMode, child) {
                              return _buildSettingItem(
                                title: 'Tema',
                                trailingText: ThemeHelper.getThemeLabel(currentMode),
                                onTap: _showThemeSelectionDialog,
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // SECTION 2: DATA & PENYIMPANAAN
                    _buildSectionHeader('DATA & PENYIMPANAAN'),
                    Card(
                      elevation: 1,
                      color: ScreenColorHelper.getSurfaceColor(context),
                      shape:
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        children: [
                          _buildSettingItem(
                            title: AppStrings.titleDokumenTersimpan,
                            onTap: () => context.pushNamed('/dokumen-tersimpan'),
                          ),
                          Divider(height: 1, color: AppColors.inputBorder.withValues(alpha: 0.1)),
                          _buildSettingItem(
                            title: 'Bersihkan Cache',
                            trailingText: _cacheSizeText,
                            onTap: _clearAppCache,
                          ),
                          Divider(height: 1, color: AppColors.inputBorder.withValues(alpha: 0.1)),
                          _buildSettingItem(
                            title: 'Sampah',
                            trailingIcon: Icons.delete_outline,
                            onTap: () => context.pushNamed('/sampah'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // SECTION 3: INFORMASI & LEGAL
                    _buildSectionHeader(AppStrings.menuInformasi.toUpperCase()),
                    Card(
                      elevation: 1,
                      color: ScreenColorHelper.getSurfaceColor(context),
                      shape:
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        children: [
                          _buildSettingItem(
                            title: 'Kebijakan Privasi',
                            onTap: () => _showInfoDialog(
                              'Kebijakan Privasi',
                              'Cerdas AI berkomitmen melindungi data dan privasi pengguna. Semua informasi, dokumen, dan riwayat pertanyaan Anda tersimpan secara aman dan terenkripsi.',
                            ),
                          ),
                          Divider(height: 1, color: AppColors.inputBorder.withValues(alpha: 0.1)),
                          _buildSettingItem(
                            title: 'Syarat & Ketentuan',
                            onTap: () => _showInfoDialog(
                              'Syarat & Ketentuan',
                              'Dengan menggunakan Cerdas AI, Anda menyetujui penggunaan layanan untuk tujuan yang sah dan tidak melanggar hukum. Hak cipta dokumen milik pengguna masing-masing.',
                            ),
                          ),
                          Divider(height: 1, color: AppColors.inputBorder.withValues(alpha: 0.1)),
                          _buildSettingItem(
                            title: AppStrings.titleTentang,
                            onTap: () => context.pushNamed('/tentang-aplikasi'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Tombol Logout
                    Card(
                      elevation: 0,
                      color: const Color(0xFFFEF2F2).withValues(alpha: Theme.of(context).brightness == Brightness.dark ? 0.1 : 1.0),
                      shape:
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: InkWell(
                        onTap: _showLogoutDialog,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16.0),
                          child: const Center(
                            child: Text(
                              'Keluar dari Akun',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFEF4444),
                              ),
                            ),
                          ),
                        ),
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

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationViewWidget(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          BottomNavMenu.handleNavigation(context, _currentBottomNavIndex, index);
        },
      ),
    );
  }

  // Helper Section Header Label
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: ScreenColorHelper.getBodyText(context).withValues(alpha: 0.5),
        ),
      ),
    );
  }

  // Helper ListItem Setting Row
  Widget _buildSettingItem({
    required String title,
    String? trailingText,
    IconData trailingIcon = Icons.chevron_right,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: ScreenColorHelper.getHeadingText(context),
              ),
            ),
            Row(
              children: [
                if (trailingText != null) ...[
                  Text(
                    trailingText,
                    style: TextStyle(fontSize: 14, color: ScreenColorHelper.getBodyText(context)),
                  ),
                  const SizedBox(width: 8),
                ],
                Icon(trailingIcon, size: 20, color: ScreenColorHelper.getBodyText(context).withValues(alpha: 0.3)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
