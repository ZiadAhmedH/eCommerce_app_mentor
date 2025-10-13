import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/features/auth/domain/repositories/auth_repository.dart';

import '../../../../core/errors/failures.dart';
import '../entities/verify.dart';

class VerifyEmailUseCase {
  final AuthRepository repository;

  VerifyEmailUseCase(this.repository);

  Future<Either<Failure, VerifyEmailResponse>> call(VerifyEmailRequest request) {
    return repository.verifyEmail(request);
  }

}