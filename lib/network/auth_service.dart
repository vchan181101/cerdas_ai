import 'dio_client.dart';
import 'api_endpoints.dart';

/// Service untuk menangani logika autentikasi tingkat rendah.
/// Sekarang menggunakan DioClient untuk performa dan keamanan yang lebih baik.
class AuthService {
  final DioClient _dioClient = DioClient();

  /// Fungsi untuk Login User
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _dioClient.post(
      ApiEndpoints.login,
      data: {
        "email": email,
        "password": password,
      },
    );

    return response.data as Map<String, dynamic>;
  }

  /// Fungsi untuk mendapatkan Profil User.
  /// Catatan: Token ditangani secara otomatis oleh AuthInterceptor.
  Future<Map<String, dynamic>> getUserProfile() async {
    final response = await _dioClient.get(ApiEndpoints.profile);
    return response.data as Map<String, dynamic>;
  }
}
