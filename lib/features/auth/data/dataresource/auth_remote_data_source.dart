import 'package:dio/dio.dart';
import 'package:ecommerce_app/features/auth/data/models/login_request_model.dart';
import 'package:ecommerce_app/features/auth/data/models/login_response_model.dart';
import 'package:ecommerce_app/features/auth/data/models/verify_email_request_model.dart';
import 'package:ecommerce_app/features/auth/data/models/verify_email_response_model.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/mapper.dart';
import '../models/otp_request_model.dart';
import '../models/register_request_model.dart';
import '../models/register_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<RegisterResponseModel> register(RegisterRequestModel request);
  Future<LoginResponseModel> login(LoginRequestModel request);
  Future<VerifyEmailResponseModel> verifyEmail(VerifyEmailRequestModel request);
  Future<ResendOTPResponseModel> resendOTP(ResendOTPRequestModel request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  static const String baseUrl = 'https://accessories-eshop.runasp.net/api';

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<RegisterResponseModel> register(RegisterRequestModel request) async {
    try {
      print('📤 Registering user: ${request.email}');

      final response = await dio.post(
        '$baseUrl/auth/register',
        data: request.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print('✅ Registration successful');
      return RegisterResponseModel.fromJson(response.data);
    } catch (e) {
      print('❌ Registration failed: $e');
      final failure = FailureMapper.fromError(e);
      throw failure;
    }
  }

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    try {
      print('📤 Logging in user: ${request.email}');

      final response = await dio.post(
        '$baseUrl/auth/login',
        data: request.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print('✅ Login successful');
      return LoginResponseModel.fromJson(response.data);
    } catch (e) {
      print('❌ Login failed: $e');
      final failure = FailureMapper.fromError(e);
      throw failure;
    }
  }

  @override
  Future<VerifyEmailResponseModel> verifyEmail(
    VerifyEmailRequestModel request,
  ) async {
    try {
      print('📤 Verifying email: ${request.email}');
      print('🔐 OTP: ${request.otp}');

      final response = await dio.post(
        '$baseUrl/auth/verify-email',
        data: request.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print('✅ Email verification successful');
      return VerifyEmailResponseModel.fromJson(response.data);
    } catch (e) {
      print('❌ Email verification failed: $e');
      final failure = FailureMapper.fromError(e);
      throw failure;
    }
  }

  @override
  Future<ResendOTPResponseModel> resendOTP(
    ResendOTPRequestModel request,
  ) async {
    try {
      print('📤 Resending OTP to: ${request.email}');

      final response = await dio.post(
        '$baseUrl/auth/resend-otp',
        data: request.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print('✅ OTP resent - Status: ${response.statusCode}');
      print('📨 Response data: ${response.data}');
      print('📨 Response data type: ${response.data.runtimeType}');

      // Handle response - can be String or Map
      return ResendOTPResponseModel.fromJson(response.data);
    } catch (e) {
      print('❌ Resend OTP failed: $e');
      final failure = FailureMapper.fromError(e);
      throw failure;
    }
  }
}
