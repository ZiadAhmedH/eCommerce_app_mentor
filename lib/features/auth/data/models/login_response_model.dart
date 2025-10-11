import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/login_request.dart';

part 'login_response_model.g.dart';

@JsonSerializable()
class LoginResponseModel {
  final String accessToken;
  final String refreshToken;
  final String expiresAtUtc;

  const LoginResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAtUtc,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);

  LoginResponse toEntity() {
    return LoginResponse(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAtUtc: expiresAtUtc,
    );
  }
}
