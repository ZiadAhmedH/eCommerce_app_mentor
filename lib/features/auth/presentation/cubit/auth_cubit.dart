import 'package:ecommerce_app/features/auth/domain/entities/otp_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/login_request.dart';
import '../../domain/entities/register_request.dart';
import '../../domain/entities/verify.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/usecase/login.dart';
import '../../domain/usecase/register.dart';
import '../../domain/usecase/resend_otp.dart';
import '../../domain/usecase/verifiy_email.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final RegisterUseCase registerUseCase;
  final LoginUseCase loginUseCase;
  final VerifyEmailUseCase verifyEmailUseCase;
  final ResendOTPUseCase resendOTPUseCase;

  AuthCubit({
    required this.registerUseCase,
    required this.loginUseCase,
    required this.verifyEmailUseCase,
    required this.resendOTPUseCase,
  }) : super(AuthInitial());

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

    final Either<Failure, RegisterResponse> result = await registerUseCase(
      request,
    );

    result.fold(
      (failure) => emit(RegisterError(failure)),
      (response) => emit(RegisterSuccess(response)),
    );
  }

  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());

    final request = LoginRequest(email: email.trim(), password: password);

    final Either<Failure, LoginResponse> result = await loginUseCase(request);

    result.fold(
      (failure) => emit(LoginError(failure)),
      (response) => emit(LoginSuccess(response)),
    );
  }

  Future<void> verifyEmail({required String email, required String otp}) async {
    emit(VerifyEmailLoading());

    final request = VerifyEmailRequest(email: email.trim(), otp: otp.trim());

    print('📧 Verifying email: $email');
    print('🔐 OTP entered: $otp');
    print('📏 OTP length: ${otp.length}');
    print('✂️  Trimmed OTP: "${otp.trim()}"');

    final Either<Failure, VerifyEmailResponse> result =
        await verifyEmailUseCase(request);

    result.fold(
      (failure) {
        print('❌ Verification failed: ${failure.toString()}');
        emit(VerifyEmailError(failure));
      },
      (response) {
        print('✅ Verification successful: ${response.message}');
        emit(VerifyEmailSuccess(response));
      },
    );
  }

  Future<void> resendOTP({required String email}) async {
    emit(ResendOTPLoading());

    final request = ResendOTPRequest(email: email.trim());

    print('📤 Resending OTP to: $email');

    final Either<Failure, ResendOTPResponse> result = await resendOTPUseCase(
      request,
    );

    result.fold(
      (failure) {
        print('❌ Resend OTP failed: ${failure.toString()}');
        emit(ResendOTPError(failure));
      },
      (response) {
        print('✅ OTP resent successfully: ${response.message}');
        emit(ResendOTPSuccess(response));

        Future.delayed(const Duration(seconds: 2), () {
          if (!isClosed) emit(AuthInitial());
        });
      },
    );
  }

  void resetState() {
    emit(AuthInitial());
  }
}
