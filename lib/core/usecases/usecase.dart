import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:travelmateai/core/errors/failures.dart';

/// Contract for all domain use cases.
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Use case with no parameters.
abstract class NoParamsUseCase<T> {
  Future<Either<Failure, T>> call();
}

/// Marker for use cases that require no parameters.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
