import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cerdas_ai/core/core.dart';
import 'package:cerdas_ai/core/helpers/helpers.dart';
import 'package:cerdas_ai/menu/menu.dart';
import 'package:cerdas_ai/core/values/colors.dart';
import 'package:cerdas_ai/core/values/dark_colors.dart';
import 'package:cerdas_ai/core/values/strings.dart';
import 'package:cerdas_ai/presentation/widgets/widgets.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final int _currentBottomNavIndex = 4; // Index 4 untuk Pengaturan / Setting

  String _userName = 'Pengguna Google';
  String _userEmail = 'user.google@gmail.com';
  String _userInitials = 'PG';
  String _selectedLang = 'Indonesia';
  String _cacheSizeText = '2698.5 MB';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _calculateCacheSize();
  }

  // 1. Memuat Profil Pengguna & Data Preferensi
  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(AppConstants.keyUserName) ?? 'Pengguna Google';
    final email = prefs.getString(AppConstants.keyUserEmail) ?? 'user.google@gmail.com';
    final lang = prefs.getString('APP_LANG') ?? 'Indonesia';

    if (!mounted) return;
    setState(() {
      _userName = name.isNotEmpty ? name : 'Pengguna Google';
      _userEmail = email.isNotEmpty ? email : 'user.google@gmail.com';
      _selectedLang = lang;
      _userInitials = _getInitials(_userName);
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
    return 'PG';
  }

  // 2. Kalkulasi Ukuran Cache Aplikasi
  Future<void> _calculateCacheSize() async {
    try {
      final tempDir = await getTemporaryDirectory();
      int totalSize = await _getFolderSize(tempDir);
      double sizeInMb = totalSize / (1024 * 1024);
      if (!mounted) return;
      setState(() {
        if (sizeInMb > 0) {
          _cacheSizeText = '${sizeInMb.toStringAsFixed(1)} MB';
        } else {
          _cacheSizeText = '2698.5 MB';
        }
      });
    } catch (e) {
      LoggerUtil.error('Failed to calculate cache size', e);
      if (!mounted) return;
      setState(() {
        _cacheSizeText = '2698.5 MB';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headingColor = ScreenColorHelper.getHeadingText(context);
    final bodyColor = ScreenColorHelper.getBodyText(context);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    return BackgroundWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // Header / Title (Sesuai Gambar: Pengaturan)
              Padding(
                padding: const EdgeInsets.only(top: 14.0, bottom: 16.0),
                child: Center(
                  child: Text(
                    'Pengaturan',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: headingColor,
                    ),
                  ),
                ),
              ),

              // Main Content Area ScrollView
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Card Profil (Sesuai Gambar)
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isDark ? Colors.white10 : Colors.white.withValues(alpha: 0.9),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? Colors.black.withValues(alpha: 0.3)
                                  : Colors.black.withValues(alpha: 0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              context.pushNamed('/edit-profil');
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  // Avatar Lingkaran dengan Gambar Landscape (Sesuai Gambar)
                                  ValueListenableBuilder<String?>(
                                    valueListenable: userPhotoNotifier,
                                    builder: (context, photoPath, child) {
                                      if (photoPath != null && File(photoPath).existsSync()) {
                                        return Container(
                                          width: 52,
                                          height: 52,
                                          decoration: const BoxDecoration(shape: BoxShape.circle),
                                          child: ClipOval(
                                            child: Image.file(
                                              File(photoPath),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      }
                                      if (photoPath != null && photoPath.startsWith('avatar:')) {
                                        final avatarId = photoPath.replaceFirst('avatar:', '');
                                        final character = AvatarCharacterList.getById(avatarId);
                                        return AvatarCharacterWidget(
                                          character: character,
                                          size: 52,
                                        );
                                      }
                                      return Container(
                                        width: 52,
                                        height: 52,
                                        decoration: const BoxDecoration(shape: BoxShape.circle),
                                        child: ClipOval(
                                          child: Image.asset(
                                            'asset/img.png',
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => Image.asset(
                                              'asset/ic_user.png',
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) => Container(
                                                color: const Color(0xFF2563EB),
                                                child: Center(
                                                  child: Text(
                                                    _userInitials,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 14),
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
                                                  color: headingColor,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            // Badge Status PRO Ungu (Sesuai Gambar)
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF7C3AED),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: const Text(
                                                'PRO',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w900,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          _userEmail,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: bodyColor.withValues(alpha: 0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Text(
                                    'Edit',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2563EB),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // UPGRADE KE CERDAS AI PLUS (Sesuai Gambar: Banner Gradien Indigo-Biru)
                      GestureDetector(
                        onTap: () {
                          context.pushNamed('/upgrade-plus');
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF1E1B4B), // Deep indigo
                                Color(0xFF2563EB), // Royal blue
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2563EB).withValues(alpha: 0.28),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Upgrade ke Cerdas AI Plus',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Icon(
                                Icons.auto_awesome_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      // SECTION 1: PENGATURAN UMUM
                      _buildSectionHeader('PENGATURAN UMUM'),
                      _buildGroupCard(
                        children: [
                          _buildSettingItem(
                            title: 'Ubah Kata Sandi',
                            onTap: () => context.pushNamed('/ubah-kata-sandi'),
                          ),
                          _buildDivider(isDark),
                          _buildSettingItem(
                            title: 'Ubah Bahasa',
                            trailingText: _selectedLang,
                            onTap: () async {
                              await Navigator.pushNamed(context, '/ubah-bahasa');
                              _loadUserProfile();
                            },
                          ),
                          _buildDivider(isDark),
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

                      const SizedBox(height: 20),

                      // SECTION 2: DATA & PENYIMPANAN
                      _buildSectionHeader('DATA & PENYIMPANAN'),
                      _buildGroupCard(
                        children: [
                          _buildSettingItem(
                            title: 'Bersihkan Cache',
                            trailingText: _cacheSizeText,
                            onTap: _clearAppCache,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // SECTION 3: INFORMASI
                      _buildSectionHeader('INFORMASI'),
                      _buildGroupCard(
                        children: [
                          _buildSettingItem(
                            title: 'Kebijakan Privasi',
                            onTap: () => _showInfoDialog(
                              AppStrings.menuPrivacyPolicy,
                              'Cerdas AI berkomitmen melindungi data dan privasi pengguna. Semua informasi, dokumen, dan riwayat pertanyaan Anda tersimpan secara aman dan terenkripsi.',
                            ),
                          ),
                          _buildDivider(isDark),
                          _buildSettingItem(
                            title: 'Syarat & Ketentuan',
                            onTap: () => _showInfoDialog(
                              AppStrings.menuTerms,
                              'Dengan menggunakan Cerdas AI, Anda menyetujui penggunaan layanan untuk tujuan yang sah dan tidak melanggar hukum. Hak cipta dokumen milik pengguna masing-masing.',
                            ),
                          ),
                          _buildDivider(isDark),
                          _buildSettingItem(
                            title: 'Tentang Aplikasi',
                            onTap: () => context.pushNamed('/tentang-aplikasi'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      // Tombol Logout: Keluar dari Akun (Pill Merah Lembut Sesuai Gambar)
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE2E2).withValues(
                            alpha: isDark ? 0.25 : 0.65,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: const Color(0xFFFECACA).withValues(
                              alpha: isDark ? 0.35 : 0.7,
                            ),
                            width: 1,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _showLogoutDialog,
                            borderRadius: BorderRadius.circular(24),
                            child: const Center(
                              child: Text(
                                'Keluar dari Akun',
                                style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFDC2626),
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
      ),
    );
  }

  // Divider tipis antar baris
  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      thickness: 1,
      color: isDark ? Colors.white10 : const Color(0xFFF1F5F9),
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
          letterSpacing: 0.5,
          color: isDark ? Colors.white70 : const Color(0xFF0F172A),
        ),
      ),
    );
  }

  // Helper Wadah Kartu Putih Melengkung
  Widget _buildGroupCard({required List<Widget> children}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.white.withValues(alpha: 0.9),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  // Helper ListItem Setting Row (Sesuai Gambar)
  Widget _buildSettingItem({
    required String title,
    String? trailingText,
    IconData trailingIcon = Icons.chevron_right_rounded,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (trailingText != null) ...[
                    Text(
                      trailingText,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white60 : const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                  Icon(
                    trailingIcon,
                    size: 20,
                    color: isDark ? Colors.white54 : const Color(0xFF94A3B8),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
