class AppRoutes {
  // Auth routes
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Main app routes
  static const String home = '/';
  static const String products = '/products';
  static const String productDetail = '/product/:id';
  static const String categories = '/categories';
  static const String category = '/category/:categoryId';

  // Cart and checkout
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orderConfirmation = '/order-confirmation';

  // Profile routes
  static const String profile = '/profile';
  static const String orders = '/orders';
  static const String orderDetail = '/order/:orderId';
  static const String settings = '/settings';

  // Search
  static const String search = '/search';

  // onboarding
  static const String onboarding = '/onboarding';
}
