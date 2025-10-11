import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../../shared/widgets/custom_form_field.dart';

class LoginFormFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Map<String, String?> fieldErrors;
  final bool isPasswordVisible;
  final VoidCallback onPasswordVisibilityToggle;

  const LoginFormFields({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.fieldErrors,
    required this.isPasswordVisible,
    required this.onPasswordVisibilityToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('🔍 LoginFormFields - fieldErrors: $fieldErrors');
    }

    return Column(
      children: [

        CustomFormField(
          controller: emailController,
          labelText: 'Email Address',
          hintText: 'Enter your email address',
          keyboardType: TextInputType.emailAddress,
          errorText: fieldErrors['email'],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

        CustomFormField(
          controller: passwordController,
          labelText: 'Password',
          hintText: 'Enter your password',
          obscureText: !isPasswordVisible,
          errorText: fieldErrors['password'],
          suffixIcon: IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey[600],
            ),
            onPressed: onPasswordVisibilityToggle,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a password';
            }
            return null;
          },
        ),
      ],
    );
  }
}
