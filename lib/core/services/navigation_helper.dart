import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationHelper {
  // Private constructor to prevent instantiation
  NavigationHelper._();

  // Static instance for global access
  static final NavigationHelper _instance = NavigationHelper._();
  static NavigationHelper get instance => _instance;

  // Global navigator key for cases where context is not available
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Get current context
  static BuildContext? get currentContext => navigatorKey.currentContext;

  /// Navigate to a route and replace current route
  static void go(String path, {Object? extra}) {
    final context = currentContext;
    if (context != null) {
      context.go(path, extra: extra);
    }
  }

  /// Navigate to a route by pushing it onto the stack
  static void push(String path, {Object? extra}) {
    final context = currentContext;
    if (context != null) {
      context.push(path, extra: extra);
    }
  }

  /// Navigate to a route by name and replace current route
  static void goNamed(String name, {Map<String, String>? pathParameters, Map<String, dynamic>? queryParameters, Object? extra}) {
    final context = currentContext;
    if (context != null) {
      context.goNamed(name, pathParameters: pathParameters ?? {},extra: extra);
    }
  }

  /// Navigate to a route by name by pushing it onto the stack
  static void pushNamed(String name, {Map<String, String>? pathParameters, Map<String, dynamic>? queryParameters, Object? extra}) {
    final context = currentContext;
    if (context != null) {
      context.pushNamed(name, pathParameters: pathParameters ?? {},);
    }
  }

  /// Pop the current route
  static void pop([Object? result]) {
    final context = currentContext;
    if (context != null && context.canPop()) {
      context.pop(result);
    }
  }

  /// Push and remove all previous routes
  static void pushAndClearStack(String path, {Object? extra}) {
    final context = currentContext;
    if (context != null) {
      // Clear the stack and navigate to new route
      while (context.canPop()) {
        context.pop();
      }
      context.pushReplacement(path, extra: extra);
    }
  }

  /// Push replacement (replace current route)
  static void pushReplacement(String path, {Object? extra}) {
    final context = currentContext;
    if (context != null) {
      context.pushReplacement(path, extra: extra);
    }
  }

  /// Push replacement by name
  static void pushReplacementNamed(String name, {Map<String, String>? pathParameters, Map<String, dynamic>? queryParameters, Object? extra}) {
    final context = currentContext;
    if (context != null) {
      context.pushReplacementNamed(name, pathParameters: pathParameters ?? {},  extra: extra);
    }
  }

  /// Navigate back to specific route
  static void popUntil(String routeName) {
    final context = currentContext;
    if (context != null) {
      Navigator.of(context).popUntil((route) => route.settings.name == routeName);
    }
  }

  /// Check if can pop
  static bool canPop() {
    final context = currentContext;
    return context?.canPop() ?? false;
  }

  /// Show modal bottom sheet
  static Future<T?> showBottomSheet<T>({
    required Widget child,
    bool isScrollControlled = false,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
  }) {
    final context = currentContext;
    if (context == null) return Future.value(null);
    
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      builder: (context) => child,
    );
  }

  /// Show dialog
  static Future<T?> showCustomDialog<T>({
    required Widget child,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
  }) {
    final context = currentContext;
    if (context == null) return Future.value(null);
    
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      builder: (context) => child,
    );
  }

  /// Show snack bar
  static void showSnackBar({
    required String message,
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
    Color? textColor,
    SnackBarAction? action,
  }) {
    final context = currentContext;
    if (context == null) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: textColor),
        ),
        duration: duration,
        backgroundColor: backgroundColor,
        action: action,
      ),
    );
  }

  /// Show success snack bar
  static void showSuccessSnackBar(String message) {
    showSnackBar(
      message: message,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  /// Show error snack bar
  static void showErrorSnackBar(String message) {
    showSnackBar(
      message: message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  /// Show warning snack bar
  static void showWarningSnackBar(String message) {
    showSnackBar(
      message: message,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
    );
  }

  /// Navigate with custom page transition
  static Future<T?> pushWithTransition<T>({
    required Widget page,
    RouteTransitionType transitionType = RouteTransitionType.slide,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    final context = currentContext;
    if (context == null) return Future.value(null);
    
    return Navigator.of(context).push<T>(
      PageRouteBuilder<T>(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: duration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return _buildTransition(transitionType, animation, child, curve);
        },
      ),
    );
  }

  /// Build transition animation
  static Widget _buildTransition(RouteTransitionType type, Animation<double> animation, Widget child, Curve curve) {
    final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);
    
    switch (type) {
      case RouteTransitionType.slide:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );
      case RouteTransitionType.fade:
        return FadeTransition(
          opacity: curvedAnimation,
          child: child,
        );
      case RouteTransitionType.scale:
        return ScaleTransition(
          scale: curvedAnimation,
          child: child,
        );
      case RouteTransitionType.slideUp:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );
      case RouteTransitionType.rotation:
        return RotationTransition(
          turns: curvedAnimation,
          child: child,
        );
    }
  }
}

enum RouteTransitionType {
  slide,
  fade,
  scale,
  slideUp,
  rotation,
}