import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppNavigation {
  static void animatedGo(BuildContext context, String route) {
    _fadeOutAndNavigate(context, () => context.go(route));
  }

  static Future<T?> animatedPush<T extends Object?>(
    BuildContext context,
    String route,
  ) async {
    _showNavigationIndicator(context);

    final result = await context.push<T>(route);

    _hideNavigationIndicator(context);

    return result;
  }

  static Future<T?> pushWithAnimation<T extends Object?>(
    BuildContext context,
    String route, {
    AnimationType type = AnimationType.slideFromRight,
  }) async {
    return await context.push<T>(route);
  }

  static void animatedReplace(BuildContext context, String route) {
    _fadeOutAndNavigate(context, () => context.pushReplacement(route));
  }

  static void animatedPop<T extends Object?>(
    BuildContext context, [
    T? result,
  ]) {
    _fadeOutAndNavigate(context, () => context.pop(result));
  }

  static void _fadeOutAndNavigate(BuildContext context, VoidCallback navigate) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) => Container(),
    ).then((_) {
      Navigator.of(context).pop(); 
      navigate(); // Execute the navigation
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      navigate();
    });
  }

  static void _showNavigationIndicator(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 12),
                Text('Loading...'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void _hideNavigationIndicator(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }
}

enum AnimationType {
  slideFromRight,
  slideFromBottom,
  fade,
  scale,
  slideAndFade,
  heroZoom,
}
