import 'dart:convert';
import 'package:flutter/foundation.dart';

class Logger {
  static void log(String message, [String? tag]) {
    if (kDebugMode) {
      print('${tag ?? 'APP'}: $message');
    }
  }

  static void logError(String message, [String? tag, Object? error]) {
    if (kDebugMode) {
      print('ERROR ${tag ?? 'APP'}: $message');
      if (error != null) {
        print('Error details: $error');
      }
    }
  }
}

class DateTimeHelper {
  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  static String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
  }
}

class JsonHelper {
  static Map<String, dynamic>? parseJson(String jsonString) {
    try {
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      Logger.logError('Failed to parse JSON', 'JsonHelper', e);
      return null;
    }
  }

  static String? stringifyJson(Map<String, dynamic> data) {
    try {
      return json.encode(data);
    } catch (e) {
      Logger.logError('Failed to stringify JSON', 'JsonHelper', e);
      return null;
    }
  }
}
