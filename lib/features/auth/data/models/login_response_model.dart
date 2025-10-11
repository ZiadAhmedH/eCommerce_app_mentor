import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/login_request.dart';

part 'login_response_model.g.dart';

@JsonSerializable()
class LoginResponseModel {
  final String token;
  final String refreshToken;
  final String message;

  const LoginResponseModel({
    required this.token,
    required this.refreshToken,
    required this.message,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);

  LoginResponse toEntity() {
    return LoginResponse(
      token: token,
      refreshToken: refreshToken,
      message: message,
    );
  }
}
