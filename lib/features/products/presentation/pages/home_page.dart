import 'package:ecommerce_app/core/services/secure_storage_service.dart';
import 'package:ecommerce_app/shared/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/app_routes.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Navigate to search
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to Ecommerce App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('Featured Products'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => context.go(AppRoutes.products),
                      child: const Text('View All Products'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            CustomTextWidget(text: "${SecureTokenStorage.getAccessToken().toString()}")
          ],
        ),
      ),
    );
  }
}
