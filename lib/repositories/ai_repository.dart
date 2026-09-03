import '../core/core.dart';
import '../network/network.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

/// Interface untuk berinteraksi dengan layanan Kecerdasan Buatan (AI).
abstract class IAIRepository {
  /// Mengirimkan perintah teks ke asisten AI.
  FutureEither<String> askAi(String prompt, {String? context});

  /// Mengunggah dan menganalisis berkas dokumen atau gambar.
  FutureEither<DataMap> analyzeDocument(String filePath);
}

// Contoh pemanggilan ke Gemini API:
final String apiKey = AppConstants.geminiApiKey;

class AIRepository implements IAIRepository {
  final DioClient _dioClient = DioClient();

  @override
  FutureEither<String> askAi(String prompt, {String? context}) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.chat,
        data: {
          'prompt': prompt,
          'context': context,
        },
      );

      if (response.statusCode == 200) {
        return Functional.success(response.data['answer'] ?? '');
      } else {
        return Functional.failure(ServerFailure(response.statusMessage ?? 'Gagal memproses query AI'));
      }
    } on DioException catch (e) {
      LoggerUtil.error('Jaringan Error di askAi', e.message);
      return Functional.failure(ServerFailure(e.message ?? 'Terjadi kesalahan jaringan'));
    } catch (e) {
      LoggerUtil.error('Fatal Error di askAi', e);
      return Functional.failure(ServerFailure(e.toString()));
    }
  }

  @override
  FutureEither<DataMap> analyzeDocument(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });

      final response = await _dioClient.post(
        ApiEndpoints.analyzeDocument,
        data: formData,
      );

      if (response.statusCode == 200) {
        return Functional.success(response.data as DataMap);
      } else {
        return Functional.failure(ServerFailure(response.statusMessage ?? 'Gagal menganalisis dokumen'));
      }
    } on DioException catch (e) {
      LoggerUtil.error('Jaringan Error di analyzeDocument', e.message);
      return Functional.failure(ServerFailure(e.message ?? 'Terjadi kesalahan jaringan'));
    } catch (e) {
      LoggerUtil.error('Fatal Error di analyzeDocument', e);
      return Functional.failure(ServerFailure(e.toString()));
    }
  }
}

class GeminiService {
  late final GenerativeModel _model;
  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: AppConstants.geminiApiKey,
    );
  }
  Future<String> kirimPertanyaan(String prompt) async {
    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);
    return response.text ?? 'Tidak ada respon dari Gemini';
  }
}
