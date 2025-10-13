import 'package:ecommerce_app/core/di/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constents/assets.dart';
import '../../core/routing/app_navigation.dart';
import '../../core/routing/app_routes.dart';
import '../../core/services/shared_keys.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final prefs = getIt<SharedPreferences>();
    final bool hasSeenOnboarding =
        prefs.getBool(SharedKeys.isOnboardingCompleted) ?? false;
    final bool isLoggedIn = prefs.getBool(SharedKeys.isLogin) ?? false;

    final String initialRoute = !hasSeenOnboarding
        ? AppRoutes.onboarding
        : isLoggedIn
        ? AppRoutes.home
        : AppRoutes.mainauth;

    context.go(initialRoute);
    if (mounted) context.go(initialRoute);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8E6CEF),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Image.asset(Assets.assetsIconsLogo, width: 120, height: 120),
        ),
      ),
    );
  }
}
