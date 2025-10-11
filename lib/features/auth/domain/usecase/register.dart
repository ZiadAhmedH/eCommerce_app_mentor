import 'package:dartz/dartz.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/errors/failures.dart';
import '../entities/register_request.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase implements UseCase<RegisterResponse, RegisterRequest> {
  final AuthRepository repository;

  RegisterUseCase({required this.repository});

  @override
  Future<Either<Failure, RegisterResponse>> call(RegisterRequest params) async {
    return await repository.register(params);
  }
}