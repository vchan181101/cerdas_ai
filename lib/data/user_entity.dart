class UserEntity {
  final int? id;
  final String name;
  final String email;

  UserEntity({
    this.id,
    required this.name,
    required this.email,
  });

  // Konversi dari Map SQLite ke Objek UserEntity
  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      id: map['id'] as int?,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
    );
  }

  // Konversi dari Objek UserEntity ke Map SQLite
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'email': email,
    };
  }
}