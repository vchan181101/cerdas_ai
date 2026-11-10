import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cerdas_ai/core/core.dart';
import 'package:cerdas_ai/core/helpers/helpers.dart';
import 'package:cerdas_ai/menu/menu.dart';
import 'package:cerdas_ai/core/values/colors.dart';
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
        backgroundColor: isDark ? const Color(0xFF0F172A) : AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isDark
              ? const BorderSide(color: Color(0xFF1E293B), width: 1.2)
              : BorderSide.none,
        ),
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
              style: TextStyle(
                color: isDark ? const Color(0xFF38BDF8) : AppColors.indigoPrimary,
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
        backgroundColor: isDark ? const Color(0xFF0F172A) : AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isDark
              ? const BorderSide(color: Color(0xFF1E293B), width: 1.2)
              : BorderSide.none,
        ),
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
    ThemeMode tempSelectedMode = appThemeNotifier.value;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF0F172A) : AppColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final isDarkSheet = Theme.of(context).brightness == Brightness.dark;
            final headingColor = isDarkSheet ? Colors.white : Colors.black87;

            return SafeArea(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                decoration: BoxDecoration(
                  color: isDarkSheet ? const Color(0xFF0F172A) : Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle Bar
                    Center(
                      child: Container(
                        width: 44,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isDarkSheet ? const Color(0xFF475569) : Colors.black26,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Header Row: Title & Close Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Pilih Tema Aplikasi',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: headingColor,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            size: 24,
                            color: isDarkSheet ? Colors.white70 : Colors.black54,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => Navigator.pop(modalContext),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Subtitle
                    Text(
                      'Sesuaikan tampilan aplikasi Cerdas AI agar sesuai dengan kenyamanan mata Anda.',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDarkSheet ? const Color(0xFF94A3B8) : Colors.black54,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 1. Default System
                    _buildThemeCardOption(
                      title: 'Default System',
                      icon: Icons.settings_suggest_rounded,
                      iconColor: isDarkSheet ? const Color(0xFFCBD5E1) : Colors.black54,
                      mode: ThemeMode.system,
                      isSelected: tempSelectedMode == ThemeMode.system,
                      isDark: isDarkSheet,
                      onTap: () {
                        setModalState(() {
                          tempSelectedMode = ThemeMode.system;
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    // 2. Terang
                    _buildThemeCardOption(
                      title: 'Terang',
                      icon: Icons.light_mode_rounded,
                      iconColor: const Color(0xFFFDBA74),
                      mode: ThemeMode.light,
                      isSelected: tempSelectedMode == ThemeMode.light,
                      isDark: isDarkSheet,
                      onTap: () {
                        setModalState(() {
                          tempSelectedMode = ThemeMode.light;
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    // 3. Gelap
                    _buildThemeCardOption(
                      title: 'Gelap',
                      icon: Icons.dark_mode_rounded,
                      iconColor: const Color(0xFF38BDF8),
                      mode: ThemeMode.dark,
                      isSelected: tempSelectedMode == ThemeMode.dark,
                      isDark: isDarkSheet,
                      onTap: () {
                        setModalState(() {
                          tempSelectedMode = ThemeMode.dark;
                        });
                      },
                    ),

                    const SizedBox(height: 24),

                    // Tombol Simpan Perubahan
                    Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: isDarkSheet
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
                            color: const Color(0xFF2563EB).withValues(alpha: isDarkSheet ? 0.45 : 0.25),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          ThemeHelper.setTheme(tempSelectedMode);
                          Navigator.pop(modalContext);
                        },
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

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildThemeCardOption({
    required String title,
    required IconData icon,
    required Color iconColor,
    required ThemeMode mode,
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
                  color: isSelected && isDark
                      ? const Color(0xFF38BDF8)
                      : (isDark ? Colors.white : Colors.black87),
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headingColor = ScreenColorHelper.getHeadingText(context);
    final bodyColor = ScreenColorHelper.getBodyText(context);
    final surfaceColor = isDark ? const Color(0xFF0F172A) : Colors.white;

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
                      color: isDark ? Colors.white : headingColor,
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
                            color: isDark ? const Color(0xFF1E293B) : Colors.white.withValues(alpha: 0.9),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? Colors.black.withValues(alpha: 0.35)
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
                                  // Avatar Lingkaran dengan Neon Gradient Ring (Sesuai Gambar)
                                  Container(
                                    padding: const EdgeInsets.all(2.5),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF38BDF8),
                                          Color(0xFFA855F7),
                                          Color(0xFFEC4899),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF38BDF8).withValues(alpha: isDark ? 0.4 : 0.2),
                                          blurRadius: 10,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: ValueListenableBuilder<String?>(
                                      valueListenable: userPhotoNotifier,
                                      builder: (context, photoPath, child) {
                                        if (photoPath != null && File(photoPath).existsSync()) {
                                          return Container(
                                            width: 50,
                                            height: 50,
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
                                            size: 50,
                                          );
                                        }
                                        return Container(
                                          width: 50,
                                          height: 50,
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
                                                  color: isDark ? Colors.white : headingColor,
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
                                            color: isDark
                                                ? const Color(0xFF94A3B8)
                                                : bodyColor.withValues(alpha: 0.7),
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
                                      color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF2563EB),
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
                                Color(0xFF1D4ED8), // Royal electric blue
                                Color(0xFF2563EB),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2563EB).withValues(alpha: 0.35),
                                blurRadius: 14,
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
                      _buildSectionHeader(AppStrings.headerGeneral),
                      _buildGroupCard(
                        children: [
                          _buildSettingItem(
                            title: 'Ubah Kata Sandi',
                            leadingIcon: Icons.lock_outline_rounded,
                            onTap: () => context.pushNamed('/ubah-kata-sandi'),
                          ),
                          _buildDivider(isDark),
                          _buildSettingItem(
                            title: 'Ubah Bahasa',
                            leadingIcon: Icons.language_rounded,
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
                                leadingIcon: Icons.dark_mode_outlined,
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
                            leadingIcon: Icons.cleaning_services_rounded,
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
                            leadingIcon: Icons.shield_outlined,
                            onTap: () => _showInfoDialog(
                              AppStrings.menuPrivacyPolicy,
                              'Cerdas AI berkomitmen melindungi data dan privasi pengguna. Semua informasi, dokumen, dan riwayat pertanyaan Anda tersimpan secara aman dan terenkripsi.',
                            ),
                          ),
                          _buildDivider(isDark),
                          _buildSettingItem(
                            title: 'Syarat & Ketentuan',
                            leadingIcon: Icons.article_outlined,
                            onTap: () => _showInfoDialog(
                              AppStrings.menuTerms,
                              'Dengan menggunakan Cerdas AI, Anda menyetujui penggunaan layanan untuk tujuan yang sah dan tidak melanggar hukum. Hak cipta dokumen milik pengguna masing-masing.',
                            ),
                          ),
                          _buildDivider(isDark),
                          _buildSettingItem(
                            title: 'Tentang Aplikasi',
                            leadingIcon: Icons.info_outline_rounded,
                            onTap: () => context.pushNamed('/tentang-aplikasi'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      // Tombol Logout: Keluar dari Akun (Pill Merah Gelap Sesuai Gambar)
                      Container(
                        width: double.infinity,
                        height: 52,
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF2E1218).withValues(alpha: 0.8)
                              : const Color(0xFFFEE2E2).withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(26),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF7F1D1D).withValues(alpha: 0.6)
                                : const Color(0xFFFECACA).withValues(alpha: 0.7),
                            width: 1.2,
                          ),
                          boxShadow: isDark
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFFDC2626).withValues(alpha: 0.15),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                              : null,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _showLogoutDialog,
                            borderRadius: BorderRadius.circular(26),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppStrings.menuLogout,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.logout_rounded,
                                  size: 18,
                                  color: isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626),
                                ),
                              ],
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
      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
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
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  // Helper Wadah Kartu Melengkung
  Widget _buildGroupCard({required List<Widget> children}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
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
    IconData? leadingIcon,
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
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leadingIcon != null) ...[
                    Icon(
                      leadingIcon,
                      size: 20,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 14),
                  ],
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (trailingText != null) ...[
                    Text(
                      trailingText,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                  Icon(
                    trailingIcon,
                    size: 20,
                    color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
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
