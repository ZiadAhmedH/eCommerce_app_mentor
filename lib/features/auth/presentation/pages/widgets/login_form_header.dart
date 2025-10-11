import 'package:flutter/material.dart';
import '../../../../../core/constents/app_colors.dart';
import '../../../../../shared/widgets/text_widget.dart';

class LoginFormHeader extends StatelessWidget {
  const LoginFormHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextWidget.title28(
              'Welcome to',
              textAlign: TextAlign.center,
              color: AppColor.textdark,
            ),
            const SizedBox(width: 8),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColor.primaryColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Center(
                child: Text(
                  'L',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        CustomTextWidget(text: "Please enter your data to continue", color: AppColor.textgray, textAlign: TextAlign.center),

        const SizedBox(height: 40),
      ],
    );
  }
}