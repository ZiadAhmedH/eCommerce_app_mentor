import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/navigation_helper.dart';

extension NavigationExtension on BuildContext {
  void goTo(String path, {Object? extra}) => go(path, extra: extra);
  void pushTo(String path, {Object? extra}) => push(path, extra: extra);
  void popPage([Object? result]) => pop(result);
  
  void goToNamed(String name, {Map<String, String>? pathParameters, Map<String, dynamic>? queryParameters, Object? extra}) {
    goNamed(name,  extra: extra);
  }
  
  void pushToNamed(String name, {Map<String, String>? pathParameters, Map<String, dynamic>? queryParameters, Object? extra}) {
    pushNamed(name,  extra: extra);
  }
  
  void replaceTo(String path, {Object? extra}) => pushReplacement(path, extra: extra);
  void replaceToNamed(String name, {Map<String, String>? pathParameters, Map<String, dynamic>? queryParameters, Object? extra}) {
    pushReplacementNamed(name,pathParameters: pathParameters ?? {} , extra: extra);
  }
  
  void clearAndGoTo(String path, {Object? extra}) => NavigationHelper.pushAndClearStack(path, extra: extra);
  
  bool get canGoBack => canPop();
  
  void showSuccess(String message) => NavigationHelper.showSuccessSnackBar(message);
  void showError(String message) => NavigationHelper.showErrorSnackBar(message);
  void showWarning(String message) => NavigationHelper.showWarningSnackBar(message);
  void showMessage(String message) => NavigationHelper.showSnackBar(message: message);
}