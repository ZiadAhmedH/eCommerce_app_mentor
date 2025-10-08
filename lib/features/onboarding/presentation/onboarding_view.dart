import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/services/onboarding_service.dart';
import 'widgets/index.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  String selectedGender = 'Men';

  Future<void> _completeOnboarding(BuildContext context) async {
    await OnboardingService.completeOnboarding();
    if (context.mounted) {
      context.go(AppRoutes.home);
    }
  }

  void _selectGender(String gender) {
    setState(() {
      selectedGender = gender;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: AlignmentGeometry.bottomCenter,
        children: [
          const OnboardingBackground(),
          Positioned(
            bottom: 20,
            child: OnboardingContentCard(
              selectedGender: selectedGender,
              onGenderChanged: _selectGender,
              onSkip: () => _completeOnboarding(context),
            ),
          ),
        ],
      ),
    );
  }
}
