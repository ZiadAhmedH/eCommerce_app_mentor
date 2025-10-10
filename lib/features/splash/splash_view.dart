import 'package:ecommerce_app/core/constents/assets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/routing/app_routes.dart';
import '../../core/services/onboarding_service.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    debugPrint('🚀 SplashView initialized');
    _setupAnimation();
    _handleNavigation();
  }

  void _setupAnimation() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  void _handleNavigation() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateAfterDelay();
    });
  }

  void _navigateAfterDelay() async {
    debugPrint('🔄 Starting navigation delay...');

    // Minimum splash duration
    await Future.delayed(const Duration(milliseconds: 2000));

    if (!mounted || _hasNavigated) {
      debugPrint('⚠️ Component unmounted or already navigated');
      return;
    }

    try {
      debugPrint('🔍 Checking onboarding status...');
      final hasSeenOnboarding = await OnboardingService.hasSeenOnboarding();
      debugPrint('📊 Onboarding status: $hasSeenOnboarding');

      if (!mounted || _hasNavigated) {
        debugPrint('⚠️ Component unmounted during async operation');
        return;
      }

      _hasNavigated = true;

      // Navigate based on onboarding status
      // Note: If hasSeenOnboarding is true, user has seen onboarding, so go to main auth
      // If hasSeenOnboarding is false, user hasn't seen onboarding, so show onboarding
      final destination = hasSeenOnboarding
          ? AppRoutes.mainauth
          : AppRoutes.onboarding;

      debugPrint('🎯 Navigating to: $destination');

      if (mounted) {
        context.go(destination);
        debugPrint('✅ Navigation completed to: $destination');
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Navigation error: $e');
      debugPrint('📊 Stack trace: $stackTrace');

      // Fallback navigation
      if (mounted && !_hasNavigated) {
        _hasNavigated = true;
        debugPrint('🔄 Falling back to onboarding');
        context.go(AppRoutes.onboarding);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    debugPrint('🔚 SplashView disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8E6CEF),
      body: Center(
        child: AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Image.asset(Assets.assetsIconsLogo, width: 120, height: 120),
            );
          },
        ),
      ),
    );
  }
}
