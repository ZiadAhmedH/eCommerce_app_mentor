import 'dart:async';
import 'package:ecommerce_app/features/auth/presentation/pages/sections/verify_sections.dart';
import 'package:ecommerce_app/features/auth/presentation/pages/widgets/verify_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constents/app_colors.dart';
import '../../../../../shared/widgets/custom_widget.dart';
import '../../cubit/auth_cubit.dart';

class VerifyBottomSection extends StatefulWidget {
  final String? email;
  final void Function()? onVerify;
  const VerifyBottomSection({super.key, this.email, this.onVerify});

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
    if (!_canResend) return;

    // Trigger resend OTP
    if (widget.email != null) {
      // context.read<AuthCubit>().resendOTP(email: widget.email!);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Verification code resent!'),
        backgroundColor: Colors.blue,
      ),
    );

    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Timer and Resend Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _formatTime(_secondsRemaining),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _canResend ? _onResend : null,
                child: Text(
                  _canResend ? "Resend Code" : "resend confirmation code",
                  style: TextStyle(
                    color: _canResend ? AppColor.primaryColor : Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Verify Button
          BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is VerifyEmailError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.failure.message),
                    backgroundColor: Colors.red,
                  ),
                );
              } else if (state is VerifyEmailSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.response.message),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            builder: (context, state) {
              return CustomButton(
                text: "Confirm Code",
                onPressed: state is VerifyEmailLoading
                    ? null
                    : widget.onVerify,
                isLoading: state is VerifyEmailLoading,
                borderRadius: 16,
              );
            },
          ),
        ],
      ),
    );
  }
 
  }

