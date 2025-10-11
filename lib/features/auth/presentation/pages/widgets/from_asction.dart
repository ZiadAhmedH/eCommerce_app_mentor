import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../shared/widgets/custom_widget.dart';
import '../../cubit/auth_cubit.dart';

class RegisterFormActions extends StatelessWidget {
  final VoidCallback onRegisterPressed;

  const RegisterFormActions({
    super.key,
    required this.onRegisterPressed,
  });

  @override
  Widget build(BuildContext context) {
     var screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        const SizedBox(height: 32),

        BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return CustomButton(
              text: 'Sign Up',
              isLoading: state is RegisterLoading,
              onPressed: state is RegisterLoading ? null : onRegisterPressed,
             borderRadius: 0,   
             height: screenHeight * 0.08,
            );
          },
        ),
      ],
    );
  }
}


