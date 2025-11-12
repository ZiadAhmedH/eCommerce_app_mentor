import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constents/app_colors.dart';
import '../../cubit/auth_cubit.dart';

class VerifyBottomSection extends StatefulWidget {
  final String? email;
  final String currentPin;
  final VoidCallback? onVerifyPressed;

  const VerifyBottomSection({
    super.key,
    this.email,
    required this.currentPin,
    this.onVerifyPressed,
  });

  @override
  State<VerifyBottomSection> createState() => _VerifyBottomSectionState();
}

class _VerifyBottomSectionState extends State<VerifyBottomSection> {
  Timer? _timer;
  int _secondsRemaining = 30;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 30;
      _canResend = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        setState(() {
          _canResend = true;
          timer.cancel();
        });
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  void _onResend() {
    if (!_canResend || widget.email == null) return;

    // Trigger resend OTP via Cubit
    context.read<AuthCubit>().resendOTP(email: widget.email!);

    // Restart timer
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        // Restart timer when OTP is successfully resent
        if (state is ResendOTPSuccess) {
          _startTimer();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Timer and Resend Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.timer,
                  size: 18,
                  color: _secondsRemaining > 0
                      ? Colors.grey[600]
                      : Colors.green,
                ),
                const SizedBox(width: 8),
                Text(
                  _formatTime(_secondsRemaining),
                  style: TextStyle(
                    fontSize: 16,
                    color: _secondsRemaining > 0
                        ? Colors.black87
                        : Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _canResend ? _onResend : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _canResend
                          ? AppColor.primaryColor.withOpacity(0.1)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _canResend
                            ? AppColor.primaryColor
                            : Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.refresh,
                          size: 16,
                          color: _canResend
                              ? AppColor.primaryColor
                              : Colors.grey[400],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _canResend ? "Resend Code" : "Wait to resend",
                          style: TextStyle(
                            color: _canResend
                                ? AppColor.primaryColor
                                : Colors.grey[400],
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // PIN Status Indicator
            if (widget.currentPin.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: widget.currentPin.length == 6
                      ? Colors.green.withOpacity(0.1)
                      : Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: widget.currentPin.length == 6
                        ? Colors.green
                        : Colors.blue,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      widget.currentPin.length == 6
                          ? Icons.check_circle
                          : Icons.info_outline,
                      size: 16,
                      color: widget.currentPin.length == 6
                          ? Colors.green
                          : Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.currentPin.length == 6
                          ? 'Code Complete ✓'
                          : 'Enter ${6 - widget.currentPin.length} more digit(s)',
                      style: TextStyle(
                        fontSize: 12,
                        color: widget.currentPin.length == 6
                            ? Colors.green
                            : Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // Verify Button
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                final isLoading = state is VerifyEmailLoading;
                final isEnabled = widget.currentPin.length == 6 && !isLoading;

                return SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isEnabled ? widget.onVerifyPressed : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7B68EE),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: isEnabled ? 2 : 0,
                      disabledBackgroundColor: Colors.grey[300],
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.verified_user, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Confirm Code',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: isEnabled
                                      ? Colors.white
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                  ),
                );
              },
            ),

            // Help text
            const SizedBox(height: 12),
            Text(
              "Didn't receive the code? Check spam folder",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
