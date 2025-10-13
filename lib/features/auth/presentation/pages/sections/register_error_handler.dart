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
    print('⚠️ Handling general error: ${failure.message}');
    clearFieldErrors();

    // Use a post-frame callback to ensure UI is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        _showErrorMessage(context, failure.message);
      }
    });
  }

  void _showErrorMessage(BuildContext context, String message) {
    print('🔄 Attempting to show error message: $message');

    // Check if context is mounted
    if (!context.mounted) {
      print('❌ Context not mounted, cannot show SnackBar');
      return;
    }

    try {
      // Find the nearest ScaffoldMessenger
      final scaffoldMessenger = ScaffoldMessenger.of(context);

      print('🔍 ScaffoldMessenger found, showing SnackBar');

      // Clear existing snackbars
      scaffoldMessenger.clearSnackBars();

      // Show the error snackbar
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          action: SnackBarAction(
            label: 'OK',
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

      // Try alternative approach - direct context
      _showAlternativeError(context, message);
    }
  }

  void _showAlternativeError(BuildContext context, String message) {
    print('🔄 Trying alternative error display');

    try {
      // Try using the root navigator context
      final rootContext = Navigator.of(context, rootNavigator: true).context;

      showDialog(
        context: rootContext,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 24),
                SizedBox(width: 8),
                Text('Error'),
              ],
            ),
            content: Text(message, style: const TextStyle(fontSize: 16)),
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

      print('✅ Alternative error dialog shown');
    } catch (dialogError) {
      print('❌ Alternative error dialog failed: $dialogError');

      // Last resort - print to debug console
      debugPrint('🚨 CRITICAL ERROR (UI Failed): $message');

      // Try one more simple approach
      _showSimpleSnackBar(context, message);
    }
  }

  void _showSimpleSnackBar(BuildContext context, String message) {
    try {
      // Very simple approach
      final snackBar = SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print('✅ Simple SnackBar shown');
    } catch (e) {
      print('❌ Even simple SnackBar failed: $e');

      // Absolutely final fallback - just print
      print('🚨 FINAL ERROR MESSAGE: $message');
    }
  }

  // Enhanced success message with better error handling
  void showSuccessMessage(BuildContext context, String message) {
    if (!context.mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
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
                      style: const TextStyle(color: Colors.white, fontSize: 14),
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
    });
  }

  // Enhanced loading message
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
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.blue,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    } catch (e) {
      print('❌ Loading SnackBar failed: $e');
    }
  }
}
