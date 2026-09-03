/// Helper Skema Database (Konversi dari database_schema.xml atau SQL Manifest)
/// Mendefinisikan struktur tabel, relasi, dan versi database secara terpusat.
class DatabaseSchemaHelper {
  static const String dbName = 'cerdas_ai_vault.db';
  static const int dbVersion = 2; // Versi migrasi terbaru

  // --- Tabel Pengguna ---
  static const String tableUser = 'users';
  static const String colUserId = 'id';
  static const String colUserName = 'full_name';
  static const String colUserEmail = 'email';

  // --- Tabel Aktivitas AI ---
  static const String tableActivity = 'ai_history';
  static const String colActivityId = 'id';
  static const String colQuery = 'prompt';
  static const String colResponse = 'answer';
  static const String colTimestamp = 'created_at';

  /// Query SQL untuk pembuatan tabel awal (Modern SQL Syntax)
  static String get createUserTableQuery => '''
    CREATE TABLE IF NOT EXISTS \$tableUser (
      \$colUserId INTEGER PRIMARY KEY AUTOINCREMENT,
      \$colUserName TEXT NOT NULL,
      \$colUserEmail TEXT UNIQUE NOT NULL
    )
  ''';
}
