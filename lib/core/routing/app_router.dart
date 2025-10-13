import 'package:ecommerce_app/features/auth/presentation/pages/login_register_view.dart';
import 'package:ecommerce_app/features/auth/presentation/pages/login_view.dart';
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
import 'animation_page_transitions.dart';
import 'app_routes.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    routes: [
      // Splash - Fade in
      GoRoute(
        path: AppRoutes.splash,
        name: "splash",
        pageBuilder: (context, state) => AppPageTransitions.fadeTransition(
          context,
          state,
          const SplashView(),
        ),
      ),

      // Onboarding - Slide from right
      GoRoute(
        path: AppRoutes.onboarding,
        name: "onboarding",
        pageBuilder: (context, state) => AppPageTransitions.slideFromRight(
          context,
          state,
          const OnboardingView(),
        ),
      ),

      // Main Auth - Scale animation
      GoRoute(
        path: AppRoutes.mainauth,
        name: "mainauth",
        pageBuilder: (context, state) => AppPageTransitions.scaleTransition(
          context,
          state,
          LoginRegisterView(),
        ),
      ),

      // Login - Slide and fade
      GoRoute(
        path: AppRoutes.login,
        name: "login",
        pageBuilder: (context, state) =>
            AppPageTransitions.slideAndFade(context, state, const LoginView()),
      ),

      // Register - Slide from bottom
      GoRoute(
        path: AppRoutes.register,
        name: "register",
        pageBuilder: (context, state) => AppPageTransitions.slideFromBottom(
          context,
          state,
          const RegisterPage(),
        ),
      ),

      // Main Shell with animated pages
      ShellRoute(
        pageBuilder: (context, state, child) =>
            AppPageTransitions.fadeTransition(
              context,
              state,
              MainAppShell(child: child),
            ),
        routes: [
          // Home - Fade transition
          GoRoute(
            path: AppRoutes.home,
            name: "home",
            pageBuilder: (context, state) => AppPageTransitions.fadeTransition(
              context,
              state,
              const HomeView(),
            ),
          ),

          // Products - Slide from right
          GoRoute(
            path: AppRoutes.products,
            name: "products",
            pageBuilder: (context, state) => AppPageTransitions.slideFromRight(
              context,
              state,
              const ProductsPage(),
            ),
          ),

          // Product Detail - Hero zoom (for dramatic effect)
          GoRoute(
            path: AppRoutes.productDetail,
            name: "productDetail",
            pageBuilder: (context, state) {
              final productId = state.pathParameters['id']!;
              return AppPageTransitions.heroZoom(
                context,
                state,
                ProductDetailPage(productId: productId),
              );
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
}

// Updated MainAppShell with smoother tab animations
class MainAppShell extends StatefulWidget {
  final Widget child;

  const MainAppShell({super.key, required this.child});

  @override
  State<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _tabAnimationController;
  late Animation<double> _tabAnimation;
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeView(),
    const ProductsPage(),
    const Scaffold(body: Center(child: Text('Cart'))),
    const Scaffold(body: Center(child: Text('Profile'))),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _tabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _tabAnimation = CurvedAnimation(
      parent: _tabAnimationController,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _tabAnimation,
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
            _updateRouteForIndex(index);
          },
          children: _pages,
        ),
        builder: (context, child) {
          return Transform.scale(
            scale: 0.95 + (0.05 * _tabAnimation.value),
            child: child,
          );
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          elevation: 0,
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
      ),
    );
  }

  void _updateRouteForIndex(int index) {
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

    // Animate tab change
    _tabAnimationController.forward().then((_) {
      _tabAnimationController.reverse();
    });

    // Animate to the selected page
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
    );
  }
}
