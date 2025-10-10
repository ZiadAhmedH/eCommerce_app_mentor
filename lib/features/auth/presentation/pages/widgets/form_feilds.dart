import 'package:ecommerce_app/features/auth/presentation/pages/widgets/password_str.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../../shared/widgets/custom_form_field.dart';

class RegisterFormFields extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Map<String, String?> fieldErrors;
  final bool isPasswordVisible;
  final VoidCallback onPasswordVisibilityToggle;

  const RegisterFormFields({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.passwordController,
    required this.fieldErrors,
    required this.isPasswordVisible,
    required this.onPasswordVisibilityToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('🔍 RegisterFormFields - fieldErrors: $fieldErrors');
    }

    return Column(
      children: [

        CustomFormField(
          controller: firstNameController,
          labelText: 'First Name',
          hintText: 'Enter your first name',
          textCapitalization: TextCapitalization.words,
          errorText: fieldErrors['firstName'],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your first name';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

        CustomFormField(
          controller: lastNameController,
          labelText: 'Last Name',
          hintText: 'Enter your last name',
          textCapitalization: TextCapitalization.words,
          errorText: fieldErrors['lastName'],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your last name';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

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

        Column(
          children: [
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
                if (value.length < 8) {
                  return 'Password must be at least 8 characters';
                }
                return null;
              },
            ),

            // Password strength indicator
            if (passwordController.text.isNotEmpty &&
                fieldErrors['password'] == null)
              PasswordStrengthIndicator(password: passwordController.text),
          ],
        ),
      ],
    );
  }
}
