import 'package:flutter/material.dart';

class VerifyView extends StatelessWidget {
  const VerifyView({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: const Center(
        child: Text('Verify Email Page'),
      ),
    );
  }
}