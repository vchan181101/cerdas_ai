import 'package:flutter/material.dart';
import 'package:cerdas_ai/data/service/api_service.dart';
import 'package:cerdas_ai/data/service/auth_service.dart';

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  loading,
  error,
}

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AuthStatus _status = AuthStatus.initial;
  Map<String, dynamic>? _user;
  String? _errorMessage;

  AuthStatus get status => _status;
  Map<String, dynamic>? get user => _user;
  String? get errorMessage => _errorMessage;

  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _status == AuthStatus.loading;
  bool get hasError => _errorMessage != null && _errorMessage!.isNotEmpty;

  AuthProvider() {
    checkAuthStatus();
  }

  /// 1. Cek Status Login Saat Aplikasi Dimulai
  Future<void> checkAuthStatus() async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      final isLoggedIn = await _authService.isLoggedIn();
      if (isLoggedIn) {
        try {
          _user = await _authService.getProfile();
          _status = AuthStatus.authenticated;
        } catch (_) {
          // Jika gagal ambil profile tapi token masih ada
          _status = AuthStatus.authenticated;
        }
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  /// 2. Login dengan Email & Password
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authService.login(email: email, password: password);
      _user = result['user'] ?? result['data'];
      _status = AuthStatus.authenticated;
      _setLoading(false);
      return true;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Terjadi kesalahan saat masuk: $e');
      return false;
    }
  }

  /// 3. Pendaftaran Akun (Register)
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authService.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );
      _user = result['user'] ?? result['data'];
      _status = AuthStatus.authenticated;
      _setLoading(false);
      return true;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Terjadi kesalahan saat mendaftar: $e');
      return false;
    }
  }

  /// 4. Login Menggunakan Akun Google
  Future<bool> loginWithGoogle() async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authService.loginWithGoogle();
      _user = result['user'] ?? result['data'];
      _status = AuthStatus.authenticated;
      _setLoading(false);
      return true;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Gagal masuk dengan Google: $e');
      return false;
    }
  }

  /// 5. Login Menggunakan Akun Apple
  Future<bool> loginWithApple() async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authService.loginWithApple();
      _user = result['user'] ?? result['data'];
      _status = AuthStatus.authenticated;
      _setLoading(false);
      return true;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Gagal masuk dengan Apple: $e');
      return false;
    }
  }

  /// 6. Lupa Kata Sandi
  Future<bool> forgotPassword(String email) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.forgotPassword(email);
      _setLoading(false);
      return true;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Gagal memproses permintaan reset: $e');
      return false;
    }
  }

  /// 7. Verifikasi OTP
  Future<bool> verifyOtp(String email, String otp) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.verifyOtp(email: email, otp: otp);
      _setLoading(false);
      return true;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Kode OTP tidak valid atau kedaluwarsa.');
      return false;
    }
  }

  /// 8. Reset Kata Sandi Baru
  Future<bool> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.resetPassword(
        email: email,
        otp: otp,
        newPassword: newPassword,
      );
      _setLoading(false);
      return true;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Gagal mengatur kata sandi baru: $e');
      return false;
    }
  }

  /// 9. Logout
  Future<void> logout() async {
    _setLoading(true);
    await _authService.logout();
    _user = null;
    _status = AuthStatus.unauthenticated;
    _setLoading(false);
  }

  /// 10. Perbarui Data Profil
  Future<void> refreshProfile() async {
    try {
      _user = await _authService.getProfile();
      notifyListeners();
    } catch (e) {
      debugPrint('[AuthProvider] Gagal memuat profil: $e');
    }
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }

  // --- Private Helpers ---
  void _setLoading(bool value) {
    if (value) {
      _status = AuthStatus.loading;
    }
    notifyListeners();
  }

  void _setError(String message) {
    _status = AuthStatus.error;
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}
