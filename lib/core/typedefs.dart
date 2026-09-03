import 'package:dartz/dartz.dart';
import 'failures.dart';

/// Mempermudah penulisan Map yang sering digunakan untuk JSON/API
typedef DataMap = Map<String, dynamic>;

/// Mempermudah penulisan Return Type asinkron yang bisa menghasilkan Error (Left) atau Sukses (Right)
typedef FutureEither<T> = Future<Either<Failure, T>>;

/// Digunakan untuk operasi yang mungkin mengembalikan data kosong secara aman (Optional)
typedef FutureEitherOption<T> = Future<Either<Failure, Option<T>>>;

/// Digunakan untuk operasi asinkron yang tidak mengembalikan data, hanya status Sukses/Gagal
typedef FutureVoid = FutureEither<void>;

/// Digunakan untuk operasi asinkron yang mengembalikan list data
typedef FutureEitherList<T> = FutureEither<List<T>>;
