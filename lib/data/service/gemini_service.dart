import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:cerdas_ai/core/app_constants.dart';
import '../models/gemini_tier.dart';

class GeminiService {
  // Mengambil API Key dari AppConstants (secara dinamis)
  static String get _apiKey => AppConstants.geminiApiKey;

  /// Mendapatkan instance GenerativeModel berdasarkan tier yang dipilih
  static GenerativeModel _getModel(GeminiTier tier) {
    return GenerativeModel(
      model: tier.id,
      apiKey: _apiKey,
    );
  }

  /// 1. Mengirim Request Teks (Prompt Text Saja)
  static Future<String> generateText(String prompt, {GeminiTier tier = GeminiTier.free}) async {
    try {
      if (_apiKey == 'MASUKKAN_API_KEY_GEMINI_ANDA_DI_SINI' || _apiKey.isEmpty) {
        return "⚠️ API Key Gemini belum diatur. Silakan periksa file 'lib/core/app_constants.dart' atau gunakan --dart-define=API_KEY=...";
      }

      final model = _getModel(tier);
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      if (response.text != null) {
        return response.text!;
      } else {
        return "Gagal mendapatkan respons dari AI.";
      }
    } catch (e) {
      return "Terjadi kesalahan: $e";
    }
  }

  /// 2. Mengirim Request Gambar + Teks (Multimodal)
  static Future<String> generateFromImage({
    required File imageFile,
    required String prompt,
    GeminiTier tier = GeminiTier.free,
    String mimeType = "image/jpeg",
  }) async {
    try {
      final model = _getModel(tier);
      final bytes = await imageFile.readAsBytes();
      
      final content = [
        Content.multi([
          TextPart(prompt),
          DataPart(mimeType, bytes),
        ])
      ];

      final response = await model.generateContent(content);

      if (response.text != null) {
        return response.text!;
      } else {
        return "Gagal memproses gambar.";
      }
    } catch (e) {
      return "Gagal memproses gambar: $e";
    }
  }
}
