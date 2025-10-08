import 'package:flutter/material.dart';
import '../../../../core/constents/app_colors.dart';
import '../../../../shared/widgets/text_widget.dart';

class GenderSelectionSection extends StatelessWidget {
  final String selectedGender;
  final ValueChanged<String> onGenderChanged;

  const GenderSelectionSection({
    super.key,
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: _GenderButton(
            gender: 'Men',
            isSelected: selectedGender == 'Men',
            onTap: () => onGenderChanged('Men'),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _GenderButton(
            gender: 'Women',
            isSelected: selectedGender == 'Woman',
            onTap: () => onGenderChanged('Woman'),
          ),
        ),
      ],
    );
  }
}

class _GenderButton extends StatelessWidget {
  final String gender;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderButton({
    required this.gender,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? Color(AppColor.primaryColor)
            : AppColor.backgroundLight,
        foregroundColor: isSelected ? Colors.white : AppColor.textdark,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: CustomTextWidget(
        text: gender,
        color: isSelected ? Colors.white : AppColor.textgray,
        fontSize: 17,
        fontWeight: FontWeight.w500,
        maxLines: 1,
      ),
    );
  }
}
