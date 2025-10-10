import 'package:flutter/material.dart';
import '../../core/constents/app_colors.dart';

class CustomFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? errorText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;
  final int maxLines;
  final TextCapitalization textCapitalization;

  const CustomFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.prefixIcon,
    this.errorText,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.maxLines = 1,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    final hasValue = widget.controller.text.isNotEmpty;
    final isActive = _isFocused || hasValue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasError
                  ? Colors.red
                  : _isFocused
                  ? AppColor.primaryColor
                  : Colors.grey[300]!,
              width: _isFocused ? 2 : 1,
            ),
            color: widget.enabled ? Colors.white : Colors.grey[50],
          ),
          child: Stack(
            children: [
              // Main TextField
              TextFormField(
                controller: widget.controller,
                focusNode: _focusNode,
                obscureText: widget.obscureText,
                keyboardType: widget.keyboardType,
                enabled: widget.enabled,
                maxLines: widget.maxLines,
                textCapitalization: widget.textCapitalization,
                onChanged: (value) {
                  setState(() {}); // Rebuild to update label position
                  widget.onChanged?.call(value);
                },
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: isActive ? widget.hintText : null,
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
                  contentPadding: EdgeInsets.only(
                    left: widget.prefixIcon != null ? 16 : 16,
                    right: widget.suffixIcon != null ? 16 : 16,
                    top: 20,
                    bottom: 12,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  prefixIcon: widget.prefixIcon,
                  suffixIcon: widget.suffixIcon,
                ),
                validator: widget.validator,
              ),

              // Floating Label
              Positioned(
                left: widget.prefixIcon != null ? 52 : 16,
                top: isActive ? 8 : 16,
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: isActive ? 12 : 16,
                    color: hasError
                        ? Colors.red
                        : isActive
                        ? AppColor.primaryColor
                        : Colors.grey[600],
                    fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
                  ),
                  child: Text(widget.labelText),
                ),
              ),
            ],
          ),
        ),

        // Error Text
        if (hasError) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              widget.errorText!,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.red,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],

          ],
    );
  }
}
