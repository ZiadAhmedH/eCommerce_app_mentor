import 'package:ecommerce_app/features/auth/presentation/pages/login_register_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/products/presentation/pages/home_page.dart';
import '../../features/products/presentation/pages/product_detail_page.dart';
import '../../features/products/presentation/pages/products_page.dart';
import '../../features/onboarding/presentation/onboarding_view.dart';
import '../../features/splash/splash_view.dart';
import 'app_routes.dart';
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false, // Disable to reduce console spam
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: "splash",
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: "onboarding",
        builder: (context, state) => const OnboardingView(),
      ),
      GoRoute(
        path: AppRoutes.mainauth,
        name: "mainauth",
        builder: (context, state) =>  LoginRegisterView(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: "login",
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: "register",
        builder: (context, state) => const RegisterPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainAppShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            name: "home",
            builder: (context, state) => const HomeView(),
          ),
          GoRoute(
            path: AppRoutes.products,
            name: "products",
            builder: (context, state) => const ProductsPage(),
          ),
          GoRoute(
            path: AppRoutes.productDetail,
            name: "productDetail",
            builder: (context, state) {
              final productId = state.pathParameters['id']!;
              return ProductDetailPage(productId: productId);
            },
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Route not found: ${state.name}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}class MainAppShell extends StatefulWidget {
  final Widget child;

  const MainAppShell({super.key, required this.child});

  @override
  State<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell> {
  late PageController _pageController;
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeView(), // Home
    const ProductsPage(), // Products
    const Scaffold(body: Center(child: Text('Cart'))), // Cart placeholder
    const Scaffold(body: Center(child: Text('Profile'))), // Profile placeholder
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
          // Update the URL to match the current page
          _updateRouteForIndex(index);
        },
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  void _updateRouteForIndex(int index) {
    // Update URL without rebuilding the entire shell
    switch (index) {
      case 0:
        if (kDebugMode) print('🏠 Going to Home');
        context.go(AppRoutes.home);
        break;
      case 1:
        if (kDebugMode) print('🛍️ Going to Products');
        context.go(AppRoutes.products);
        break;
      case 2:
        if (kDebugMode) print('🛒 Going to Cart');
        context.go(AppRoutes.cart);
        break;
      case 3:
        if (kDebugMode) print('👤 Going to Profile');
        context.go(AppRoutes.profile);
        break;
    }
  }

  void _onItemTapped(int index) {
    if (_currentIndex == index) return;

    if (kDebugMode) {
      print('📱 NAV: Tab $_currentIndex → Tab $index');
    }

    // Animate to the selected page
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
    );
  }
}
