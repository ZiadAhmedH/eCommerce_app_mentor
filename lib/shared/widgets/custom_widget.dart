import 'package:ecommerce_app/shared/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import '../../core/constents/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;
  final double borderRadius;
  final Widget? icon;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 56,
    this.borderRadius = 10,
    this.icon,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Determine colors based on state and style
    Color getBackgroundColor() {
      if (backgroundColor != null) return backgroundColor!;
      if (isOutlined) return Colors.transparent;
      if (onPressed == null) return Colors.grey.shade300;
      return AppColor.primaryColor;
    }

    Color getTextColor() {
      if (textColor != null) return textColor!;
      if (isOutlined) return AppColor.primaryColor;
      if (onPressed == null) return Colors.grey.shade600;
      return Colors.white;
    }

    Color getBorderColor() {
      if (isOutlined) {
        return onPressed == null ? Colors.grey.shade300 : AppColor.primaryColor;
      }
      return Colors.transparent;
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: getBackgroundColor(),
          foregroundColor: getTextColor(),
          elevation: isOutlined ? 0 : (onPressed == null ? 0 : 2),
          shadowColor: AppColor.primaryColor.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(
              color: getBorderColor(),
              width: isOutlined ? 1.5 : 0,
            ),
          ),
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isOutlined ? AppColor.primaryColor : Colors.white,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: 8),
                  ],
                  Column(
                    children: [
                      CustomTextWidget(text: text,
                          color: getTextColor(),
                          fontSize: 17,
                          fontWeight: FontWeight.w500,),
                      const Spacer()
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

// Specialized button variants for common use cases
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      isOutlined: true,
      icon: icon,
    );
  }
}

class SmallButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;

  const SmallButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      isOutlined: isOutlined,
      height: 40,
      borderRadius: 8,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}