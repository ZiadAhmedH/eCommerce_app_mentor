import 'package:dio/dio.dart';
import 'package:ecommerce_app/features/auth/data/models/login_request_model.dart';
import 'package:ecommerce_app/features/auth/data/models/login_response_model.dart';
import 'package:ecommerce_app/features/auth/data/models/verify_email_request_model.dart';
import 'package:ecommerce_app/features/auth/data/models/verify_email_response_model.dart';
import 'package:ecommerce_app/features/auth/domain/entities/verify.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/mapper.dart';
import '../models/register_request_model.dart';
import '../models/register_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<RegisterResponseModel> register(RegisterRequestModel request);
  Future<LoginResponseModel> login(LoginRequestModel request);
  Future<VerifyEmailResponseModel> verifyEmail(VerifyEmailRequestModel request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  static const String baseUrl = 'https://accessories-eshop.runasp.net/api';

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<RegisterResponseModel> register(RegisterRequestModel request) async {
    try {
      final response = await dio.post(
        '$baseUrl/auth/register',
        data: request.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      return RegisterResponseModel.fromJson(response.data);
    } catch (e) {
      final failure = FailureMapper.fromError(e);
      throw failure;
    }
  }

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await dio.post(
        '$baseUrl/auth/login',
        data: request.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      return LoginResponseModel.fromJson(response.data);
    } catch (e) {
      final failure = FailureMapper.fromError(e);
      throw failure;
    }
  }

  @override
  Future<VerifyEmailResponseModel> verifyEmail(
    VerifyEmailRequestModel request,
  ) async {
    try {
      final response = await dio.post(
        '$baseUrl/auth/verify-email',
        data: request.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      return VerifyEmailResponseModel.fromJson(response.data);
    } catch (e) {
      final failure = FailureMapper.fromError(e);
      throw failure;
    }
  }
}
