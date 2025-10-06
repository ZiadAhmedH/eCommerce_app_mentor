abstract class Failure {
  const Failure([List properties = const <dynamic>[]]);
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class NetworkFailure extends Failure {}

class ValidationFailure extends Failure {
  final String message;

  const ValidationFailure(this.message);
}

class UnauthorizedFailure extends Failure {}

class NotFoundFailure extends Failure {}
