import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RegisterDebugInfo extends StatelessWidget {
  final Map<String, String?> fieldErrors;

  const RegisterDebugInfo({
    super.key,
    required this.fieldErrors,
  });

  @override
  Widget build(BuildContext context) {
    
           
    return fieldErrors.isNotEmpty ? Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Debug Info:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          Text(
            'Field Errors: $fieldErrors',
            style: const TextStyle(fontSize: 10),
          ),
          Text(
            'Has firstName error: ${fieldErrors.containsKey('firstName')}',
            style: const TextStyle(fontSize: 10),
          ),
          Text(
            'Has lastName error: ${fieldErrors.containsKey('lastName')}',
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    ) : const SizedBox.shrink();
  }
}