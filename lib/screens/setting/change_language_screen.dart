import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../values/colors.dart';
import '../../values/strings.dart';
import '../../helpers/helpers.dart';
import '../../widgets/language_option_widget.dart';

/// Data Model untuk Item Bahasa dan Header Benua
class LanguageItem {
  final String name;
  final String? code;
  final bool isHeader;

  // Constructor untuk Bahasa
  LanguageItem.language(this.name, this.code) : isHeader = false;

  // Constructor untuk Header Benua
  LanguageItem.header(this.name)
      : code = null,
        isHeader = true;
}

class ChangeLanguageScreen extends StatefulWidget {
  const ChangeLanguageScreen({super.key});

  @override
  State<ChangeLanguageScreen> createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  String _currentLangCode = 'in';
  final List<LanguageItem> _languageList = [];

  @override
  void initState() {
    super.initState();
    _loadCurrentLanguage();
    _setupData();
  }

  // 1. Memuat Kode Bahasa Aktif dari SharedPreferences
  Future<void> _loadCurrentLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentLangCode = prefs.getString('APP_LANG_CODE') ?? 'in';
    });
  }

  // 2. Mengubah Bahasa dan Menyimpan Preferensi
  Future<void> _selectLanguage(String name, String code) async {
    // 1. Simpan bahasa baru ke SharedPreferences melalui LocaleHelper
    Locale newLocale = await LocaleHelper.setLocale(code);
    
    // Simpan nama bahasa deskriptif untuk ditampilkan di UI Setting
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('APP_LANG', name);

    // 2. Perbarui state bahasa global aplikasi agar UI langsung berubah
    appLocaleNotifier.value = newLocale;

    setState(() {
      _currentLangCode = code;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Bahasa diubah ke: $name')),
    );

    // Navigasi Kembali ke Setting
    Navigator.pop(context);
  }

  // 3. Menyiapkan Dataset Bahasa Sesuai Permintaan Terbaru
  void _setupData() {
    _languageList.addAll([
      LanguageItem.language('Indonesia', 'id'),
      LanguageItem.language('English', 'en'),
      LanguageItem.language('Italy', 'it'),
      LanguageItem.language('Turkey', 'tr'),
      LanguageItem.language('Español', 'es'),
      LanguageItem.language('Mandarin (Chinese)', 'zh'),
      LanguageItem.language('Korean', 'ko'),
      LanguageItem.language('Hindi', 'hi'),
      LanguageItem.language('Japanese', 'ja'),
      LanguageItem.language('Arabic', 'ar'),
      LanguageItem.language('Français', 'fr'),
      LanguageItem.language('Russian', 'ru'),
      LanguageItem.language('Thai', 'th'),
      LanguageItem.language('Portugal', 'pt'),
      LanguageItem.language('Vietnam', 'vi'),
      LanguageItem.language('Kamboja', 'km'),
      LanguageItem.language('Laos', 'lo'),
      
      LanguageItem.header('SCANDINAVIA'),
      LanguageItem.language('Dansk - Denmark', 'da'),
      LanguageItem.language('Norsk - Norway', 'no'),
      LanguageItem.language('Svenska - Sweden', 'sv'),
      LanguageItem.language('Suomi - Finlandia', 'fi'),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScreenColorHelper.getBackgroundColor(context),
      body: SafeArea(
        child: Column(
          children: [
            // Header / Top Bar
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_new_rounded, size: 24, color: ScreenColorHelper.getHeadingText(context)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppStrings.titleUbahBahasa,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ScreenColorHelper.getHeadingText(context),
                    ),
                  ),
                ],
              ),
            ),

            // RecyclerView Konversi (ListView Header + Item Bahasa)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 20.0),
                itemCount: _languageList.length,
                itemBuilder: (context, index) {
                  final item = _languageList[index];

                  if (item.isHeader) {
                    return _buildHeaderTile(item.name);
                  } else {
                    final isSelected = item.code == _currentLangCode;
                    return _buildLanguageTile(
                      name: item.name,
                      isSelected: isSelected,
                      onTap: () => _selectLanguage(item.name, item.code!),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Header Benua
  Widget _buildHeaderTile(String continentName) {
    return Container(
      width: double.infinity,
      color: ScreenColorHelper.getBackgroundColor(context),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Text(
        continentName,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: ScreenColorHelper.getBodyText(context).withValues(alpha: 0.5),
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  // Widget Item Row Bahasa dengan Indicator Checkmark
  Widget _buildLanguageTile({
    required String name,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 15,
                    color: ScreenColorHelper.getHeadingText(context),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: ScreenColorHelper.getPrimaryAction(context),
                    size: 22,
                  ),
              ],
            ),
          ),
        ),
        Divider(height: 1, thickness: 1, color: AppColors.inputBorder.withValues(alpha: 0.1)),
      ],
    );
  }
}