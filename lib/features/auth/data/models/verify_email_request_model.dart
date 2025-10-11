import 'package:ecommerce_app/features/auth/domain/entities/verify.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verify_email_request_model.g.dart';

@JsonSerializable()
class VerifyEmailRequestModel {
  final String email;
  final String otp;

  const VerifyEmailRequestModel({required this.email, required this.otp});

  factory VerifyEmailRequestModel.fromJson(Map<String, dynamic> json) =>
      _$VerifyEmailRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyEmailRequestModelToJson(this);

  factory VerifyEmailRequestModel.fromEntity(VerifyEmailRequest entity) {
    return VerifyEmailRequestModel(email: entity.email, otp: entity.otp);
  }

  VerifyEmailRequest toEntity() {
    return VerifyEmailRequest(email: email, otp: otp);
  }
}
