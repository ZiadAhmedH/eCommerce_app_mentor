import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/verify.dart';
part 'verify_email_response_model.g.dart';

@JsonSerializable()
class VerifyEmailResponseModel {
  @JsonKey(name: 'message')
  final String? responseMessage;

  const VerifyEmailResponseModel({this.responseMessage});

  factory VerifyEmailResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$VerifyEmailResponseModelFromJson(json);
    } catch (e) {
      print('❌ VerifyEmailResponseModel.fromJson - Error: $e');

      // Fallback manual parsing
      return VerifyEmailResponseModel(
        responseMessage:
            json['message']?.toString() ?? 'Email verified successfully',
      );
    }
  }

  Map<String, dynamic> toJson() => _$VerifyEmailResponseModelToJson(this);

  VerifyEmailResponse toEntity() {
    return VerifyEmailResponse(
      message: responseMessage ?? 'Email verified successfully',
    );
  }
}
