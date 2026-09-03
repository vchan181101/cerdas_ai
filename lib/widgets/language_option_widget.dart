import 'package:flutter/material.dart';
import '../helpers/locale_helper.dart';

// Global notifier untuk bahasa aplikasi (Biasanya diletakkan di main.dart atau state management)
final ValueNotifier<Locale> appLocaleNotifier = ValueNotifier(const Locale('id', 'ID'));

class LanguageOptionWidget extends StatelessWidget {
  final String languageName;
  final String languageCode; // Misal: 'in', 'en-US', 'ja'

  const LanguageOptionWidget({
    super.key,
    required this.languageName,
    required this.languageCode,
  });

  void _changeLanguage(BuildContext context) async {
    // 1. Simpan bahasa baru ke SharedPreferences melalui LocaleHelper
    Locale newLocale = await LocaleHelper.setLocale(languageCode);

    // 2. Perbarui state bahasa global aplikasi
    appLocaleNotifier.value = newLocale;

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bahasa diubah ke: $languageName')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(languageName),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _changeLanguage(context),
    );
  }
}
