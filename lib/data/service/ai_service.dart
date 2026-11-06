import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:cerdas_ai/core/app_constants.dart';
import 'package:cerdas_ai/data/models/gemini_tier.dart';

class AiService {
  static final AiService _instance = AiService._internal();
  factory AiService() => _instance;

  AiService._internal();

  String get _apiKey => AppConstants.geminiApiKey;

  GenerativeModel _getModel(GeminiTier tier) {
    return GenerativeModel(
      model: tier.id,
      apiKey: _apiKey,
    );
  }

  bool get isApiKeyValid {
    return _apiKey.isNotEmpty &&
        _apiKey != 'MASUKKAN_API_KEY_GEMINI_ANDA_DI_SINI';
  }

  /// 1. Mengirim Pertanyaan Teks dan Menerima Balasan Lengkap
  Future<String> generateText(
    String prompt, {
    GeminiTier tier = GeminiTier.free,
  }) async {
    try {
      if (!isApiKeyValid) {
        return "⚠️ API Key Gemini belum diatur. Silakan periksa file 'lib/core/app_constants.dart' atau gunakan environment variable.";
      }

      final model = _getModel(tier);
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      if (response.text != null && response.text!.isNotEmpty) {
        return response.text!;
      }
      return "Gagal mendapatkan respons dari asisten AI.";
    } catch (e) {
      return "Terjadi kesalahan saat memproses permintaan: $e";
    }
  }

  /// 2. Mengirim Pertanyaan Teks dan Menerima Balasan secara Streaming
  Stream<String> generateTextStream(
    String prompt, {
    GeminiTier tier = GeminiTier.free,
  }) async* {
    if (!isApiKeyValid) {
      yield "⚠️ API Key Gemini belum diatur.";
      return;
    }

    try {
      final model = _getModel(tier);
      final content = [Content.text(prompt)];
      final responseStream = model.generateContentStream(content);

      await for (final chunk in responseStream) {
        if (chunk.text != null) {
          yield chunk.text!;
        }
      }
    } catch (e) {
      yield "Terjadi kesalahan streaming: $e";
    }
  }

  /// 3. Pemrosesan Multimodal (Gambar + Teks Pertanyaan)
  Future<String> generateFromImage({
    required File imageFile,
    required String prompt,
    GeminiTier tier = GeminiTier.free,
    String mimeType = "image/jpeg",
  }) async {
    try {
      if (!isApiKeyValid) {
        return "⚠️ API Key Gemini belum diatur.";
      }

      final model = _getModel(tier);
      final bytes = await imageFile.readAsBytes();

      final content = [
        Content.multi([
          TextPart(prompt),
          DataPart(mimeType, bytes),
        ])
      ];

      final response = await model.generateContent(content);
      if (response.text != null && response.text!.isNotEmpty) {
        return response.text!;
      }
      return "Gagal memproses gambar.";
    } catch (e) {
      return "Gagal memproses gambar: $e";
    }
  }

  /// 4. Membuka Sesi Chat Multi-Turn Interaktif
  ChatSession startChatSession({
    List<Content>? history,
    GeminiTier tier = GeminiTier.free,
  }) {
    final model = _getModel(tier);
    return model.startChat(history: history);
  }
}
