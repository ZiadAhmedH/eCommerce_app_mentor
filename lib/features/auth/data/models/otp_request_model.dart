import '../../domain/entities/otp_request.dart';

class ResendOTPResponseModel {
  final String message;
  final bool success;

  const ResendOTPResponseModel({required this.message, this.success = true});

  // Convert to entity
  ResendOTPResponse toEntity() {
    return ResendOTPResponse(message: message, success: success);
  }

  // Create from entity
  factory ResendOTPResponseModel.fromEntity(ResendOTPResponse entity) {
    return ResendOTPResponseModel(
      message: entity.message,
      success: entity.success,
    );
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {'message': message, 'success': success};
  }

  // JSON deserialization - Handle both String and Map responses
  factory ResendOTPResponseModel.fromJson(dynamic json) {
    print('🔍 ResendOTPResponseModel - Parsing response: $json');
    print('🔍 Response type: ${json.runtimeType}');

    // If response is a String
    if (json is String) {
      print('✅ Response is String, using it as message');
      return ResendOTPResponseModel(
        message: json.isNotEmpty ? json : 'OTP resent successfully',
        success: true,
      );
    }

    // If response is a Map
    if (json is Map<String, dynamic>) {
      print('✅ Response is Map, extracting fields');
      return ResendOTPResponseModel(
        message: json['message'] as String? ?? 'OTP resent successfully',
        success: json['success'] as bool? ?? true,
      );
    }

    // Fallback for unexpected types
    print('⚠️ Unexpected response type, using default message');
    return const ResendOTPResponseModel(
      message: 'OTP resent successfully',
      success: true,
    );
  }
}

class ResendOTPRequestModel {
  final String email;

  const ResendOTPRequestModel({required this.email});

  ResendOTPRequest toEntity() {
    return ResendOTPRequest(email: email);
  }

  factory ResendOTPRequestModel.fromEntity(ResendOTPRequest entity) {
    return ResendOTPRequestModel(email: entity.email);
  }

  Map<String, dynamic> toJson() {
    return {'email': email};
  }

  factory ResendOTPRequestModel.fromJson(Map<String, dynamic> json) {
    return ResendOTPRequestModel(email: json['email'] as String);
  }
}
