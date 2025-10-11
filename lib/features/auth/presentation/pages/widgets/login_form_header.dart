import 'package:flutter/material.dart';
import '../../../../../core/constents/app_colors.dart';
import '../../../../../core/constents/assets.dart';
import '../../../../../shared/widgets/text_widget.dart';
import '../../../../../shared/widgets/svg_handler.dart';

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
             const SvgHandler(
              height: 10,
              width: 10,
               assetPath: Assets.assetsIconsLogosvg,
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Sign in to your account',
          style: TextStyle(fontSize: 16, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
