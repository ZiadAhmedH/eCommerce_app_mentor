import 'package:ecommerce_app/core/routing/app_routes.dart';
import 'package:ecommerce_app/shared/widgets/text_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/services/secure_storage_service.dart';
import '../../cubit/auth_cubit.dart';
import '../widgets/login_form_header.dart';
import '../widgets/login_form_fields.dart';
import '../widgets/login_form_actions.dart';
import 'register_error_handler.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with AuthErrorHandler {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  Map<String, String?> _fieldErrors = {};

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginError) {
          handleAuthError(
            state.failure,
            _setFieldErrors,
            _clearFieldErrors,
            context,
          );
        } else if (state is LoginSuccess) {
          _clearFieldErrors();

          // Save tokens using SharedPreferences
          _saveTokens(state);

          // Show success message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 8),
                    const Text('Login successful!'),
                  ],
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );

            // Navigate after delay
            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) {
                context.go(AppRoutes.home);
              }
            });
          }
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom -
                        180, // Approximate space for button and app bar
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header Section
                        const LoginFormHeader(),

                        // Form Fields Section
                        LoginFormFields(
                          emailController: _emailController,
                          passwordController: _passwordController,
                          fieldErrors: _fieldErrors,
                          isPasswordVisible: _isPasswordVisible,
                          onPasswordVisibilityToggle: _togglePasswordVisibility,
                        ),

                        const SizedBox(height: 16),

                        // Forgot Password Link
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // Handle forgot password action
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),

                        // Spacer to push content up
                        const Spacer(),

                        // Add some bottom padding to ensure content doesn't touch the button
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Fixed bottom button area
            LoginFormActions(onLoginPressed: _onLoginPressed),
          ],
        ),
      ),
    );
  }

  void _setFieldErrors(Map<String, String?> errors) {
    setState(() {
      _fieldErrors = errors;
    });
  }

  void _clearFieldErrors() {
    setState(() {
      _fieldErrors = {};
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _onLoginPressed() {
    if (_formKey.currentState!.validate()) {
      _clearFieldErrors();
      context.read<AuthCubit>().login(
        email: _emailController.text,
        password: _passwordController.text,
      );
    }
  }

  // Simple save method
  Future<void> _saveTokens(LoginSuccess state) async {
    try {
      await SecureTokenStorage.saveLoginTokens(
        accessToken: state.response.accessToken,
        refreshToken: state.response.refreshToken,
      );

      if (kDebugMode) {
        print('✅ Tokens saved successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to save tokens: $e');
      }
    }
  }
}
