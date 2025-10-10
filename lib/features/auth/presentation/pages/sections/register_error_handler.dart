import 'package:flutter/material.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/errors/faliure_calsses.dart';

mixin RegisterErrorHandler {
  void handleRegisterError(
    Failure failure,
    Function(Map<String, String?>) setFieldErrors,
    Function() clearFieldErrors,
    BuildContext context,
  ) {
    print('🐛 Handling register error: ${failure.runtimeType}');
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
    print('⚠️ General error: ${failure.message}');
    clearFieldErrors();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(failure.message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
