import 'package:flutter/material.dart';
import '../../../../core/constents/app_colors.dart';
import '../../../../core/constents/assets.dart';

class OnboardingBackground extends StatelessWidget {
  const OnboardingBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          tileMode: TileMode.mirror,
          end: Alignment.bottomCenter,
          colors: [AppColor.gradientStart, AppColor.gradientEnd],
        ),
      ),
      child: Image.asset(
        Assets.assetsImagesManChair,
        height: 812,
        width: 375,
        fit: BoxFit.cover,
      ),
    );
  }
}
