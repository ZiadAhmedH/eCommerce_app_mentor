import 'package:json_annotation/json_annotation.dart';

part 'api_error_model.g.dart';

@JsonSerializable()
class ApiErrorModel {
  final int statusCode;
  final String message;
  final Map<String, List<String>>? errors;

  const ApiErrorModel({
    required this.statusCode,
    required this.message,
    this.errors,
  });

  factory ApiErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApiErrorModelToJson(this);

  String get formattedErrorMessage {
    if (errors == null || errors!.isEmpty) return message;
    
    final errorMessages = <String>[];
    errors!.forEach((field, messages) {
      errorMessages.addAll(messages.map((msg) => '• $msg'));
    });
    
    return errorMessages.join('\n');
  }

  // Helper method to get specific field errors
  List<String> getFieldErrors(String field) {
    return errors?[field] ?? [];
  }
}