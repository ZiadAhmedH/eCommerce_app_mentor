import 'package:ecommerce_app/features/auth/domain/entities/register_request.dart';
import 'package:json_annotation/json_annotation.dart';

part 'register_request_model.g.dart';

@JsonSerializable()
class RegisterRequestModel {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  const RegisterRequestModel({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestModelToJson(this);


  RegisterRequest toEntity() {
    return RegisterRequest(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );
  }
}