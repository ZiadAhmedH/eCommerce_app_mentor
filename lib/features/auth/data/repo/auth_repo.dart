import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/faliure_calsses.dart';
import 'package:ecommerce_app/features/auth/data/dataresource/auth_remote_data_source.dart';
import 'package:ecommerce_app/features/auth/data/models/login_request_model.dart';
import 'package:ecommerce_app/features/auth/domain/entities/login_request.dart';
import 'package:flutter/material.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/mapper.dart';
import '../../domain/entities/register_request.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/register_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, RegisterResponse>> register(RegisterRequest request) async {
    try {
      final requestModel = RegisterRequestModel(
        email: request.email,
        password: request.password,
        firstName: request.firstName,
        lastName: request.lastName,
      );

      final response = await remoteDataSource.register(requestModel);
      debugPrint("success $response");
     
      return Right(response.toEntity());

      
    } catch (e) {
      final failure = FailureMapper.fromError(e);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, LoginResponse>> login(LoginRequest request) async{
    try {
      final requestModel = LoginRequestModel(
        email: request.email,
        password: request.password,
      );

      final response = await remoteDataSource.login(requestModel);
      debugPrint("success $response");
     
      return Right(response.toEntity());

      
    } catch (e) {
      final failure = FailureMapper.fromError(e);
      return Left(failure);
    }
  }
}
