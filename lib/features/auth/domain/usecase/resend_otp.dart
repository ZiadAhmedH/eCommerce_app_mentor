import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/otp_request.dart';
import '../repositories/auth_repository.dart';

class ResendOTPUseCase {
  final AuthRepository repository;

  ResendOTPUseCase(this.repository);

  Future<Either<Failure, ResendOTPResponse>> call(
    ResendOTPRequest request,
  ) async {
    return await repository.resendOTP(request);
  }
}
