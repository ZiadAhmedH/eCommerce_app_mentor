part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class RegisterLoading extends AuthState {}

class RegisterSuccess extends AuthState {
  final RegisterResponse response;

  const RegisterSuccess(this.response);

  @override
  List<Object> get props => [response];
}

class RegisterError extends AuthState {
  final Failure failure; 

  const RegisterError(this.failure);

  @override
  List<Object> get props => [failure];
}

class LoginLoading extends AuthState {}
class LoginSuccess extends AuthState {
  final LoginResponse response;

  const LoginSuccess(this.response);

  @override
  List<Object> get props => [response];
}
class LoginError extends AuthState {
  final Failure failure;

  const LoginError(this.failure);

  @override
  List<Object> get props => [failure];
}
class LogoutState extends AuthState {}



class VerifyEmailLoading extends AuthState {}
class VerifyEmailSuccess extends AuthState {
  final VerifyEmailResponse response;

  const VerifyEmailSuccess(this.response);

  @override
  List<Object> get props => [response];
}
class VerifyEmailError extends AuthState {
  final Failure failure;

  const VerifyEmailError(this.failure);

  @override
  List<Object> get props => [failure];
}