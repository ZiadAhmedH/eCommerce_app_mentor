import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  void initState() {
    super.initState();
    // Listen to PIN changes
    pinController.addListener(() {
      setState(() {}); // Rebuild to update current pin
    });
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // Handle VerifyEmail states
        if (state is VerifyEmailError) {
          handleAuthError(
            state.failure,
            (errors) {
              // Show OTP error with resend option
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(errors['otp'] ?? 'Invalid OTP'),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  action: SnackBarAction(
                    label: 'Resend',
                    textColor: Colors.white,
                    onPressed: () {
                      if (widget.email != null) {
                        context.read<AuthCubit>().resendOTP(email: widget.email!);
                      }
                    },
                  ),
                  duration: const Duration(seconds: 4),
                ),
              );
            },
            () {},
            context,
          );
        } else if (state is VerifyEmailSuccess) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(state.response.message),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );

          // Navigate back after success
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              Navigator.of(context).pop();
            }
          });
        }

        // Handle ResendOTP states
        else if (state is ResendOTPSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.mail_outline, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(state.response.message),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            ),
          );
        } else if (state is ResendOTPError) {
          handleAuthError(
            state.failure,
            (errors) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.white),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text('Failed to resend OTP. Please try again.'),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            () {},
            context,
          );
        }
      },
      builder: (context, state) {
        // Show loading overlay for resend OTP
        final isResending = state is ResendOTPLoading;

        return Stack(
          children: [
            Column(
              children: [
                // Header Section
                VerifyHeader(email: widget.email),

                // Content Section (Pinput inside the screen)
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          
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
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 20),

                          // Debug Panel (only in debug mode)
                        
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom Section (Verify button)
                VerifyBottomSection(
                  email: widget.email,
                  currentPin: pinController.text,
                  onVerifyPressed: _onVerifyPressed,
                ),
              ],
            ),

            // Loading overlay for resending OTP
            if (isResending)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 16),
                          const Text(
                            'Resending OTP...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Sending to ${widget.email}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
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
        // Auto-verify when PIN is complete (optional)
        // _onVerifyPressed();
      },
    );
  }

  void _onVerifyPressed() {
    final pin = pinController.text.trim();
    
    if (pin.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning_amber, color: Colors.white),
              SizedBox(width: 8),
              Text('Please enter complete 6-digit code'),
            ],
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Remove any spaces or special characters
    final cleanedPin = pin.replaceAll(RegExp(r'[^0-9]'), '');

    debugPrint('🔐 Attempting verification with cleaned PIN: $cleanedPin');

    context.read<AuthCubit>().verifyEmail(
          email: widget.email ?? '',
          otp: cleanedPin,
        );
  }
}
