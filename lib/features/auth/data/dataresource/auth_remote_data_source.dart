import 'package:dio/dio.dart';
import '../models/register_request_model.dart';
import '../models/register_response_model.dart';
import '../models/api_error_model.dart';

abstract class AuthRemoteDataSource {
  Future<RegisterResponseModel> register(RegisterRequestModel request);
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
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      return RegisterResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null) {
        final apiError = ApiErrorModel.fromJson(e.response!.data);
        throw ApiException(
          message: apiError.message,
          statusCode: apiError.statusCode,
          errors: apiError.errors,
        );
      } else {
        throw ApiException(
          message: _mapDioErrorToMessage(e),
          statusCode: e.response?.statusCode ?? 0,
        );
      }
    } catch (e) {
      throw ApiException(
        message: 'Unexpected error occurred: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  String _mapDioErrorToMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.sendTimeout:
        return 'Request timeout. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Server response timeout. Please try again.';
      case DioExceptionType.badResponse:
        return 'Server error occurred. Please try again later.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network.';
      default:
        return 'Network error occurred. Please try again.';
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;
  final Map<String, List<String>>? errors;

  ApiException({
    required this.message,
    required this.statusCode,
    this.errors,
  });

  String get formattedErrorMessage {
    if (errors == null || errors!.isEmpty) return message;
    
    final errorMessages = <String>[];
    errors!.forEach((field, messages) {
      errorMessages.addAll(messages.map((msg) => '• $msg'));
    });
    
    return errorMessages.join('\n');
  }

  List<String> getFieldErrors(String field) {
    return errors?[field] ?? [];
  }
}