import 'package:equatable/equatable.dart';

 
class LoginRequest extends Equatable {
  final String email;
  final String password;

  const LoginRequest({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];

  @override
  String toString() => 'LoginRequest(email: $email, password: [HIDDEN])';
} 


class LoginResponse extends Equatable {
  final String token;
  final String refreshToken;
  final String message;

  const LoginResponse({
    required this.token,
    required this.refreshToken,
    required this.message,
  });

  @override
  List<Object?> get props => [token, refreshToken, message];

  @override
  String toString() => 'LoginResponse(message: $message, hasToken: ${token.isNotEmpty})';
}