import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/register_request.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> register(RegisterRequest request);
}