import 'package:equatable/equatable.dart';

// Sesuaikan path import typedefs dengan struktur proyek Anda
import '../typedefs.dart';

/// Base class untuk UseCase yang membutuhkan parameter
abstract class UseCase<T, Params> {
  const UseCase();

  FutureEither<T> call(Params params);
}

/// Base class untuk UseCase yang TIDAK membutuhkan parameter
abstract class UseCaseWithoutParams<T> {
  const UseCaseWithoutParams();

  FutureEither<T> call();
}

/// Class penanda jika ingin tetap memakai [UseCase] baku dengan parameter kosong
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}