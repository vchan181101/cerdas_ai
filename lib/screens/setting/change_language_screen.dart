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

  // 3. Menyiapkan Dataset Bahasa Berdasarkan Benua (Sesuai Java activity_ubahbahasa)
  void _setupData() {
    _languageList.addAll([
      // Benua Amerika
      LanguageItem.header('BENUA AMERIKA'),
      LanguageItem.language('English (United States)', 'en-US'),
      LanguageItem.language('Español (América Latina)', 'es-419'),
      LanguageItem.language('Português (Brasil)', 'pt-BR'),
      LanguageItem.language('Français (Canada)', 'fr-CA'),

      // Benua Australia
      LanguageItem.header('BENUA AUSTRALIA'),
      LanguageItem.language('English (Australia)', 'en-AU'),
      LanguageItem.language('Māori (New Zealand)', 'mi'),

      // Benua Asia
      LanguageItem.header('BENUA ASIA'),
      LanguageItem.language('Indonesia', 'in'),
      LanguageItem.language('English (India)', 'en-IN'),
      LanguageItem.language('Bahasa Melayu (Malaysia)', 'ms'),
      LanguageItem.language('日本語 - Japanese', 'ja'),
      LanguageItem.language('한국어 - Korean', 'ko'),
      LanguageItem.language('中文 - Chinese', 'zh'),
      LanguageItem.language('العربية - Arabic', 'ar'),
      LanguageItem.language('हिन्दी - Hindi', 'hi'),
      LanguageItem.language('ไทย - Thai', 'th'),
      LanguageItem.language('Tiếng Việt - Vietnamese', 'vi'),

      // Benua Eropa
      LanguageItem.header('BENUA EROPA'),
      LanguageItem.language('English (United Kingdom)', 'en-GB'),
      LanguageItem.language('Español (España)', 'es-ES'),
      LanguageItem.language('Français (France)', 'fr-FR'),
      LanguageItem.language('Deutsch (Deutschland)', 'de-DE'),
      LanguageItem.language('Русский - Russian', 'ru'),
      LanguageItem.language('Italiano (Italia)', 'it'),
      LanguageItem.language('Nederlands (Nederland)', 'nl'),
      LanguageItem.language('Türkçe - Turkish', 'tr'),

      // Benua Afrika
      LanguageItem.header('BENUA AFRIKA'),
      LanguageItem.language('Kiswahili - Swahili', 'sw'),
      LanguageItem.language('Afrikaans', 'af'),
      LanguageItem.language('Hausa', 'ha'),
      LanguageItem.language('Amharic', 'am'),
      LanguageItem.language('isiZulu - Zulu', 'zu'),
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