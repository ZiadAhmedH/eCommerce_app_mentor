import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/mapper.dart';
import '../models/register_request_model.dart';
import '../models/register_response_model.dart';

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
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      return RegisterResponseModel.fromJson(response.data);
    } catch (e) {
      final failure = FailureMapper.fromError(e);
      throw failure; 
    }
  }
}
