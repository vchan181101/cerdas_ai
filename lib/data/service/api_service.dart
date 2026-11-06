import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Custom Exception agar penanganan error di layer UI / Controller / Provider lebih bersih
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic responseData;

  ApiException({
    required this.message,
    this.statusCode,
    this.responseData,
  });

  @override
  String toString() => message;
}

class ApiService {
  // Pattern Singleton
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late final Dio _dio;

  // Storage aman untuk Android & iOS
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static String get baseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'https://api.imperialroyals.com/api/v1';

  static const String _tokenKey = 'jwt_token';

  /// Callback global ketika token expired (401).
  /// Contoh penggunaan:
  /// ApiService.onUnauthorized = () { Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false); };
  static VoidCallback? onUnauthorized;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // 1. Interceptor Keamanan Token & Error 401
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final requiresToken = options.extra['requiresToken'] ?? true;

          if (requiresToken && !options.headers.containsKey('Authorization')) {
            final token = await getToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            await clearToken();
            onUnauthorized?.call();
          }
          return handler.next(error);
        },
      ),
    );

    // 2. Interceptor Logging hanya saat Debug Mode
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: false,
          error: true,
          logPrint: (obj) => debugPrint('[DIO] $obj'),
        ),
      );
    }
  }

  // ==========================================
  // HELPER MANAJEMEN TOKEN
  // ==========================================

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // ==========================================
  // HTTP METHODS DENGAN DUKUNGAN GENERIK <T>
  // ==========================================

  /// HTTP GET
  Future<Response<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool requiresToken = true,
  }) async {
    try {
      final opt = _prepareOptions(options, requiresToken);
      return await _dio.get<T>(
        endpoint,
        queryParameters: queryParameters,
        options: opt,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// HTTP POST
  Future<Response<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool requiresToken = true,
  }) async {
    try {
      final opt = _prepareOptions(options, requiresToken);
      return await _dio.post<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: opt,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// HTTP PUT
  Future<Response<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool requiresToken = true,
  }) async {
    try {
      final opt = _prepareOptions(options, requiresToken);
      return await _dio.put<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: opt,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// HTTP PATCH
  Future<Response<T>> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool requiresToken = true,
  }) async {
    try {
      final opt = _prepareOptions(options, requiresToken);
      return await _dio.patch<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: opt,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// HTTP DELETE
  Future<Response<T>> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool requiresToken = true,
  }) async {
    try {
      final opt = _prepareOptions(options, requiresToken);
      return await _dio.delete<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: opt,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ==========================================
  // PRIVATE HELPER METHODS
  // ==========================================

  Options _prepareOptions(Options? options, bool requiresToken) {
    final effectiveOptions = options ?? Options();
    effectiveOptions.extra = Map<String, dynamic>.from(effectiveOptions.extra ?? {});
    effectiveOptions.extra!['requiresToken'] = requiresToken;
    return effectiveOptions;
  }

  ApiException _handleDioError(DioException error) {
    String message;
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Koneksi ke server batas waktu habis (timeout). Silakan periksa jaringan Anda.';
        break;
      case DioExceptionType.badResponse:
        final status = error.response?.statusCode;
        final data = error.response?.data;
        if (data is Map && data.containsKey('message')) {
          message = data['message'].toString();
        } else if (status == 400) {
          message = 'Permintaan tidak valid (Bad Request).';
        } else if (status == 401) {
          message = 'Sesi Anda telah berakhir. Silakan login kembali.';
        } else if (status == 403) {
          message = 'Anda tidak memiliki hak akses ke resource ini.';
        } else if (status == 404) {
          message = 'Layanan atau data yang dicari tidak ditemukan.';
        } else if (status != null && status >= 500) {
          message = 'Terjadi kesalahan pada server. Coba beberapa saat lagi.';
        } else {
          message = 'Terjadi kesalahan respons server (${status ?? 'Unknown'}).';
        }
        break;
      case DioExceptionType.connectionError:
        message = 'Tidak ada koneksi internet. Pastikan perangkat Anda terhubung ke jaringan.';
        break;
      case DioExceptionType.cancel:
        message = 'Permintaan dibatalkan.';
        break;
      default:
        message = error.message ?? 'Terjadi kesalahan tidak terduga.';
        break;
    }

    return ApiException(
      message: message,
      statusCode: error.response?.statusCode,
      responseData: error.response?.data,
    );
  }
}
