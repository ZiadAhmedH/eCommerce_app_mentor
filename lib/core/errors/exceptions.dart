class ServerException implements Exception {}

class CacheException implements Exception {}

class NetworkException implements Exception {}

class ValidationException implements Exception {
  final String message;
  const ValidationException(this.message);
}

class UnauthorizedException implements Exception {}

class NotFoundException implements Exception {}
