import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/auth_cubit.dart';
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

class _RegisterFormState extends State<RegisterForm> with AuthErrorHandler {
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
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is RegisterError) {
          handleAuthError(
            state.failure,
            _setFieldErrors,
            _clearFieldErrors,
            context,
          );
        } else if (state is RegisterSuccess) {
          clearForm();
          
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
              content: Text(state.response.message ),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    const RegisterFormHeader(),
                
                   
                    RegisterFormFields(
                      firstNameController: _firstNameController,
                      lastNameController: _lastNameController,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      fieldErrors: _fieldErrors,
                      isPasswordVisible: _isPasswordVisible,
                      onPasswordVisibilityToggle: _togglePasswordVisibility,
                    ),
                
                  ],
                ),
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

  void clearForm() {
    _formKey.currentState?.reset();
    _emailController.clear();
    _passwordController.clear();
    _firstNameController.clear();
    _lastNameController.clear();
    _clearFieldErrors();
  }

  void _onRegisterPressed() {
    if (_formKey.currentState!.validate()) {
      _clearFieldErrors();
      context.read<AuthCubit>().register(
        email: _emailController.text,
        password: _passwordController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
      );
    }
  }
}
