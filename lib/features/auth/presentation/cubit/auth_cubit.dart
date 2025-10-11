import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/login_request.dart';
import '../../domain/entities/register_request.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecase/login.dart';
import '../../domain/usecase/register.dart';
import '../../../../core/errors/failures.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final RegisterUseCase registerUseCase;
  final LoginUseCase loginUseCase;

  AuthCubit({required this.registerUseCase , required this.loginUseCase}) : super(AuthInitial());

  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    emit(RegisterLoading());

    final request = RegisterRequest(
      email: email.trim(),
      password: password,
      firstName: firstName.trim(),
      lastName: lastName.trim(),
    );

    final Either<Failure, RegisterResponse> result = await registerUseCase(request);

    result.fold(
      (failure) => emit(RegisterError(failure)),
      (user) => emit(RegisterSuccess(user)),
    );
  }


  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());

    final request = LoginRequest(
      email: email.trim(),
      password: password,
    );

    final Either<Failure, LoginResponse> result = await loginUseCase(request);

    result.fold(
      (failure) => emit(LoginError(failure)),
      (response) => emit(LoginSuccess(response)),
    );
  }

  void resetState() {
    emit(AuthInitial());
  }
}