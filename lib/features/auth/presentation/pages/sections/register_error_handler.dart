import 'package:flutter/material.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/errors/faliure_calsses.dart';

mixin AuthErrorHandler {
  void handleAuthError(
    Failure failure,
    Function(Map<String, String?>) setFieldErrors,
    Function() clearFieldErrors,
    BuildContext context,
  ) {
    print('🐛 Handling auth error: ${failure.runtimeType}');
    print('🐛 Error message: ${failure.message}');
    print('🐛 Error details: ${failure.details}');

    if (failure is ValidationFailure) {
      print(
        '🔍 ValidationFailure - Field errors received: ${failure.fieldErrors}',
      );
      _handleFieldErrors(failure.fieldErrors, setFieldErrors);
    } else if (failure is ServerFailure) {
      print('🔍 ServerFailure - Checking for field errors in details');

      // Check if ServerFailure contains field errors in details
      if (failure.details != null && failure.details!.containsKey('errors')) {
        final errors = failure.details!['errors'];
        print('🔍 ServerFailure - Found errors in details: $errors');

        if (errors is Map<String, dynamic>) {
          Map<String, List<String>> fieldErrors = {};

          errors.forEach((key, value) {
            if (value is List) {
              fieldErrors[key] = value.map((item) => item.toString()).toList();
            } else if (value is String) {
              fieldErrors[key] = [value];
            }
          });

          print('🔍 ServerFailure - Extracted field errors: $fieldErrors');
          _handleFieldErrors(fieldErrors, setFieldErrors);
          return; // Don't show general error if we have field errors
        }
      }

      // If no field errors, show general server error
      _handleGeneralError(failure, clearFieldErrors, context);
    } else {
      // Handle other types of failures
      print('⚠️ Other failure type: ${failure.runtimeType}');
      _handleGeneralError(failure, clearFieldErrors, context);
    }
  }

  void _handleFieldErrors(
    Map<String, List<String>>? fieldErrors,
    Function(Map<String, String?>) setFieldErrors,
  ) {
    if (fieldErrors == null || fieldErrors.isEmpty) return;

    final Map<String, String?> formattedErrors = {};
    fieldErrors.forEach((field, errors) {
      if (errors.isNotEmpty) {
        // Join multiple errors with line breaks
        formattedErrors[field] = errors.join('\n');
        print('📝 Setting error for field "$field": ${formattedErrors[field]}');
      }
    });

    setFieldErrors(formattedErrors);
    print('🎯 Final field errors map: $formattedErrors');
  }

  void _handleGeneralError(
    Failure failure,
    Function() clearFieldErrors,
    BuildContext context,
  ) {
    print('⚠️ Attempting to show general error: ${failure.message}');
    clearFieldErrors();

    // Try multiple approaches to show the error
    _showErrorMessage(context, failure.message);
  }

  void _showErrorMessage(BuildContext context, String message) {
    // Method 1: Try with mounted check
    if (!context.mounted) {
      print('❌ Context not mounted, cannot show SnackBar');
      return;
    }

    try {
      // Method 2: Use ScaffoldMessenger with context
      final scaffoldMessenger = ScaffoldMessenger.of(context);

      // Clear any existing snackbars first
      scaffoldMessenger.clearSnackBars();

      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          action: SnackBarAction(
            label: 'Dismiss',
            textColor: Colors.white,
            onPressed: () {
              scaffoldMessenger.hideCurrentSnackBar();
            },
          ),
        ),
      );

      print('✅ SnackBar shown successfully');
    } catch (snackBarError) {
      print('❌ SnackBar failed: $snackBarError');

      // Method 3: Fallback to AlertDialog
      _showErrorDialog(context, message);
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    print('🔄 Falling back to AlertDialog');

    try {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red),
                SizedBox(width: 8),
                Text('Error'),
              ],
            ),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: const Text('OK'),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          );
        },
      );

      print('✅ AlertDialog shown successfully');
    } catch (dialogError) {
      print('❌ AlertDialog also failed: $dialogError');

      // Method 4: Last resort - print to console and debug print
      debugPrint('🚨 CRITICAL ERROR (UI Failed): $message');
    }
  }

  // Helper method to show success messages
  void showSuccessMessage(BuildContext context, String message) {
    if (!context.mounted) return;

    try {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.clearSnackBars();

      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    } catch (e) {
      print('❌ Success SnackBar failed: $e');
    }
  }

  // Helper method to show loading messages
  void showLoadingMessage(BuildContext context, String message) {
    if (!context.mounted) return;

    try {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.clearSnackBars();

      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.blue,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    } catch (e) {
      print('❌ Loading SnackBar failed: $e');
    }
  }
}
