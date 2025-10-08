import 'package:flutter/material.dart';
import '../../../../core/constents/app_colors.dart';
import '../../../../shared/widgets/text_widget.dart';
import 'gender_selection_section.dart';
import 'onboarding_header_section.dart';

class OnboardingContentCard extends StatelessWidget {
  final String selectedGender;
  final ValueChanged<String> onGenderChanged;
  final VoidCallback onSkip;

  const OnboardingContentCard({
    super.key,
    required this.selectedGender,
    required this.onGenderChanged,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      height: 244,
      width: MediaQuery.sizeOf(context).width - 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const OnboardingHeaderSection(),

          const SizedBox(height: 10),

          GenderSelectionSection(
            selectedGender: selectedGender,
            onGenderChanged: onGenderChanged,
          ),

          const SizedBox(height: 4),

          TextButton(
            onPressed: onSkip,
            child: CustomTextWidget(
              text: "Skip",
              fontSize: 17,
              color: AppColor.textgray,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
