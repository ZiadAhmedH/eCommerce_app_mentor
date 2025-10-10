import 'package:flutter/material.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final String password;

  const PasswordStrengthIndicator({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    final strength = _calculatePasswordStrength(password);
    final strengthText = _getStrengthText(strength);
    final strengthColor = _getStrengthColor(strength);

    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 6),
      child: Row(
        children: [
          // Strength bars
          Row(
            children: List.generate(4, (index) {
              return Container(
                width: 20,
                height: 3,
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  color: index < strength ? strengthColor : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          ),
          const SizedBox(width: 8),
          Text(
            strengthText,
            style: TextStyle(
              fontSize: 12,
              color: strengthColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  int _calculatePasswordStrength(String password) {
    if (password.isEmpty) return 0;

    int strength = 0;

    // Length check
    if (password.length >= 8) strength++;

    // Uppercase check
    if (password.contains(RegExp(r'[A-Z]'))) strength++;

    // Lowercase check
    if (password.contains(RegExp(r'[a-z]'))) strength++;

    // Number or special character check
    if (password.contains(RegExp(r'[0-9!@#$%^&*(),.?":{}|<>]'))) strength++;

    return strength;
  }

  String _getStrengthText(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return 'Weak';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Strong';
      default:
        return 'Weak';
    }
  }

  Color _getStrengthColor(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.blue;
      case 4:
        return Colors.green;
      default:
        return Colors.red;
    }
  }
}
