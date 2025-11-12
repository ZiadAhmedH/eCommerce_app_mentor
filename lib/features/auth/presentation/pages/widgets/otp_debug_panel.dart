import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTPDebugPanel extends StatelessWidget {
  final String email;
  final String currentOTP;
  final VoidCallback onCopyEmail;
  final VoidCallback onRefresh;

  const OTPDebugPanel({
    super.key,
    required this.email,
    required this.currentOTP,
    required this.onCopyEmail,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            children: [
              Icon(Icons.bug_report, color: Colors.orange, size: 20),
              SizedBox(width: 8),
              Text(
                'DEBUG INFO',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const Divider(height: 16),

          _buildInfoRow('Email', email, canCopy: true),
          _buildInfoRow(
            'Current OTP',
            currentOTP.isEmpty ? 'Not entered' : currentOTP,
            canCopy: currentOTP.isNotEmpty,
          ),
          _buildInfoRow('OTP Length', '${currentOTP.length}/6'),
          _buildInfoRow('Is Numeric', '${int.tryParse(currentOTP) != null}'),
          _buildInfoRow('Has Spaces', '${currentOTP.contains(' ')}'),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onCopyEmail,
                  icon: const Icon(Icons.copy, size: 16),
                  label: const Text(
                    'Copy Email',
                    style: TextStyle(fontSize: 12),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onRefresh,
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Resend', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.yellow.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '⚠️ Common Issues:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                ),
                SizedBox(height: 4),
                Text(
                  '• Check spam/junk folder',
                  style: TextStyle(fontSize: 10),
                ),
                Text(
                  '• OTP expires after 10 minutes',
                  style: TextStyle(fontSize: 10),
                ),
                Text(
                  '• Ensure no extra spaces',
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool canCopy = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 11),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (canCopy && value.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: value));
                    },
                    child: const Icon(Icons.copy, size: 12, color: Colors.blue),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
