import '../errors/failures.dart';

class Result<T> {
  final T? data;
  final Failure? failure;
  final bool isSuccess;

  const Result.success(this.data) : failure = null, isSuccess = true;

  const Result.failure(this.failure) : data = null, isSuccess = false;
}

abstract class UseCase<Type, Params> {
  Future<Result<Type>> call(Params params);
}

class NoParams {}

abstract class UseCaseSync<Type, Params> {
  Result<Type> call(Params params);
}
