import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/auth_cubit.dart';
import '../widgets/verify_header.dart';
import '../widgets/verify_content.dart';
import '../widgets/verify_bottom_section.dart';
import 'register_error_handler.dart';

class VerifySections extends StatefulWidget {
  final String? email;

  const VerifySections({super.key, this.email});

  @override
  State<VerifySections> createState() => _VerifyViewState();
}

class _VerifyViewState extends State<VerifySections> with AuthErrorHandler {
   final TextEditingController pinController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is VerifyEmailError) {
            handleAuthError(
              state.failure,
              (errors) {}, // No field errors for OTP
              () {},      // No field errors to clear
              context,
            );
          } else if (state is VerifyEmailSuccess) {
            showSuccessMessage(context, state.response.message);
            
            // Navigate back to login after success
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                Navigator.of(context).pop();
              }
            });
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              // Header Section
              VerifyHeader(email: widget.email),
              
              // Content Section (Expandable)
              Expanded(
                child: VerifyContent(email: widget.email),
              ),
              
              // Bottom Section (Timer + Button)
              VerifyBottomSection(email: widget.email ,pin: pinController.text ,),
            ],
          ),
        ),
      ),
    );
  }
}