import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/register_request.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../dataresource/auth_remote_data_source.dart';
import '../models/register_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> register(RegisterRequest request) async {
    try {
      final requestModel = RegisterRequestModel(
        email: request.email,
        password: request.password,
        firstName: request.firstName,
        lastName: request.lastName,
      );

      final response = await remoteDataSource.register(requestModel);
      
      if (response.user != null) {
        final user = User(
          id: response.user!.id,
          email: response.user!.email,
          firstName: response.user!.firstName,
          lastName: response.user!.lastName,
        );
        return Right(user);
      } else {
        return Left(ServerFailure('Registration successful but user data not returned'));
      }
    } on ApiException catch (e) {
      return Left(ServerFailure(e.formattedErrorMessage));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }
}