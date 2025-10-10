import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/register_request.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecase/register.dart';
import '../../../../core/errors/failures.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterCubit({required this.registerUseCase}) : super(RegisterInitial());

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

    final Either<Failure, User> result = await registerUseCase(request);

    result.fold(
      (failure) => emit(RegisterError(failure)),
      (user) => emit(RegisterSuccess(user)),
    );
  }

  void resetState() {
    emit(RegisterInitial());
  }
}