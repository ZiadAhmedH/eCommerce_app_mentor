import 'package:ecommerce_app/core/constents/app_colors.dart';
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

class _OnboardingViewState extends State<OnboardingView>
    with SingleTickerProviderStateMixin {
  String selectedGender = 'Men';

  late AnimationController _controller;
  late Animation<Offset> _imageSlide;
  late Animation<Offset> _containerSlide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _imageSlide = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
          ),
        );

    _containerSlide = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
          ),
        );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
      backgroundColor: AppColor.gradientEnd,
      body: Stack(
        alignment: AlignmentGeometry.bottomCenter,
        children: [
          SlideTransition(
            position: _imageSlide,
            child: const OnboardingBackground(),
          ),

          Positioned(
            bottom: 20,
            child: SlideTransition(
              position: _containerSlide,
              child: OnboardingContentCard(
                selectedGender: selectedGender,
                onGenderChanged: _selectGender,
                onSkip: () => _completeOnboarding(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
