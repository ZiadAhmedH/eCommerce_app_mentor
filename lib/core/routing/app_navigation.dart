import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppNavigation {
  /// Navigate with fade animation using go(), with optional params and queryParams
  static void animatedGo(
    BuildContext context,
    String route, {
    Map<String, String>? params,
    Map<String, String>? queryParams,
    Object? extra,
  }) {
    if (!context.mounted) return;

    _fadeOutAndNavigate(context, () {
      try {
        context.goNamed(
          route,
          pathParameters: params ?? const {},
          queryParameters: queryParams ?? const {},
          extra: extra,
        );
      } catch (e) {
        debugPrint('❌ Navigation error (go): $e');
        // Fallback to simple navigation
        context.go(route);  
      }
    });
  }

  /// Push a route with a loading indicator, and optional parameters
  static Future<T?> animatedPush<T extends Object?>(
    BuildContext context,
    String route, {
    Map<String, String>? params,
    Map<String, String>? queryParams,
    Object? extra,
  }) async {
    if (!context.mounted) return null;

    _showNavigationIndicator(context);

    try {
      final result = await context.pushNamed<T>(
        route,
        pathParameters: params ?? const {},
        queryParameters: queryParams ?? const {},
        extra: extra,
      );

      if (context.mounted) {
        _hideNavigationIndicator(context);
      }

      return result;
    } catch (e) {
      debugPrint('❌ Navigation error (push): $e');

      if (context.mounted) {
        _hideNavigationIndicator(context);
      }

      return null;
    }
  }

  /// Push with animation, allows passing data via GoRouter
  static Future<T?> pushWithAnimation<T extends Object?>(
    BuildContext context,
    String route, {
    Map<String, String>? params,
    Map<String, String>? queryParams,
    Object? extra,
    AnimationType type = AnimationType.slideFromRight,
  }) async {
    if (!context.mounted) return null;

    // Add some visual feedback based on animation type
    if (type == AnimationType.fade) {
      _showFadeTransition(context);
    }

    try {
      return await context.pushNamed<T>(
        route,
        pathParameters: params ?? const {},
        queryParameters: queryParams ?? const {},
        extra: extra,
      );
    } catch (e) {
      debugPrint('❌ Navigation error (pushWithAnimation): $e');
      return null;
    }
  }

  /// Replace current route, with optional parameters
  static void animatedReplace(
    BuildContext context,
    String route, {
    Map<String, String>? params,
    Map<String, String>? queryParams,
    Object? extra,
  }) {
    if (!context.mounted) return;

    _fadeOutAndNavigate(context, () {
      try {
        context.goNamed(
          route,
          pathParameters: params ?? const {},
          queryParameters: queryParams ?? const {},
          extra: extra,
        );
      } catch (e) {
        debugPrint('❌ Navigation error (replace): $e');
        context.go(route);
      }
    });
  }

  /// Pop current route with fade animation
  static void animatedPop<T extends Object?>(
    BuildContext context, [
    T? result,
  ]) {
    if (!context.mounted) return;

    _fadeOutAndNavigate(context, () {
      if (context.canPop()) {
        context.pop(result);
      }
    });
  }

  /// Pop all routes and go to specific route
  static void popAndGo(
    BuildContext context,
    String route, {
    Map<String, String>? params,
    Map<String, String>? queryParams,
    Object? extra,
  }) {
    if (!context.mounted) return;

    // Pop all routes first
    while (context.canPop()) {
      context.pop();
    }

    // Then navigate to new route
    animatedGo(
      context,
      route,
      params: params,
      queryParams: queryParams,
      extra: extra,
    );
  }

  /// Check if can pop
  static bool canPop(BuildContext context) {
    return context.canPop();
  }

  // ------------------------
  // Private Helper Functions
  // ------------------------

  static void _fadeOutAndNavigate(BuildContext context, VoidCallback navigate) {
    if (!context.mounted) return;

    // Create a subtle overlay
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.1),
      builder: (context) => const SizedBox.shrink(),
    );

    // Execute navigation after brief delay
    Future.delayed(const Duration(milliseconds: 150), () {
      if (context.mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop(); // Remove overlay
      }

      if (context.mounted) {
        navigate();
      }
    });
  }

  static void _showFadeTransition(BuildContext context) {
    if (!context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.white.withOpacity(0.3),
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    Future.delayed(const Duration(milliseconds: 200), () {
      if (context.mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }

  static void _showNavigationIndicator(BuildContext context) {
    if (!context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                ),
                SizedBox(width: 16),
                Text(
                  'Loading...',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void _hideNavigationIndicator(BuildContext context) {
    if (context.mounted && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }
}

/// Supported custom animation types
enum AnimationType {
  slideFromRight,
  slideFromBottom,
  fade,
  scale,
  slideAndFade,
  heroZoom,
}

/// Extension methods for easier navigation
extension AppNavigationExtension on BuildContext {
  /// Quick animated go
  void goAnimated(String route, {Map<String, String>? params}) {
    AppNavigation.animatedGo(this, route, params: params);
  }

  /// Quick animated push
  Future<T?> pushAnimated<T>(String route, {Map<String, String>? params}) {
    return AppNavigation.animatedPush<T>(this, route, params: params);
  }

  /// Quick animated pop
  void popAnimated<T>([T? result]) {
    AppNavigation.animatedPop<T>(this, result);
  }
}
