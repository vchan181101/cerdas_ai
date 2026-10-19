import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/core.dart';
import '../../helpers/helpers.dart';
import '../../menu/menu.dart';
import '../../values/colors.dart';
import '../../values/dark_colors.dart';
import '../../values/strings.dart';
import '../../widgets/bottom_navigation_view_widget.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final int _currentBottomNavIndex = 4; // Index 4 untuk Pengaturan / Setting

  String _userName = 'Sandra Bagus Nugroho';
  String _userEmail = 'sandratika18@gmail.com';
  String _userInitials = 'SB';
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
    final name = prefs.getString(AppConstants.keyUserName) ?? 'Sandra Bagus Nugroho';
    final email = prefs.getString(AppConstants.keyUserEmail) ?? 'sandratika18@gmail.com';
    final lang = prefs.getString('APP_LANG') ?? 'Indonesia';

    if (!mounted) return;
    setState(() {
      _userName = name;
      _userEmail = email;
      _selectedLang = lang;
      _userInitials = _getInitials(name);
    });
  }

  // Membuat Inisial Nama
  String _getInitials(String name) {
    List<String> parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return 'SB';
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
          try {
            await entity.delete(recursive: true);
          } catch (e) {
            // Abaikan file yang sedang digunakan
          }
        }
      }
      
      if (!mounted) return;
      setState(() {
        _cacheSizeText = '0.0 MB';
      });
      
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppDarkColors.white : AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 14,
            height: 1.4,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppStrings.btnClose,
              style: const TextStyle(
                color: AppColors.indigoPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 5. Dialog Log Out
  void _showLogoutDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: isDark ? AppDarkColors.white : AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          AppStrings.logoutConfirmTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        content: Text(
          AppStrings.logoutConfirmMessage,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              AppStrings.btnCancel,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
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
            child: Text(
              AppStrings.btnLogout,
              style: const TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 6. Dialog Pemilihan Tema
  void _showThemeSelectionDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppDarkColors.white : AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final isDarkSheet = Theme.of(context).brightness == Brightness.dark;
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilih Tema Aplikasi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkSheet ? Colors.white : Colors.black,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? AppColors.indigoPrimary
            : (isDark ? Colors.white : Colors.black),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected
              ? AppColors.indigoPrimary
              : (isDark ? Colors.white : Colors.black),
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
                  AppStrings.titlePengaturan,
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
                              // Avatar Circle dengan Foto atau Inisial
                              ValueListenableBuilder<String?>(
                                valueListenable: userPhotoNotifier,
                                builder: (context, photoPath, child) {
                                  if (photoPath != null && File(photoPath).existsSync()) {
                                    return Container(
                                      width: 56,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: ScreenColorHelper.getPrimaryAction(context), width: 2),
                                      ),
                                      child: ClipOval(
                                        child: Image.file(
                                          File(photoPath),
                                          width: 56,
                                          height: 56,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  }
                                  return Container(
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
                                  );
                                },
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            _userName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: ScreenColorHelper.getHeadingText(context),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // Badge Status Upgrade
                                        ValueListenableBuilder<String>(
                                          valueListenable: userTierNotifier,
                                          builder: (context, tier, child) {
                                            if (tier == 'Free') return const SizedBox();
                                            return Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: ScreenColorHelper.getPrimaryAction(context),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                tier.toUpperCase(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
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

                    // UPGRADE PLUS SECTION
                    Card(
                      elevation: 1,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFE0F2FE),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: _buildSettingItem(
                        title: AppStrings.titleUpgradePlus,
                        textColor: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        trailingIcon: Icons.auto_awesome_rounded,
                        onTap: () {
                          context.pushNamed('/upgrade-plus');
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // SECTION 1: PENGATURAN UMUM
                    _buildSectionHeader(AppStrings.headerGeneral),
                    Card(
                      elevation: 1,
                      color: ScreenColorHelper.getSurfaceColor(context),
                      shape:
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        children: [
                          _buildSettingItem(
                            title: AppStrings.menuChangePassword,
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
                    _buildSectionHeader(AppStrings.headerDataStorage),
                    Card(
                      elevation: 1,
                      color: ScreenColorHelper.getSurfaceColor(context),
                      shape:
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: _buildSettingItem(
                        title: AppStrings.menuClearCache,
                        trailingText: _cacheSizeText,
                        onTap: _clearAppCache,
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
                            title: AppStrings.menuPrivacyPolicy,
                            onTap: () => _showInfoDialog(
                              AppStrings.menuPrivacyPolicy,
                              'Cerdas AI berkomitmen melindungi data dan privasi pengguna. Semua informasi, dokumen, dan riwayat pertanyaan Anda tersimpan secara aman dan terenkripsi.',
                            ),
                          ),
                          Divider(height: 1, color: AppColors.inputBorder.withValues(alpha: 0.1)),
                          _buildSettingItem(
                            title: AppStrings.menuTerms,
                            onTap: () => _showInfoDialog(
                              AppStrings.menuTerms,
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
                          child: Center(
                            child: Text(
                              AppStrings.menuLogout,
                              style: const TextStyle(
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black,
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
    Color? textColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final itemTextColor = textColor ?? (isDark ? Colors.white : Colors.black);

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
                fontWeight: textColor != null ? FontWeight.bold : FontWeight.normal,
                color: itemTextColor,
              ),
            ),
            Row(
              children: [
                if (trailingText != null) ...[
                  Text(
                    trailingText,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Icon(
                  trailingIcon,
                  size: 20,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
