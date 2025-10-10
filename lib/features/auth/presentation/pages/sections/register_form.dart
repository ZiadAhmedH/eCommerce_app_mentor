import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/register_cubit.dart';
import '../widgets/debug_ifo.dart';
import '../widgets/form_feilds.dart';
import '../widgets/form_header.dart';
import '../widgets/from_asction.dart';
import 'register_error_handler.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> with RegisterErrorHandler {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  bool _isPasswordVisible = false;
  Map<String, String?> _fieldErrors = {};

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterError) {
          handleRegisterError(
            state.failure,
            _setFieldErrors,
            _clearFieldErrors,
            context,
          );
        } else if (state is RegisterSuccess) {
          _clearFieldErrors();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account created successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      child: SizedBox(
        height: double.infinity,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Section
                  const RegisterFormHeader(),
              
                  // Debug Info Section
                 // RegisterDebugInfo(fieldErrors: _fieldErrors),
              
                  RegisterFormFields(
                    firstNameController: _firstNameController,
                    lastNameController: _lastNameController,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    fieldErrors: _fieldErrors,
                    isPasswordVisible: _isPasswordVisible,
                    onPasswordVisibilityToggle: _togglePasswordVisibility,
                  ),
              
                  // Actions Section
                ],
              ),
              Spacer(),
                  RegisterFormActions(onRegisterPressed: _onRegisterPressed),
        
            ],
          ),
        ),
      ),
    );
  }

  void _setFieldErrors(Map<String, String?> errors) {
    if (kDebugMode) {
      print('🔄 Setting field errors: $errors');
    }
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

  void _onRegisterPressed() {
    if (_formKey.currentState!.validate()) {
      _clearFieldErrors();
      context.read<RegisterCubit>().register(
        email: _emailController.text,
        password: _passwordController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
      );
    }
  }
}
