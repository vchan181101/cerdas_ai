import '../core/core.dart';
import '../data/app_database.dart';
import '../data/user_dao.dart';
import '../data/user_entity.dart';

/// Interface untuk manajemen data profil pengguna di penyimpanan lokal (SQLite).
abstract class IUserRepository {
  /// Mengambil daftar seluruh pengguna yang tersimpan.
  FutureEither<List<UserEntity>> getAllUsers();

  /// Mengambil data pengguna berdasarkan ID unik.
  FutureEither<UserEntity?> getUserById(int id);

  /// Menyimpan data pengguna baru.
  FutureEither<void> saveUser(UserEntity user);

  /// Memperbarui informasi profil pengguna yang sudah ada.
  FutureEither<void> updateUser(UserEntity user);

  /// Menghapus data pengguna secara permanen dari perangkat.
  FutureEither<void> deleteUser(int id);
}

class UserRepository implements IUserRepository {
  static final UserRepository _instance = UserRepository._internal();
  factory UserRepository() => _instance;
  UserRepository._internal();

  Future<UserDao> _getDao() async => await AppDatabase().getUserDao();

  @override
  FutureEither<List<UserEntity>> getAllUsers() async {
    try {
      final dao = await _getDao();
      final users = await dao.getAllUsers();
      return Functional.success(users);
    } catch (e) {
      LoggerUtil.error('Database Error: getAllUsers', e);
      return Functional.failure(CacheFailure(e.toString()));
    }
  }

  @override
  FutureEither<UserEntity?> getUserById(int id) async {
    try {
      final dao = await _getDao();
      final user = await dao.findById(id);
      return Functional.success(user);
    } catch (e) {
      LoggerUtil.error('Database Error: getUserById', e);
      return Functional.failure(CacheFailure(e.toString()));
    }
  }

  @override
  FutureEither<void> saveUser(UserEntity user) async {
    try {
      final dao = await _getDao();
      await dao.insert(user);
      return Functional.success(null);
    } catch (e) {
      LoggerUtil.error('Database Error: saveUser', e);
      return Functional.failure(CacheFailure(e.toString()));
    }
  }

  @override
  FutureEither<void> updateUser(UserEntity user) async {
    try {
      if (user.id == null) {
        return Functional.failure(const CacheFailure('ID tidak valid untuk pembaruan data'));
      }
      final dao = await _getDao();
      await dao.update(user);
      return Functional.success(null);
    } catch (e) {
      LoggerUtil.error('Database Error: updateUser', e);
      return Functional.failure(CacheFailure(e.toString()));
    }
  }

  @override
  FutureEither<void> deleteUser(int id) async {
    try {
      final dao = await _getDao();
      await dao.delete(id);
      return Functional.success(null);
    } catch (e) {
      LoggerUtil.error('Database Error: deleteUser', e);
      return Functional.failure(CacheFailure(e.toString()));
    }
  }

  /// Inisialisasi awal untuk pengujian sistem saat startup.
  Future<void> runExampleUsage() async {
    final result = await saveUser(
      UserEntity(name: 'Pengguna Cerdas', email: 'user.cerdas@gmail.com'),
    );
    
    result.fold(
      (failure) => LoggerUtil.error('Bootstrap Database Gagal', failure.message),
      (_) => LoggerUtil.info('Bootstrap Database Berhasil.'),
    );
  }
}
