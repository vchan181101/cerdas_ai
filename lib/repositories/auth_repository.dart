import '../core/core.dart';
import '../network/network.dart';

/// Interface untuk manajemen autentikasi pengguna.
abstract class IAuthRepository {
  /// Melakukan login menggunakan kredensial email dan password.
  FutureEither<DataMap> login(String email, String password);

  /// Mendaftarkan akun pengguna baru.
  FutureEither<void> register(DataMap userData);

  /// Keluar dari sesi aplikasi saat ini.
  FutureEither<void> logout();
}

class AuthRepository implements IAuthRepository {
  final DioClient _dioClient = DioClient();

  @override
  FutureEither<DataMap> login(String email, String password) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return Functional.success(response.data as DataMap);
      } else {
        return Functional.failure(ServerFailure(response.statusMessage ?? 'Gagal Login'));
      }
    } on DioException catch (e) {
      LoggerUtil.error('Jaringan Error saat Login', e.message);
      return Functional.failure(ServerFailure(e.message ?? 'Terjadi kesalahan jaringan'));
    } catch (e) {
      LoggerUtil.error('Fatal Error saat Login', e);
      return Functional.failure(ServerFailure(e.toString()));
    }
  }

  @override
  FutureEither<void> register(DataMap userData) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.register,
        data: userData,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Functional.success(null);
      } else {
        return Functional.failure(ServerFailure(response.statusMessage ?? 'Gagal Registrasi'));
      }
    } on DioException catch (e) {
      LoggerUtil.error('Jaringan Error saat Registrasi', e.message);
      return Functional.failure(ServerFailure(e.message ?? 'Terjadi kesalahan jaringan'));
    } catch (e) {
      LoggerUtil.error('Fatal Error saat Registrasi', e);
      return Functional.failure(ServerFailure(e.toString()));
    }
  }

  @override
  FutureEither<void> logout() async {
    try {
      // Implementasi logout lokal dan server
      return Functional.success(null);
    } catch (e) {
      LoggerUtil.error('Gagal Logout', e);
      return Functional.failure(CacheFailure(e.toString()));
    }
  }
}
