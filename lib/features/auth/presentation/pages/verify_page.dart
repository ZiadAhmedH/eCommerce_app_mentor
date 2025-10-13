import 'package:ecommerce_app/features/auth/presentation/pages/sections/verify_sections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependency_injection.dart';
import '../cubit/auth_cubit.dart';

class VerifyView extends StatelessWidget {
  final String? email;

  const VerifyView({super.key, this.email});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => getIt<AuthCubit>(),
      child: VerifySections(email: email),
    );
  }
}