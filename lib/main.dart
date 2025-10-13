import 'package:flutter/material.dart';
import 'core/routing/app_router.dart';
import 'core/di/dependency_injection.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  
  
  await setupDependencyInjection();

  
  
  runApp(const MyApp());
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Ecommerce App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      routerConfig: AppRouter.router,
    );
  }
}
