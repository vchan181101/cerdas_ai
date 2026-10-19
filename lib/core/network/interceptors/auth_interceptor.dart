import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/core.dart';

/// Interceptor untuk menyuntikkan Token Bearer secara otomatis ke setiap request.
/// Membaca token dari penyimpanan lokal (SharedPreferences).
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.keyAuthToken);

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Setel Header standar untuk JSON
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Tangani skenario Token Kadaluwarsa (HTTP 401 Unauthorized)
    if (err.response?.statusCode == 401) {
      LoggerUtil.warning('Sesi kadaluwarsa (401). Memerlukan login ulang.');
      // Catatan: Di sini bisa ditambahkan logika navigasi otomatis ke /login
    }
    super.onError(err, handler);
  }
}
