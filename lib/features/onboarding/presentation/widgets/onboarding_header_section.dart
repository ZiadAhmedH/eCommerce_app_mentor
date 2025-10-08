import 'package:flutter/material.dart';
import '../../../../core/constents/app_colors.dart';
import '../../../../shared/widgets/text_widget.dart';

class OnboardingHeaderSection extends StatelessWidget {
  const OnboardingHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextWidget.title24(
          "Look Good, Feel Good",
          color: AppColor.textdark,
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 10),

        CustomTextWidget.subtitleNormal(
          "Create your individual & unique style and look amazing everyday.",
          color: AppColor.textgray,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
