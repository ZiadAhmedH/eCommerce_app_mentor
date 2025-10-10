part of 'register_cubit.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final User user;

  const RegisterSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class RegisterError extends RegisterState {
  final Failure failure; 

  const RegisterError(this.failure);

  @override
  List<Object> get props => [failure];
}
