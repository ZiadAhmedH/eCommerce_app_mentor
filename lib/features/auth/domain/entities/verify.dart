import 'package:equatable/equatable.dart';

class VerifyEmailRequest extends Equatable {
  final String email;
  final String otp;

  const VerifyEmailRequest({required this.email, required this.otp});

  @override
  List<Object?> get props => [email, otp];

  @override
  String toString() => 'VerifyEmailRequest(email: $email, otp: $otp)';

  bool get isValid => email.isNotEmpty && otp.isNotEmpty;

  bool get isOtpValid => otp.length == 4 && RegExp(r'^\d{4}$').hasMatch(otp);
}






class VerifyEmailResponse extends Equatable {
  final String message;

  const VerifyEmailResponse({
    required this.message,
  });

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'VerifyEmailResponse(message: $message)';

  bool get isSuccess => message.isNotEmpty;
}