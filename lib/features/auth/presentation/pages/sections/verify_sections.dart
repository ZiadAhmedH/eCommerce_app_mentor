import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import '../../../../../core/constents/app_colors.dart';
import '../../../../../core/constents/assets.dart';
import '../../cubit/auth_cubit.dart';
import '../widgets/verify_header.dart';
import '../widgets/verify_bottom_section.dart';
import 'register_error_handler.dart';

class VerifySections extends StatefulWidget {
  final String? email;

  const VerifySections({super.key, this.email});

  @override
  State<VerifySections> createState() => _VerifySectionsState();
}

class _VerifySectionsState extends State<VerifySections> with AuthErrorHandler {
  final TextEditingController pinController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is VerifyEmailError) {
            handleAuthError(
              state.failure,
              (errors) {}, // No field-specific errors for OTP
              () {}, // No need to clear field errors
              context,
            );
          } else if (state is VerifyEmailSuccess) {
            showSuccessMessage(context, state.response.message);

            // Navigate back to login after a small delay
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                Navigator.of(context).pop();
              }
            });
          }
        },
        child: Column(
          children: [
            // Header Section
            VerifyHeader(email: widget.email),
        
            // Content Section (Pinput inside the screen)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Illustration
                    Image.asset(
                      Assets.assetsObjectsLock,
                      height: 200,
                    ),
                    const SizedBox(height: 40),
        
                    // PIN Input Field
                    _buildPinput(context),
        
                    const SizedBox(height: 20),
        
                    // Instruction text
                    Text(
                      "Enter the 6-digit code sent to your email",
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
        
            // Bottom Section (Verify button)
            VerifyBottomSection(
              email: widget.email,
              onVerify: () {
                final pin = pinController.text.trim();
                debugPrint('PIN to verify: $pin');
                if (pin.length == 6) {
                  context.read<AuthCubit>().verifyEmail(
                        email: widget.email ?? '',
                        otp: pin,
                      );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid 6-digit code'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      
    );
  }

  /// Builds the PIN input widget
  Widget _buildPinput(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 70,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return Pinput(
      length: 6,
      controller: pinController,
      focusNode: focusNode,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: defaultPinTheme.copyDecorationWith(
        border: Border.all(color: AppColor.primaryColor, width: 2),
      ),
      submittedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration?.copyWith(
          color: AppColor.gradientStart.withOpacity(0.1),
        ),
      ),
      onCompleted: (pin) {
        debugPrint('PIN entered: $pin');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PIN entered: $pin'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
    );
  }
}
