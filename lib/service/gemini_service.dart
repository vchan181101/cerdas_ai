import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cerdas_ai/core/app_constants.dart';

class GeminiService {
  // Mengambil API Key dari AppConstants
  static const String _apiKey = AppConstants.geminiApiKey;

  // Endpoint URL Gemini 1.5 Flash
  static const String _baseUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent";

  /// 1. Mengirim Request Teks (Prompt Text Saja)
  static Future<String> generateText(String prompt) async {
    final Uri url = Uri.parse("$_baseUrl?key=$_apiKey");

    // Header request
    final headers = {
      'Content-Type': 'application/json',
    };

    // Body request (sesuai format JSON Gemini)
    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": prompt}
          ]
        }
      ]
    });

    try {
      // Penambahan Timeout agar aplikasi tidak hang jika koneksi lambat
      final response = await http
          .post(url, headers: headers, body: body)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Mengambil respons teks dari kandidat pertama
        final String textResponse =
            data['candidates'][0]['content']['parts'][0]['text'];
        return textResponse;
      } else {
        // Parsing error agar lebih mudah dibaca user
        try {
          final errorData = jsonDecode(response.body);
          final String errorMessage = errorData['error']['message'];
          if (errorMessage.contains("API key not valid")) {
            return "⚠️ API Key Gemini tidak valid. Silakan periksa file 'lib/core/app_constants.dart' dan pastikan API Key sudah benar.";
          }
          return "Pesan dari AI: $errorMessage";
        } catch (_) {
          return "Gagal terhubung ke AI (${response.statusCode})";
        }
      }
    } on SocketException {
      return "Tidak ada koneksi internet. Silakan periksa jaringan Anda.";
    } on TimeoutException {
      return "Koneksi terputus (Timeout). Silakan coba lagi nanti.";
    } catch (e) {
      return "Terjadi kesalahan koneksi: $e";
    }
  }

  /// 2. Mengirim Request Gambar + Teks (Multimodal / Analisis Dokumen)
  static Future<String> generateFromImage({
    required File imageFile,
    required String prompt,
    String mimeType = "image/jpeg",
  }) async {
    final Uri url = Uri.parse("$_baseUrl?key=$_apiKey");

    final headers = {
      'Content-Type': 'application/json',
    };

    try {
      // Ubah gambar ke format Base64
      final bytes = await imageFile.readAsBytes();
      final String base64Image = base64Encode(bytes);

      // Body request dengan teks dan inlineData (Base64)
      final body = jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": prompt},
              {
                "inline_data": {
                  "mime_type": mimeType,
                  "data": base64Image,
                }
              }
            ]
          }
        ]
      });

      // Penambahan Timeout agar aplikasi tidak hang jika koneksi lambat
      final response = await http
          .post(url, headers: headers, body: body)
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String textResponse =
            data['candidates'][0]['content']['parts'][0]['text'];
        return textResponse;
      } else {
        // Parsing error agar lebih mudah dibaca user
        try {
          final errorData = jsonDecode(response.body);
          final String errorMessage = errorData['error']['message'];
          if (errorMessage.contains("API key not valid")) {
            return "⚠️ API Key Gemini tidak valid. Silakan periksa file 'lib/core/app_constants.dart' dan pastikan API Key sudah benar.";
          }
          return "Pesan dari AI: $errorMessage";
        } catch (_) {
          return "Gagal memproses gambar (${response.statusCode})";
        }
      }
    } on SocketException {
      return "Gagal memproses gambar: Tidak ada koneksi internet.";
    } on TimeoutException {
      return "Gagal memproses gambar: Waktu unggah habis (Timeout).";
    } catch (e) {
      return "Gagal memproses gambar: $e";
    }
  }
}
