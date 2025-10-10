import 'package:ecommerce_app/shared/widgets/text_widget.dart';
import 'package:ecommerce_app/shared/widgets/svg_handler.dart';
import 'package:ecommerce_app/core/constents/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constents/assets.dart';

class RegisterFormHeader extends StatelessWidget {
  const RegisterFormHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextWidget.title28(
              'Join',
              textAlign: TextAlign.center,
              color: AppColor.textdark,
            ),
            const SizedBox(width: 8),
            SvgHandler.logo(
              assetPath: Assets.assetsIconsLogosvg,
              height: 28,
              width: 28,
              color: AppColor.primaryColor,
              fallbackText: 'laza',
              fallbackWidget: Container(
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
              onError: () {
                print('⚠️ Failed to load logo SVG');
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Create your account to get started',
          style: TextStyle(fontSize: 16, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
