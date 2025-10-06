import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/app_routes.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.shopping_bag)),
              title: Text('Product ${index + 1}'),
              subtitle: Text('Description for product ${index + 1}'),
              trailing: const Text('\$99.99'),
              onTap: () {
                context.go(
                  AppRoutes.productDetail.replaceAll(':id', '${index + 1}'),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
