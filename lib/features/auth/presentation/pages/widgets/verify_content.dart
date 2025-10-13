import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../../../../../core/constents/app_colors.dart';
import '../../../../../core/constents/assets.dart';

class VerifyContent extends StatefulWidget {
  final String? email;
  final TextEditingController pinController = TextEditingController();

  VerifyContent({super.key, this.email});

  @override
  State<VerifyContent> createState() => _VerifyContentState();
}

class _VerifyContentState extends State<VerifyContent> {
  final FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    widget.pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Cloud Lock Illustration
          Image.asset(
            Assets.assetsObjectsLock,
            height: 200,
          ),
          const SizedBox(height: 40),

          // PIN Input Field
          Pinput(
            length: 6,
            controller: widget.pinController,
            focusNode: focusNode,
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: defaultPinTheme.copyDecorationWith(
              border: Border.all(color: AppColor.primaryColor, width: 2),
            ),
            submittedPinTheme: defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration?.copyWith(
                color: AppColor.gradientStart.withOpacity(0.1),
              ),
            ),
            onCompleted: (pin) {
              // Store the PIN for access from parent
              _onPinCompleted(pin);
            },
          ),

          const SizedBox(height: 20),

          // Instruction text
          Text(
            "Enter the 6-digit code sent to your email",
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  void _onPinCompleted(String pin) {
    // You can add validation or other logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('PIN entered: $pin'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

 String get currentPin => widget.pinController.text;
   
   
     

}
