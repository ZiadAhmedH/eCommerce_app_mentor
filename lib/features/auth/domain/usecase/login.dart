import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/login_request.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase implements UseCase<LoginResponse, LoginRequest> {
  final AuthRepository repository;

  const LoginUseCase(this.repository);

  @override
  Future<Either<Failure, LoginResponse>> call(LoginRequest params) async {
    return await repository.login(params);
  }
}