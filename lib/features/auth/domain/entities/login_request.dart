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
  final String accessToken;
  final String expiresAtUtc;
  final String refreshToken;

  const LoginResponse({
    required this.accessToken,
    required this.expiresAtUtc,
    required this.refreshToken,
  });

  @override
  List<Object?> get props => [accessToken, expiresAtUtc, refreshToken];

  @override
  String toString() => 'LoginResponse(accessToken: $accessToken,})';
}