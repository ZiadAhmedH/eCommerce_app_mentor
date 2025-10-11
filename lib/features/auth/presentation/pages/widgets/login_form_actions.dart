import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../shared/widgets/custom_widget.dart';
import '../../cubit/auth_cubit.dart';

class LoginFormActions extends StatelessWidget {
  final VoidCallback onLoginPressed;
  final VoidCallback? onForgotPassword;
  final VoidCallback? onCreateAccount;

  const LoginFormActions({
    super.key,
    required this.onLoginPressed,
    this.onForgotPassword,
    this.onCreateAccount,
  });

  @override
  Widget build(BuildContext context) {
      var screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        const SizedBox(height: 16),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: onForgotPassword,
            child: const Text(
              'Forgot Password?',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Login Button
        BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return CustomButton(
              text: 'Login',
              isLoading: state is LoginLoading,
              onPressed: state is LoginLoading ? null : onLoginPressed,
               borderRadius: 0,   
              height: screenHeight * 0.08,
            );
          },
        ),

       
      ],
    );
  }
}
