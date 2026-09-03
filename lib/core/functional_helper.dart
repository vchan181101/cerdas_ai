import 'package:dartz/dartz.dart';
import 'failures.dart';

/// Extension untuk memudahkan manipulasi [Either] di seluruh proyek Cerdas AI.
extension EitherExtension<L, R> on Either<L, R> {
  /// Mendapatkan nilai Right jika ada, jika tidak mengembalikan null.
  R? get getRight => fold((_) => null, (r) => r);

  /// Mendapatkan nilai Left jika ada, jika tidak mengembalikan null.
  L? get getLeft => fold((l) => l, (_) => null);

  /// Mengecek apakah nilainya adalah Right.
  bool get isRightSide => isRight();

  /// Mengecek apakah nilainya adalah Left.
  bool get isLeftSide => isLeft();
}

/// Helper untuk membuat [Either] secara lebih deskriptif.
class Functional {
  /// Membuat instance [Right] (Berhasil).
  static Either<Failure, T> success<T>(T value) => Right(value);

  /// Membuat instance [Left] (Gagal).
  static Either<Failure, T> failure<T>(Failure failure) => Left(failure);

  /// Membuat instance [None] untuk Option.
  static Option<T> none<T>() => None();

  /// Membuat instance [Some] untuk Option.
  static Option<T> some<T>(T value) => Some(value);
}
