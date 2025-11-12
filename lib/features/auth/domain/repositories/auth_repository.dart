import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/login_request.dart';
import '../entities/otp_request.dart';
import '../entities/register_request.dart';
import '../entities/verify.dart';

abstract class AuthRepository {
  Future<Either<Failure, RegisterResponse>> register(RegisterRequest request);
  Future<Either<Failure, LoginResponse>> login(LoginRequest request);
  Future<Either<Failure, VerifyEmailResponse>> verifyEmail(
    VerifyEmailRequest request,
  );
  Future<Either<Failure, ResendOTPResponse>> resendOTP( ResendOTPRequest request,);
}
