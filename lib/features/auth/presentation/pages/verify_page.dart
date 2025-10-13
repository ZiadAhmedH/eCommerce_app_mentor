import 'package:ecommerce_app/features/auth/presentation/pages/sections/verify_sections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/dependency_injection.dart';
import '../cubit/auth_cubit.dart';

class VerifyView extends StatelessWidget {
  final String? email;

  const VerifyView({super.key, this.email});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => getIt<AuthCubit>(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              
            },
          ),

        ),
        body: VerifySections(email: email)),
    );
  }
}