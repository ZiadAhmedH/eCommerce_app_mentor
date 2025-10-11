import 'package:equatable/equatable.dart';

class RegisterRequest extends Equatable {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  const RegisterRequest({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  @override
  List<Object> get props => [email, password, firstName, lastName];
}



class RegisterResponse extends Equatable {
  final String message;

  const RegisterResponse({
    required this.message,
  });

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'RegisterResponse(message: $message)';
}