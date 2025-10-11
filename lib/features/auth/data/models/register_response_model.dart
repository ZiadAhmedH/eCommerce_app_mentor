import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/register_request.dart';

part 'register_response_model.g.dart';

@JsonSerializable()
class RegisterResponseModel {
  final String? message;
 

  const RegisterResponseModel({
    this.message,
    
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseModelToJson(this);

  RegisterResponse toEntity() {
    return RegisterResponse(
      message: message ?? '',
    );
  }
}


