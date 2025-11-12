import 'package:equatable/equatable.dart';

class ResendOTPRequest extends Equatable {
  final String email;

  const ResendOTPRequest({required this.email});

  Map<String, dynamic> toJson() {
    return {'email': email};
  }

  @override
  List<Object?> get props => [email];
}

class ResendOTPResponse extends Equatable {
  final String message;
  final bool success;

  const ResendOTPResponse({required this.message, this.success = true});

  factory ResendOTPResponse.fromJson(Map<String, dynamic> json) {
    return ResendOTPResponse(
      message: json['message'] ?? 'OTP resent successfully',
      success: json['success'] ?? true,
    );
  }

  @override
  List<Object?> get props => [message, success];
}
