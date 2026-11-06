import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'api_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  final ApiService _apiService = ApiService();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  AuthService._internal();

  /// 1. Login dengan Email & Password
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiService.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
      requiresToken: false,
    );

    final data = response.data;
    if (data is Map<String, dynamic>) {
      final token = data['token'] ?? data['access_token'] ?? data['data']?['token'];
      if (token != null && token is String) {
        await _apiService.saveToken(token);
      }
      return data;
    }
    return {'success': true, 'data': data};
  }

  /// 2. Pendaftaran Akun Baru (Register)
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    final response = await _apiService.post(
      '/auth/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        if (phone != null) 'phone': phone,
      },
      requiresToken: false,
    );

    final data = response.data;
    if (data is Map<String, dynamic>) {
      final token = data['token'] ?? data['access_token'] ?? data['data']?['token'];
      if (token != null && token is String) {
        await _apiService.saveToken(token);
      }
      return data;
    }
    return {'success': true, 'data': data};
  }

  /// 3. Login Menggunakan Akun Google
  Future<Map<String, dynamic>> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw ApiException(message: 'Login Google dibatalkan oleh pengguna.');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      // Kirim idToken/accessToken ke backend server Anda
      final response = await _apiService.post(
        '/auth/google',
        data: {
          'id_token': idToken,
          'access_token': accessToken,
          'email': googleUser.email,
          'display_name': googleUser.displayName,
          'photo_url': googleUser.photoUrl,
        },
        requiresToken: false,
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final token = data['token'] ?? data['access_token'] ?? data['data']?['token'];
        if (token != null && token is String) {
          await _apiService.saveToken(token);
        }
        return data;
      }
      return {'success': true, 'data': data};
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Gagal login dengan Google: $e');
    }
  }

  /// 4. Login Menggunakan Akun Apple (iOS / macOS / Web)
  Future<Map<String, dynamic>> loginWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final response = await _apiService.post(
        '/auth/apple',
        data: {
          'identity_token': credential.identityToken,
          'authorization_code': credential.authorizationCode,
          'given_name': credential.givenName,
          'family_name': credential.familyName,
          'email': credential.email,
        },
        requiresToken: false,
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final token = data['token'] ?? data['access_token'] ?? data['data']?['token'];
        if (token != null && token is String) {
          await _apiService.saveToken(token);
        }
        return data;
      }
      return {'success': true, 'data': data};
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Gagal login dengan Apple: $e');
    }
  }

  /// 5. Mendapatkan Data Profil Pengguna Saat Ini
  Future<Map<String, dynamic>> getProfile() async {
    final response = await _apiService.get('/auth/profile');
    if (response.data is Map<String, dynamic>) {
      return response.data as Map<String, dynamic>;
    }
    return {'data': response.data};
  }

  /// 6. Lupa Kata Sandi (Kirim OTP / Link Reset)
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final response = await _apiService.post(
      '/auth/forgot-password',
      data: {'email': email},
      requiresToken: false,
    );
    return response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : {'success': true};
  }

  /// 7. Verifikasi Kode OTP
  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final response = await _apiService.post(
      '/auth/verify-otp',
      data: {
        'email': email,
        'otp': otp,
      },
      requiresToken: false,
    );
    return response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : {'success': true};
  }

  /// 8. Reset Kata Sandi Baru
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    final response = await _apiService.post(
      '/auth/reset-password',
      data: {
        'email': email,
        'otp': otp,
        'new_password': newPassword,
      },
      requiresToken: false,
    );
    return response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : {'success': true};
  }

  /// 9. Logout
  Future<void> logout() async {
    try {
      await _apiService.post('/auth/logout');
    } catch (e) {
      debugPrint('[AuthService] Peringatan saat logout dari server: $e');
    } finally {
      await _apiService.clearToken();
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
    }
  }

  /// 10. Periksa Apakah Pengguna Sedang Login
  Future<bool> isLoggedIn() async {
    return await _apiService.hasToken();
  }

  /// 11. Dapatkan Token Saat Ini
  Future<String?> getToken() async {
    return await _apiService.getToken();
  }
}
