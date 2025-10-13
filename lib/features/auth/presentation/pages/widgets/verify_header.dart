import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/routing/app_navigation.dart';
import '../../../../../shared/widgets/text_widget.dart';

class VerifyHeader extends StatelessWidget {
  final String? email;

  const VerifyHeader({super.key, this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Back Button and Title Row
          Row(
            children: [
              
              const Expanded(
                child: Center(
                  child: CustomTextWidget(
                    text: "Verification Code",
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 34), // Balance the back button
            ],
          ),

          // Email subtitle if provided
          if (email != null) ...[
            const SizedBox(height: 8),
            Text(
              "Code sent to $email",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
