import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/features/auth/domain/entities/login_request.dart';
import 'package:ecommerce_app/features/auth/domain/entities/verify.dart';
import '../../../../core/errors/failures.dart';
import '../entities/register_request.dart';

abstract class AuthRepository {
  Future<Either<Failure, RegisterResponse>> register(RegisterRequest request);
  Future<Either<Failure, LoginResponse>> login(LoginRequest request);

  Future<Either<Failure, VerifyEmailResponse>> verifyEmail( VerifyEmailRequest request);

  

}