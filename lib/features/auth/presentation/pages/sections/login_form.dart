import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.response.message),
              backgroundColor: Colors.green,
            ),
          );
          // TODO: Navigate to home page
          // context.go(AppRoutes.home);
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LoginFormHeader(),

          

            LoginFormFields(
              emailController: _emailController,
              passwordController: _passwordController,
              fieldErrors: _fieldErrors,
              isPasswordVisible: _isPasswordVisible,
              onPasswordVisibilityToggle: _togglePasswordVisibility,
            ),

            // Actions Section
            LoginFormActions(
              onLoginPressed: _onLoginPressed,
              onForgotPassword: () {
              },
              
            ),
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
}
