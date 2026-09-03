import 'package:sqflite/sqflite.dart';
import 'user_entity.dart';

class UserDao {
  final Database _db;
  final String _tableName = 'users';

  UserDao(this._db);

  /// Menyimpan atau Mengganti data pengguna (Insert/Replace)
  Future<int> insert(UserEntity user) async {
    return await _db.insert(
      _tableName,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Memperbarui data pengguna berdasarkan ID
  Future<int> update(UserEntity user) async {
    return await _db.update(
      _tableName,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  /// Menghapus pengguna berdasarkan ID
  Future<int> delete(int id) async {
    return await _db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Mengambil satu data pengguna berdasarkan ID
  Future<UserEntity?> findById(int id) async {
    final List<Map<String, dynamic>> maps = await _db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return UserEntity.fromMap(maps.first);
  }

  /// Mengambil seluruh data pengguna dari tabel
  Future<List<UserEntity>> getAllUsers() async {
    final List<Map<String, dynamic>> maps = await _db.query(_tableName);
    return List.generate(maps.length, (i) => UserEntity.fromMap(maps[i]));
  }
}
