import 'package:json_annotation/json_annotation.dart';

part 'register_response_model.g.dart';

@JsonSerializable()
class RegisterResponseModel {
  final String? message;
  final String? token;
  final UserData? user;

  const RegisterResponseModel({
    this.message,
    this.token,
    this.user,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseModelToJson(this);
}

@JsonSerializable()
class UserData {
  final String id;
  final String email;
  final String firstName;
  final String lastName;

  const UserData({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}